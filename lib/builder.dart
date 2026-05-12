import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/json_fields_generator.dart';

/// Builder factory for the JSON fields generator.
///
/// This builder generates `$ClassNameFields` extension types for classes
/// annotated with `@JsonSerializable()`.
///
/// ## Options
///
/// - `separator` (`String`, default `.`): the string used to join nested
///   field path segments. Configure via `build.yaml`:
///
///   ```yaml
///   targets:
///     $default:
///       builders:
///         json_fields|json_fields:
///           options:
///             separator: '/'
///   ```
Builder jsonFieldsBuilder(BuilderOptions options) {
  final separator = options.config['separator'] as String? ?? '.';
  return SharedPartBuilder([
    JsonFieldsGenerator(separator: separator),
  ], 'json_fields');
}
