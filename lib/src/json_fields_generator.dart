import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:source_gen/source_gen.dart';
import 'package:source_helper/source_helper.dart';

/// TypeChecker for @JsonSerializable annotation.
const _jsonSerializableChecker = TypeChecker.typeNamed(
  JsonSerializable,
  inPackage: 'json_annotation',
);

/// TypeChecker for @JsonKey annotation.
const _jsonKeyChecker = TypeChecker.typeNamed(
  JsonKey,
  inPackage: 'json_annotation',
);

/// Generator for @JsonSerializable annotation that creates type-safe
/// field accessors.
///
/// For each class annotated with `@JsonSerializable`, this generates an
/// extension type `$ClassNameFields` that provides:
/// - Type-safe access to JSON field names
/// - Nested field path support (e.g., `address.city`)
/// - Respects @JsonKey(name:) and fieldRename configurations
/// - Includes inherited fields from parent classes
/// - Generates Fields types for external @JsonSerializable types that may
///   not have their own generated code
///
/// Example:
/// ```dart
/// @JsonSerializable(fieldRename: FieldRename.snake)
/// class User {
///   final String firstName;
///   final Address address;
///
///   // Add this to enable User.fields
///   static const fields = $UserFields();
/// }
///
/// // Usage:
/// User.fields.firstName         // 'first_name'
/// User.fields.address.city      // 'address.city'
/// ```
class JsonFieldsGenerator extends Generator {
  /// Creates a generator that joins nested field paths using [separator].
  ///
  /// Defaults to `.`, matching Firestore / Firebase Realtime DB document-path
  /// conventions. Configure via builder options in `build.yaml`.
  JsonFieldsGenerator({this.separator = '.'});

  /// The string inserted between segments of a nested path.
  ///
  /// For example, with `separator: '/'` the generated `_join` method produces
  /// `'address/city'` instead of the default `'address.city'`.
  final String separator;

  @override
  String generate(LibraryReader library, BuildStep buildStep) {
    final buffer = StringBuffer();
    final generatedTypeNames = <String>{};
    final pendingExternalTypes = <ClassElement>[];

    // Phase 1: Generate extension types for all local @JsonSerializable classes
    for (final annotated in library.annotatedWith(_jsonSerializableChecker)) {
      final element = annotated.element;
      if (element is! ClassElement) continue;

      final className = element.name;
      if (className == null) continue;

      final typeName = '\$${className}Fields';
      generatedTypeNames.add(typeName);

      final fieldRename = _getFieldRename(annotated.annotation);
      final fields = _extractFields(element, fieldRename);

      if (buffer.isNotEmpty) buffer.writeln();
      buffer.write(_generateExtensionType(className, fields));

      // Collect external nested types that need Fields generated
      _collectExternalNestedTypes(
        fields,
        library.element,
        generatedTypeNames,
        pendingExternalTypes,
      );
    }

    // Phase 2: Generate extension types for external @JsonSerializable types
    // These are types from other packages whose Fields types may not exist.
    while (pendingExternalTypes.isNotEmpty) {
      final externalElement = pendingExternalTypes.removeAt(0);
      final name = externalElement.name;
      if (name == null) continue;

      final typeName = '\$${name}Fields';
      if (generatedTypeNames.contains(typeName)) continue;
      generatedTypeNames.add(typeName);

      final fieldRename = _getFieldRenameForElement(externalElement);
      final fields = _extractFields(externalElement, fieldRename);

      buffer.writeln();
      buffer.write(_generateExtensionType(name, fields));

      // Recursively collect more external nested types
      _collectExternalNestedTypes(
        fields,
        library.element,
        generatedTypeNames,
        pendingExternalTypes,
      );
    }

    return buffer.toString();
  }

  /// Collects external @JsonSerializable types from fields that need
  /// Fields extension types generated locally.
  ///
  /// Only collects types from external packages (different package name).
  /// Types from the same package are processed by their own library's
  /// generator run.
  void _collectExternalNestedTypes(
    List<_FieldInfo> fields,
    LibraryElement currentLibrary,
    Set<String> generatedTypeNames,
    List<ClassElement> pendingExternalTypes,
  ) {
    for (final field in fields) {
      if (field.nestedElement == null) continue;

      final typeName = '\$${field.nestedElement!.name}Fields';
      if (generatedTypeNames.contains(typeName)) continue;

      // Only generate for types from external packages
      if (!_isFromExternalPackage(field.nestedElement!, currentLibrary)) {
        continue;
      }

      pendingExternalTypes.add(field.nestedElement!);
    }
  }

  /// Checks if a class element is from a different package than the current
  /// library.
  ///
  /// Types from the same package will have their Fields types generated by
  /// json_fields when processing that library. Only external package types
  /// need to be generated locally.
  bool _isFromExternalPackage(
    ClassElement element,
    LibraryElement currentLibrary,
  ) {
    final elementPackage = _getPackageName(element.library.uri);
    final currentPackage = _getPackageName(currentLibrary.uri);

    // If we can't determine packages, be conservative and generate
    if (elementPackage == null || currentPackage == null) return true;

    return elementPackage != currentPackage;
  }

  /// Extracts the package name from a URI.
  ///
  /// Handles both `package:` and `asset:` URI schemes used during builds.
  String? _getPackageName(Uri uri) {
    if ((uri.scheme == 'package' || uri.scheme == 'asset') &&
        uri.pathSegments.isNotEmpty) {
      return uri.pathSegments.first;
    }
    return null;
  }

  /// Extracts FieldRename configuration from a @JsonSerializable annotation
  /// on a ClassElement.
  ///
  /// Used for external types where we read the annotation directly from
  /// the element rather than from the generator's annotation parameter.
  FieldRename _getFieldRenameForElement(ClassElement element) {
    final annotation = _jsonSerializableChecker.firstAnnotationOf(element);
    if (annotation == null) return FieldRename.none;
    return _getFieldRename(ConstantReader(annotation));
  }

  /// Extracts FieldRename configuration from @JsonSerializable annotation.
  FieldRename _getFieldRename(ConstantReader annotation) {
    final renameValue = annotation.peek('fieldRename');
    if (renameValue == null || renameValue.isNull) {
      return FieldRename.none;
    }

    // Extract enum index and convert to FieldRename
    final index = renameValue.objectValue.getField('index')?.toIntValue();
    if (index == null) return FieldRename.none;

    return FieldRename.values[index];
  }

  /// Extracts field information from a class, including inherited fields.
  List<_FieldInfo> _extractFields(
    ClassElement classElement,
    FieldRename fieldRename,
  ) {
    final fields = <_FieldInfo>[];
    final seenFieldNames = <String>{};

    // Traverse class hierarchy to collect all fields
    ClassElement? currentClass = classElement;
    while (currentClass != null) {
      for (final field in currentClass.fields) {
        if (!_isPublicInstanceField(field)) continue;

        final fieldName = field.name;
        // Skip fields without a name (shouldn't happen for real fields)
        if (fieldName == null) continue;

        // Skip if already added (child class takes precedence)
        if (seenFieldNames.contains(fieldName)) continue;
        seenFieldNames.add(fieldName);

        // Check if field should be ignored
        final jsonName = _getJsonFieldName(field, fieldName, fieldRename);
        if (jsonName == null) continue; // Field is ignored

        final nestedInfo = _getNestedTypeInfo(field.type);

        fields.add(
          _FieldInfo(
            dartName: fieldName,
            jsonName: jsonName,
            nestedTypeName: nestedInfo?.typeName,
            nestedElement: nestedInfo?.element,
          ),
        );
      }

      // Move to parent class
      final superType = currentClass.supertype;
      if (superType == null || superType.isDartCoreObject) break;
      currentClass = superType.element as ClassElement?;
    }

    return fields;
  }

  /// Checks if a field is a public, non-static instance field.
  bool _isPublicInstanceField(FieldElement field) {
    return !field.isStatic && !field.isPrivate && field.isOriginDeclaration;
  }

  /// Gets the JSON field name for a Dart field.
  ///
  /// Returns null if the field should be ignored (has @JsonKey(ignore: true)
  /// or @JsonKey(includeToJson: false, includeFromJson: false)).
  ///
  /// Priority:
  /// 1. Check for ignored field
  /// 2. @JsonKey(name: 'customName')
  /// 3. fieldRename transformation
  /// 4. Original field name
  String? _getJsonFieldName(
    FieldElement field,
    String fieldName,
    FieldRename fieldRename,
  ) {
    // Check for @JsonKey annotation on field or getter
    final jsonKeyAnnotation =
        _jsonKeyChecker.firstAnnotationOf(field) ??
        (field.getter != null
            ? _jsonKeyChecker.firstAnnotationOf(field.getter!)
            : null);

    if (jsonKeyAnnotation != null) {
      final reader = ConstantReader(jsonKeyAnnotation);

      // Check if field is explicitly ignored
      final ignore = reader.peek('ignore')?.boolValue ?? false;
      if (ignore) return null;

      // Check if field is excluded from both serialization directions
      final includeFromJson = reader.peek('includeFromJson')?.boolValue;
      final includeToJson = reader.peek('includeToJson')?.boolValue;
      if (includeFromJson == false && includeToJson == false) return null;

      // Check for explicit name override
      final explicitName = reader.peek('name')?.stringValue;
      if (explicitName != null) {
        return explicitName;
      }
    }

    // Apply fieldRename transformation
    return _applyFieldRename(fieldName, fieldRename);
  }

  /// Applies FieldRename transformation to a field name.
  ///
  /// Uses source_helper for identical behavior to json_serializable.
  String _applyFieldRename(String name, FieldRename rename) {
    return switch (rename) {
      FieldRename.none => name,
      FieldRename.snake => name.snake,
      FieldRename.screamingSnake => name.snake.toUpperCase(),
      FieldRename.kebab => name.kebab,
      FieldRename.pascal => name.pascal,
    };
  }

  /// Returns nested type info if the type is @JsonSerializable.
  ///
  /// Returns null for primitive types, collections, or
  /// non-JsonSerializable types. Returns both the extension type name
  /// and the ClassElement for the type.
  ({String typeName, ClassElement element})? _getNestedTypeInfo(DartType type) {
    // Collections don't have nested accessors
    if (_isCollection(type)) return null;

    final element = type.element;
    if (element is! ClassElement) return null;

    // Check if the type has @JsonSerializable annotation
    if (!_jsonSerializableChecker.hasAnnotationOf(element)) return null;

    return (typeName: '\$${element.name}Fields', element: element);
  }

  /// Checks if a type is a collection type.
  bool _isCollection(DartType type) {
    return type.isDartCoreList ||
        type.isDartCoreSet ||
        type.isDartCoreMap ||
        type.isDartCoreIterable;
  }

  /// Generates the extension type code.
  String _generateExtensionType(String className, List<_FieldInfo> fields) {
    final typeName = '\$${className}Fields';
    final escapedSep = _escapeDartStringLiteral(separator);
    // Use bare `$_prefix` when the separator's first character can't continue
    // the `_prefix` identifier (e.g. `.`, `/`, `-`). Otherwise use
    // `${_prefix}` to stop the lexer from extending the identifier into the
    // separator (e.g. for `__`, `0`, or letter separators).
    final prefixInterp = _separatorNeedsBraces(separator)
        ? r'${_prefix}'
        : r'$_prefix';

    final extType = ExtensionType(
      (b) => b
        ..name = typeName
        ..constant = true
        ..primaryConstructorName = '_'
        ..representationDeclaration = RepresentationDeclaration(
          (r) => r
            ..name = '_prefix'
            ..declaredRepresentationType = refer('String'),
        )
        ..implements.add(refer('String'))
        ..docs.addAll([
          '/// Field path accessors for [$className].',
          '///',
          '/// Usage:',
          '/// ```dart',
          '/// // Add to your class:',
          '/// static const fields = $typeName();',
          '/// ```',
        ])
        ..constructors.add(
          Constructor(
            (c) => c
              ..constant = true
              ..optionalParameters.add(
                Parameter(
                  (p) => p
                    ..name = 'prefix'
                    ..named = true
                    ..type = refer('String')
                    ..defaultTo = const Code("''"),
                ),
              )
              ..initializers.add(const Code('this._(prefix)')),
          ),
        )
        ..methods.add(
          Method(
            (m) => m
              ..name = '_join'
              ..returns = refer('String')
              ..requiredParameters.add(
                Parameter(
                  (p) => p
                    ..name = 'field'
                    ..type = refer('String'),
                ),
              )
              ..lambda = true
              ..body = Code(
                "_prefix.isEmpty ? field : '$prefixInterp$escapedSep\$field'",
              ),
          ),
        )
        ..methods.addAll(
          fields.map((field) {
            final escapedJsonName = _escapeDartStringLiteral(field.jsonName);
            if (field.nestedTypeName != null) {
              return Method(
                (m) => m
                  ..type = MethodType.getter
                  ..name = field.dartName
                  ..returns = refer(field.nestedTypeName!)
                  ..lambda = true
                  ..body = Code(
                    "${field.nestedTypeName}(prefix: _join('$escapedJsonName'))",
                  ),
              );
            }
            return Method(
              (m) => m
                ..type = MethodType.getter
                ..name = field.dartName
                ..returns = refer('String')
                ..lambda = true
                ..body = Code("_join('$escapedJsonName')"),
            );
          }),
        ),
    );

    final source = extType.accept(DartEmitter(useNullSafetySyntax: true));

    final buffer = StringBuffer();
    buffer.writeln('// coverage:ignore-start');
    buffer.writeln();
    buffer.writeln(source);
    buffer.writeln();
    buffer.writeln('// coverage:ignore-end');
    return buffer.toString();
  }
}

/// Escapes characters that have special meaning inside a single-quoted Dart
/// string literal: `\`, `'`, and `$`. The order of replacements matters:
/// backslashes must be escaped first.
String _escapeDartStringLiteral(String s) =>
    s.replaceAll(r'\', r'\\').replaceAll("'", r"\'").replaceAll(r'$', r'\$');

/// Returns `true` when the separator's first character could continue a
/// preceding identifier (`[a-zA-Z0-9_]`), forcing the emitter to wrap the
/// preceding `$identifier` in braces.
bool _separatorNeedsBraces(String separator) {
  if (separator.isEmpty) return false;
  final c = separator.codeUnitAt(0);
  return c == 0x5F /* _ */ ||
      (c >= 0x30 && c <= 0x39) /* 0-9 */ ||
      (c >= 0x41 && c <= 0x5A) /* A-Z */ ||
      (c >= 0x61 && c <= 0x7A) /* a-z */;
}

/// Internal class to hold field information during generation.
class _FieldInfo {
  final String dartName;
  final String jsonName;
  final String? nestedTypeName;
  final ClassElement? nestedElement;

  _FieldInfo({
    required this.dartName,
    required this.jsonName,
    this.nestedTypeName,
    this.nestedElement,
  });
}
