## Define your models

```dart
import 'package:json_annotation/json_annotation.dart';

part 'example.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class User {
  final String firstName;
  final String lastName;
  final int age;
  final Address address;
  final String email;
  final String? sessionToken;

  User({
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.address,
    required this.email,
    this.sessionToken,
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
  final String zipCode;

  Address({required this.street, required this.city, required this.zipCode});

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);

  // <-- enables Address.fields
  static const fields = $AddressFields();
}
```

## Use it

### Basic field paths

```dart
User.fields.firstName;      // 'first_name'
User.fields.lastName;       // 'last_name'
User.fields.age;            // 'age'
User.fields.email;          // 'email'
User.fields.sessionToken;   // 'session_token'
```

### Nested paths

```dart
User.fields.address;             // 'address'
User.fields.address.street;      // 'address.street'
User.fields.address.city;        // 'address.city'
User.fields.address.zipCode;     // 'address.zip_code'
```

The generated extension types `implement String`, so the values are usable
anywhere a `String` is expected.

### Firebase-style partial updates

```dart
await firestore.collection('users').doc(uid).update({
  User.fields.firstName: 'Jane',
  User.fields.address.city: 'NYC',
  User.fields.address.zipCode: '10001',
});
```

If you ever rename `firstName` to `givenName`, this call breaks at compile
time, exactly what hardcoded strings can never do for you.

### Firestore queries

```dart
firestore
    .collection('users')
    .where(User.fields.address.city, isEqualTo: 'NYC')
    .orderBy(User.fields.lastName);
```

### Custom path separators

The default `.` separator works for Firestore-style document paths. To
generate paths joined with `/` (e.g. for Firebase Realtime Database) or any
other separator, set the builder option in your project's `build.yaml`:

```yaml
targets:
  $default:
    builders:
      json_fields|json_fields:
        options:
          separator: '/'
```

After re-running `build_runner`, the generated paths use the new separator:

```dart
User.fields.address.street;   // 'address/street'    (was 'address.street')
User.fields.address.city;     // 'address/city'
```

Individual field names are still controlled by `FieldRename` and
`@JsonKey(name:)`; only the join character between nested segments
changes.

### Custom path prefixes

When your data lives under a non-class root (e.g. `users/$uid/...`), pass a
prefix to the accessor's public constructor:

```dart
const userFields = $UserFields(prefix: 'users/abc123');

userFields.firstName;            // 'users/abc123.first_name'
userFields.address.city;         // 'users/abc123.address.city'
```

The prefix flows through nested accessors automatically.

### Renaming a field is a compile error

```dart
// After renaming `firstName` to `givenName` on User:
User.fields.firstName;
//          ^^^^^^^^^
// Compile error: getter 'firstName' isn't defined for the type '$UserFields'.
```

Existing call sites that referenced the old name fail to compile until
they're updated, which is exactly what hardcoded string keys can't do for
you.

## Output, when printed

Printing each accessor and a sample Firebase-style update map produces:

```text
first_name
last_name
age
email
session_token
address
address.street
address.city
address.zip_code
{first_name: Jane, address.city: NYC, address.zip_code: 10001}
users/abc123.first_name
users/abc123.address.city
```
