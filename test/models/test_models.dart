import 'package:json_annotation/json_annotation.dart';

part 'test_models.g.dart';

// =============================================================================
// Test 1: Default configuration (no fieldRename)
// =============================================================================

@JsonSerializable()
class DefaultModel {
  final String firstName;
  final String lastName;
  final int age;
  final bool isActive;

  DefaultModel({
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.isActive,
  });

  factory DefaultModel.fromJson(Map<String, dynamic> json) =>
      _$DefaultModelFromJson(json);

  Map<String, dynamic> toJson() => _$DefaultModelToJson(this);

  static const fields = $DefaultModelFields();
}

// =============================================================================
// Test 2: Snake case field rename
// =============================================================================

@JsonSerializable(fieldRename: FieldRename.snake)
class SnakeCaseModel {
  final String firstName;
  final String lastName;
  final int userAge;
  final bool isActiveUser;
  final String httpUrl;

  SnakeCaseModel({
    required this.firstName,
    required this.lastName,
    required this.userAge,
    required this.isActiveUser,
    required this.httpUrl,
  });

  factory SnakeCaseModel.fromJson(Map<String, dynamic> json) =>
      _$SnakeCaseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SnakeCaseModelToJson(this);

  static const fields = $SnakeCaseModelFields();
}

// =============================================================================
// Test 3: Kebab case field rename
// =============================================================================

@JsonSerializable(fieldRename: FieldRename.kebab)
class KebabCaseModel {
  final String firstName;
  final String lastName;
  final int userAge;
  final bool isActiveUser;

  KebabCaseModel({
    required this.firstName,
    required this.lastName,
    required this.userAge,
    required this.isActiveUser,
  });

  factory KebabCaseModel.fromJson(Map<String, dynamic> json) =>
      _$KebabCaseModelFromJson(json);

  Map<String, dynamic> toJson() => _$KebabCaseModelToJson(this);

  static const fields = $KebabCaseModelFields();
}

// =============================================================================
// Test 4: Pascal case field rename
// =============================================================================

@JsonSerializable(fieldRename: FieldRename.pascal)
class PascalCaseModel {
  final String firstName;
  final String lastName;
  final int userAge;
  final bool isActiveUser;

  PascalCaseModel({
    required this.firstName,
    required this.lastName,
    required this.userAge,
    required this.isActiveUser,
  });

  factory PascalCaseModel.fromJson(Map<String, dynamic> json) =>
      _$PascalCaseModelFromJson(json);

  Map<String, dynamic> toJson() => _$PascalCaseModelToJson(this);

  static const fields = $PascalCaseModelFields();
}

// =============================================================================
// Test 5: Screaming snake case field rename
// =============================================================================

@JsonSerializable(fieldRename: FieldRename.screamingSnake)
class ScreamingSnakeCaseModel {
  final String firstName;
  final String lastName;
  final int userAge;
  final bool isActiveUser;

  ScreamingSnakeCaseModel({
    required this.firstName,
    required this.lastName,
    required this.userAge,
    required this.isActiveUser,
  });

  factory ScreamingSnakeCaseModel.fromJson(Map<String, dynamic> json) =>
      _$ScreamingSnakeCaseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScreamingSnakeCaseModelToJson(this);

  static const fields = $ScreamingSnakeCaseModelFields();
}

// =============================================================================
// Test 6: Explicit @JsonKey(name:) overrides
// =============================================================================

@JsonSerializable()
class JsonKeyNameModel {
  @JsonKey(name: 'user_first_name')
  final String firstName;

  @JsonKey(name: 'user_last_name')
  final String lastName;

  @JsonKey(name: 'custom-age-field')
  final int age;

  // No @JsonKey - should use default name
  final String normalField;

  JsonKeyNameModel({
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.normalField,
  });

  factory JsonKeyNameModel.fromJson(Map<String, dynamic> json) =>
      _$JsonKeyNameModelFromJson(json);

  Map<String, dynamic> toJson() => _$JsonKeyNameModelToJson(this);

  static const fields = $JsonKeyNameModelFields();
}

// =============================================================================
// Test 7: @JsonKey(name:) with fieldRename (name should take precedence)
// =============================================================================

@JsonSerializable(fieldRename: FieldRename.snake)
class JsonKeyWithFieldRenameModel {
  @JsonKey(name: 'customFirstName')
  final String firstName;

  // No @JsonKey - should use snake_case
  final String lastName;

  @JsonKey(name: 'AGE')
  final int userAge;

  JsonKeyWithFieldRenameModel({
    required this.firstName,
    required this.lastName,
    required this.userAge,
  });

  factory JsonKeyWithFieldRenameModel.fromJson(Map<String, dynamic> json) =>
      _$JsonKeyWithFieldRenameModelFromJson(json);

  Map<String, dynamic> toJson() => _$JsonKeyWithFieldRenameModelToJson(this);

  static const fields = $JsonKeyWithFieldRenameModelFields();
}

// =============================================================================
// Test 8: @JsonKey(ignore: true) - field should be excluded
// =============================================================================

@JsonSerializable()
class IgnoredFieldModel {
  final String visibleField;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final String ignoredField;

  final int anotherVisibleField;

  IgnoredFieldModel({
    required this.visibleField,
    this.ignoredField = '', // Default value for ignored field
    required this.anotherVisibleField,
  });

  factory IgnoredFieldModel.fromJson(Map<String, dynamic> json) =>
      _$IgnoredFieldModelFromJson(json);

  Map<String, dynamic> toJson() => _$IgnoredFieldModelToJson(this);

  static const fields = $IgnoredFieldModelFields();
}

// =============================================================================
// Test 9: Nested @JsonSerializable types
// =============================================================================

@JsonSerializable()
class Address {
  final String street;
  final String city;
  final String zipCode;

  Address({required this.street, required this.city, required this.zipCode});

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);

  static const fields = $AddressFields();
}

@JsonSerializable()
class Person {
  final String name;
  final Address homeAddress;
  final Address? workAddress;

  Person({required this.name, required this.homeAddress, this.workAddress});

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  Map<String, dynamic> toJson() => _$PersonToJson(this);

  static const fields = $PersonFields();
}

// =============================================================================
// Test 10: Deeply nested types
// =============================================================================

@JsonSerializable()
class Country {
  final String name;
  final String code;

  Country({required this.name, required this.code});

  factory Country.fromJson(Map<String, dynamic> json) =>
      _$CountryFromJson(json);

  Map<String, dynamic> toJson() => _$CountryToJson(this);

  static const fields = $CountryFields();
}

@JsonSerializable()
class FullAddress {
  final String street;
  final String city;
  final Country country;

  FullAddress({
    required this.street,
    required this.city,
    required this.country,
  });

  factory FullAddress.fromJson(Map<String, dynamic> json) =>
      _$FullAddressFromJson(json);

  Map<String, dynamic> toJson() => _$FullAddressToJson(this);

  static const fields = $FullAddressFields();
}

@JsonSerializable()
class Company {
  final String name;
  final FullAddress headquarters;

  Company({required this.name, required this.headquarters});

  factory Company.fromJson(Map<String, dynamic> json) =>
      _$CompanyFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyToJson(this);

  static const fields = $CompanyFields();
}

// =============================================================================
// Test 11: Inherited fields from parent class
// =============================================================================

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

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  static const fields = $ProductFields();
}

// =============================================================================
// Test 12: Collections (should return String, not nested accessor)
// =============================================================================

@JsonSerializable()
class CollectionModel {
  final List<String> tags;
  final Set<int> numbers;
  final Map<String, dynamic> metadata;
  final List<Address> addresses;

  CollectionModel({
    required this.tags,
    required this.numbers,
    required this.metadata,
    required this.addresses,
  });

  factory CollectionModel.fromJson(Map<String, dynamic> json) =>
      _$CollectionModelFromJson(json);

  Map<String, dynamic> toJson() => _$CollectionModelToJson(this);

  static const fields = $CollectionModelFields();
}

// =============================================================================
// Test 13: Mixed - fieldRename with nested types
// =============================================================================

@JsonSerializable(fieldRename: FieldRename.snake)
class SnakeAddress {
  final String streetName;
  final String cityName;

  SnakeAddress({required this.streetName, required this.cityName});

  factory SnakeAddress.fromJson(Map<String, dynamic> json) =>
      _$SnakeAddressFromJson(json);

  Map<String, dynamic> toJson() => _$SnakeAddressToJson(this);

  static const fields = $SnakeAddressFields();
}

@JsonSerializable(fieldRename: FieldRename.snake)
class SnakePerson {
  final String firstName;
  final String lastName;
  final SnakeAddress homeAddress;

  SnakePerson({
    required this.firstName,
    required this.lastName,
    required this.homeAddress,
  });

  factory SnakePerson.fromJson(Map<String, dynamic> json) =>
      _$SnakePersonFromJson(json);

  Map<String, dynamic> toJson() => _$SnakePersonToJson(this);

  static const fields = $SnakePersonFields();
}
