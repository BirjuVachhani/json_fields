import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:json_fields/builder.dart';
import 'package:test/test.dart';

const _modelSource = r'''
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Address {
  final String street;
  final String city;

  Address({required this.street, required this.city});
}

@JsonSerializable(fieldRename: FieldRename.snake)
class User {
  final String firstName;
  final Address homeAddress;

  User({required this.firstName, required this.homeAddress});
}
''';

Future<String> _runWithSeparator(String? separator) async {
  final config = separator == null
      ? <String, dynamic>{}
      : <String, dynamic>{'separator': separator};
  final builder = jsonFieldsBuilder(BuilderOptions(config));

  // Make `package:json_annotation` resolvable inside the synthetic source.
  final readerWriter = TestReaderWriter(rootPackage: 'a');
  await readerWriter.testing.loadIsolateSources();

  final result = await testBuilder(
    builder,
    {'a|lib/model.dart': _modelSource},
    rootPackage: 'a',
    readerWriter: readerWriter,
    flattenOutput: true,
    onLog: (_) {}, // suppress unrelated framework logs
  );

  expect(result.succeeded, isTrue, reason: result.errors.join('\n'));

  final partAsset = result.outputs.singleWhere(
    (a) => a.path.endsWith('.json_fields.g.part'),
    orElse: () => throw StateError(
      'No .json_fields.g.part output. Got: ${result.outputs}',
    ),
  );
  return result.readerWriter.readAsString(partAsset);
}

void main() {
  group('JsonFieldsGenerator separator option', () {
    test(r'default separator emits "$_prefix.$field" form', () async {
      final out = await _runWithSeparator(null);
      expect(out, contains(r"_prefix.isEmpty ? field : '$_prefix.$field'"));
      // Field path expressions are also dotted by default.
      expect(out, contains(r"_join('home_address')"));
    });

    test(r'"/" separator emits "$_prefix/$field" form (no braces)', () async {
      final out = await _runWithSeparator('/');
      expect(out, contains(r"_prefix.isEmpty ? field : '$_prefix/$field'"));
      // Field names themselves are unchanged.
      expect(out, contains(r"_join('home_address')"));
    });

    test(r'"-" separator emits "$_prefix-$field" form (no braces)', () async {
      final out = await _runWithSeparator('-');
      expect(out, contains(r"_prefix.isEmpty ? field : '$_prefix-$field'"));
    });

    test(
      r'"__" separator emits "${_prefix}__$field" (braces required)',
      () async {
        final out = await _runWithSeparator('__');
        expect(
          out,
          contains(r"_prefix.isEmpty ? field : '${_prefix}__$field'"),
        );
      },
    );

    test(r'"::" separator emits "$_prefix::$field" form', () async {
      final out = await _runWithSeparator('::');
      expect(out, contains(r"_prefix.isEmpty ? field : '$_prefix::$field'"));
    });

    test(r'"$" separator escapes the literal $', () async {
      final out = await _runWithSeparator(r'$');
      expect(out, contains(r"_prefix.isEmpty ? field : '$_prefix\$$field'"));
    });

    test("\"'\" separator escapes the literal quote", () async {
      final out = await _runWithSeparator("'");
      expect(out, contains(r"_prefix.isEmpty ? field : '$_prefix\'$field'"));
    });

    test(r'"\\" separator escapes the literal backslash', () async {
      final out = await _runWithSeparator(r'\');
      expect(out, contains(r"_prefix.isEmpty ? field : '$_prefix\\$field'"));
    });

    test('digit-leading "9x" separator wraps prefix in braces', () async {
      final out = await _runWithSeparator('9x');
      expect(out, contains(r"_prefix.isEmpty ? field : '${_prefix}9x$field'"));
    });
  });
}
