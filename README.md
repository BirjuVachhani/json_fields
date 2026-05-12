# json_fields

[![pub package](https://img.shields.io/pub/v/json_fields.svg)](https://pub.dev/packages/json_fields)
[![License: BSD-3-Clause](https://img.shields.io/badge/license-BSD--3--Clause-blue.svg)](LICENSE)

Type-safe, compile-time-checked JSON field path accessors for classes
annotated with [`@JsonSerializable`](https://pub.dev/packages/json_serializable).

Stop hardcoding string keys like `'first_name'` or `'address.city'` in Firebase
partial updates, query filters, and `Map<String, dynamic>` payloads.
`json_fields` plugs into your existing `json_serializable` setup and emits a
`$ClassNameFields` extension type alongside every `*.g.dart`, so the field
names become first-class identifiers your IDE auto-completes and the analyzer
verifies.

```dart
// Before
ref.update({'address.city': 'NYC'});

// After
ref.update({User.fields.address.city: 'NYC'});
```

If you rename `city` to `cityName`, the second line breaks at compile time.
The first line silently breaks at runtime.

---

## Table of contents

- [Features](#features)
- [Installation](#installation)
- [Quick start](#quick-start)
- [Behavior](#behavior)
  - [Nested `@JsonSerializable` types](#nested-jsonserializable-types)
  - [Inherited fields](#inherited-fields)
  - [Collections (`List`, `Set`, `Map`)](#collections-list-set-map)
  - [Types from external packages](#types-from-external-packages)
  - [Custom prefixes](#custom-prefixes)
  - [Custom path separators](#custom-path-separators)
- [Builder options](#builder-options)
- [Recipes](#recipes)
  - [Firebase Realtime Database / Firestore partial updates](#firebase-realtime-database--firestore-partial-updates)
  - [Firestore queries](#firestore-queries)
  - [Manual `Map<String, dynamic>` construction](#manual-mapstring-dynamic-construction)
- [Limitations](#limitations)
- [License](#license)

---

## Features

- **Type-safe field access**: `User.fields.firstName` instead of `'first_name'`.
- **Matches `json_serializable` output exactly**: accessor names mirror what
  `toJson` / `fromJson` produce, so any `@JsonSerializable` / `@JsonKey`
  configuration you set is automatically reflected.
- **Nested field paths**: `User.fields.address.city` resolves to
  `'address.city'`. Works for arbitrary depth.
- **Inherited fields**: pulls fields from parent classes too.
- **Cross-package nested types**: generates `Fields` accessors for
  `@JsonSerializable` types coming from other packages where they don't
  exist yet.
- **Custom prefix support**: construct accessors with a prefix to model
  arbitrary path roots (e.g. `users/$uid/...`).
- **Configurable path separator**: default `.` for Firestore-style paths,
  switchable to `/`, `__`, `::`, or anything else via a single builder option.
- **Implements `String`**: drop-in replacement anywhere a `String` key is
  expected, including `Map` literals and Firestore APIs.
- **Zero runtime overhead**: output is `extension type` declarations that
  erase to plain `String` at runtime. No allocations, no reflection.

---

## Installation

`json_fields` is a code generator. Add it to `dev_dependencies` along with
`json_serializable` and `build_runner`. You also need `json_annotation` as a
regular dependency:

```yaml
dependencies:
  json_annotation: ^4.11.0

dev_dependencies:
  build_runner: ^2.4.0
  json_fields: ^1.0.0
  json_serializable: ^6.13.0
```

Then run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

The builder runs automatically because it's marked `auto_apply: dependents`.
There is no `build.yaml` configuration required in your project.

---

## Quick start

Annotate your class with `@JsonSerializable` as you normally would, then add a
single line:

```dart
static const fields = $ClassNameFields();
```

Full example:

```dart
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class User {
  final String firstName;
  final String lastName;
  final Address address;

  User({
    required this.firstName,
    required this.lastName,
    required this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  // <-- enables User.fields
  static const fields = $UserFields();
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Address {
  final String street;
  final String city;

  Address({required this.street, required this.city});

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);

  static const fields = $AddressFields();
}
```

After running `build_runner`, the generated `*.g.dart` exposes
`$UserFields` and `$AddressFields`. Use them anywhere:

```dart
User.fields.firstName;        // 'first_name'
User.fields.lastName;         // 'last_name'
User.fields.address;          // returns $AddressFields, also a String
                              //   ('address')
User.fields.address.city;     // 'address.city'
```

The generated extension types **implement `String`**, so the values can be
used directly as keys without any casts.

---

## Behavior

`json_fields` reads the annotations you already use with `json_serializable`,
so the generated accessor names always match what `toJson` / `fromJson`
produces, including any `fieldRename`, `@JsonKey(name:)`, and exclusion
rules. See the
[`json_annotation` docs](https://pub.dev/packages/json_annotation) for the
full set of options.

The sections below cover behavior specific to `json_fields`.

### Nested `@JsonSerializable` types

When a field's type is itself annotated with `@JsonSerializable`, the
accessor returns the nested `$Fields` type so you can chain:

```dart
@JsonSerializable()
class Country {
  final String name;
  final String code;

  // ...
  static const fields = $CountryFields();
}

@JsonSerializable()
class FullAddress {
  final String street;
  final String city;
  final Country country;

  // ...
  static const fields = $FullAddressFields();
}

@JsonSerializable()
class Company {
  final String name;
  final FullAddress headquarters;

  // ...
  static const fields = $CompanyFields();
}

Company.fields.headquarters;                      // 'headquarters'
Company.fields.headquarters.street;               // 'headquarters.street'
Company.fields.headquarters.country.name;         // 'headquarters.country.name'
Company.fields.headquarters.country.code;         // 'headquarters.country.code'
```

Path joining respects `fieldRename`, so a snake-cased class produces
snake-cased nested paths:

```dart
@JsonSerializable(fieldRename: FieldRename.snake)
class SnakePerson {
  final String firstName;
  final SnakeAddress homeAddress;
  // ...
  static const fields = $SnakePersonFields();
}

SnakePerson.fields.homeAddress;                   // 'home_address'
SnakePerson.fields.homeAddress.streetName;        // 'home_address.street_name'
```

### Inherited fields

Fields from parent classes are walked up the hierarchy and included in the
child's accessors. Child fields take precedence on name conflicts.

```dart
abstract class BaseEntity {
  final String id;
  final DateTime createdAt;

  BaseEntity({required this.id, required this.createdAt});
}

@JsonSerializable()
class Product extends BaseEntity {
  final String name;
  final double price;

  Product({
    required super.id,
    required super.createdAt,
    required this.name,
    required this.price,
  });

  // ...
  static const fields = $ProductFields();
}

Product.fields.id;            // 'id'         (from BaseEntity)
Product.fields.createdAt;     // 'createdAt'  (from BaseEntity)
Product.fields.name;          // 'name'
Product.fields.price;         // 'price'
```

The traversal stops at `Object` and ignores supertypes that aren't classes.

### Collections (`List`, `Set`, `Map`)

Collection fields don't get nested accessors; they return a plain `String`.
This matches how Firestore / Realtime DB partial updates work: you typically
overwrite the entire collection instead of indexing into it.

```dart
@JsonSerializable()
class CollectionModel {
  final List<String> tags;
  final Set<int> numbers;
  final Map<String, dynamic> metadata;
  final List<Address> addresses;            // List<JsonSerializable> -> still a String

  // ...
  static const fields = $CollectionModelFields();
}

CollectionModel.fields.tags;          // 'tags'        (String)
CollectionModel.fields.addresses;     // 'addresses'   (String, no chaining)
```

If you need to address an indexed element, build the path yourself
(`'${Model.fields.tags}.0'`); the package intentionally doesn't pretend index
syntax is type-safe.

### Types from external packages

If a nested type lives in a different package and that package doesn't
include `json_fields` itself, the generator emits a `$Fields` extension type
locally so chaining still works:

```dart
// in your project
@JsonSerializable()
class MyModel {
  final SomeExternalType external;     // from another package, has @JsonSerializable
  // ...
  static const fields = $MyModelFields();
}
```

The generator walks the field's type, sees the `@JsonSerializable` annotation,
and synthesises `$SomeExternalTypeFields` in your `*.g.dart` automatically. It
recurses through external nested types as well.

Types from your own package are skipped during this phase, since their
`Fields` accessors will be generated when `json_fields` runs against their
own library.

### Custom prefixes

Every generated `$Fields` extension type has a public constructor that takes
an optional `prefix`:

```dart
extension type const $UserFields._(String _prefix) implements String {
  const $UserFields({String prefix = ''}) : this._(prefix);
  // ...
}
```

This is what powers nested chaining internally, but you can also use it
yourself when the JSON path lives under some non-class root, for example
when you store a `User` map under `users/$uid/...`:

```dart
final fields = $UserFields(prefix: 'users/abc123');

fields.firstName;                 // 'users/abc123.first_name'
fields.address.city;              // 'users/abc123.address.city'
```

The same instance is `const`-constructible, so you can stash it in a
`static const` if the prefix is fixed.

### Custom path separators

By default, nested paths join with `.`, the convention used by Firestore
document paths and most ORM-style update APIs. If you need a different
separator (e.g. `/` for Firebase Realtime Database paths, `__` for SQL
column aliases, `::` for namespaced keys), configure it once in your
project's `build.yaml`:

```yaml
# build.yaml (in the consuming project)
targets:
  $default:
    builders:
      json_fields|json_fields:
        options:
          separator: '/'
```

Re-run `dart run build_runner build` and the generated `_join` method will
use your separator instead:

```dart
User.fields.address.city;       // 'address/city'   (instead of 'address.city')
User.fields.address.zipCode;    // 'address/zip_code'
```

The separator only affects nested path joining; individual field names are
still produced by `FieldRename` / `@JsonKey(name:)` and are unchanged.

The separator applies project-wide to every generated `$Fields` type; it
isn't a per-class setting, by design. If you genuinely need different
separators in the same project, post-process the result:

```dart
final rtdbPath = User.fields.address.city.replaceAll('.', '/');
```

---

## Recipes

### Firebase Realtime Database / Firestore partial updates

The original motivation. Use the field accessors as map keys:

```dart
await firestore.collection('users').doc(uid).update({
  User.fields.firstName: 'John',
  User.fields.address.city: 'NYC',
  User.fields.address.zipCode: '10001',
});
```

Rename `firstName` to `givenName` in your model and the call breaks at
compile time.

### Firestore queries

Anywhere a `String` field name is expected:

```dart
firestore
    .collection('users')
    .where(User.fields.address.city, isEqualTo: 'NYC')
    .orderBy(User.fields.lastName);
```

### Manual `Map<String, dynamic>` construction

```dart
final payload = <String, dynamic>{
  User.fields.firstName: user.firstName,
  User.fields.lastName: user.lastName,
  User.fields.address: user.address.toJson(),
};
```

---

## Builder options

All options are configured in your project's `build.yaml` under the
`json_fields|json_fields` builder.

| Option       | Type     | Default | Description                                                                                                  |
| ------------ | -------- | ------- | ------------------------------------------------------------------------------------------------------------ |
| `separator`  | `String` | `.`     | The string inserted between segments of a nested field path (e.g. `address.city` vs `address/city`). See [Custom path separators](#custom-path-separators). |

Example combining the option with restrictive `generate_for` paths:

```yaml
# build.yaml
targets:
  $default:
    builders:
      json_fields|json_fields:
        enabled: true
        generate_for:
          - lib/**
        options:
          separator: '/'
```

If you don't need to override anything, you can omit `build.yaml` entirely;
the builder is registered with `auto_apply: dependents` and runs
automatically with sensible defaults.

---

## Limitations

- **Requires `@JsonSerializable`.** Plain Dart classes are skipped; the
  whole point is to mirror what `json_serializable` produces.
- **No collection element addressing.** Lists, Sets, and Maps return a
  `String` for the field itself; you can't chain `.0.street`-style paths.
  Build them by string concatenation if you need them.
- **`fromJson` constructors are not introspected.** Field discovery walks
  the class's declared fields, not the JSON shape. If your `fromJson`
  reads keys that don't correspond to declared fields, those keys won't
  appear in the accessors. (This is rare with `@JsonSerializable`.)
- **Generic type parameters aren't expanded.** A `List<T>` field is
  treated as a collection and returns a `String`.

---

## License

Licensed under the [BSD 3-Clause License](LICENSE).
