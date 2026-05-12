// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_models.dart';

// **************************************************************************
// JsonFieldsGenerator
// **************************************************************************

// coverage:ignore-start

/// Field path accessors for [DefaultModel].
///
/// Usage:
/// ```dart
/// // Add to your class:
/// static const fields = $DefaultModelFields();
/// ```
extension type const $DefaultModelFields._(String _prefix) implements String {
  const $DefaultModelFields({String prefix = ''}) : this._(prefix);

  String _join(String field) => _prefix.isEmpty ? field : '$_prefix.$field';

  String get firstName => _join('firstName');

  String get lastName => _join('lastName');

  String get age => _join('age');

  String get isActive => _join('isActive');
}

// coverage:ignore-end

// coverage:ignore-start

/// Field path accessors for [SnakeCaseModel].
///
/// Usage:
/// ```dart
/// // Add to your class:
/// static const fields = $SnakeCaseModelFields();
/// ```
extension type const $SnakeCaseModelFields._(String _prefix) implements String {
  const $SnakeCaseModelFields({String prefix = ''}) : this._(prefix);

  String _join(String field) => _prefix.isEmpty ? field : '$_prefix.$field';

  String get firstName => _join('first_name');

  String get lastName => _join('last_name');

  String get userAge => _join('user_age');

  String get isActiveUser => _join('is_active_user');

  String get httpUrl => _join('http_url');
}

// coverage:ignore-end

// coverage:ignore-start

/// Field path accessors for [KebabCaseModel].
///
/// Usage:
/// ```dart
/// // Add to your class:
/// static const fields = $KebabCaseModelFields();
/// ```
extension type const $KebabCaseModelFields._(String _prefix) implements String {
  const $KebabCaseModelFields({String prefix = ''}) : this._(prefix);

  String _join(String field) => _prefix.isEmpty ? field : '$_prefix.$field';

  String get firstName => _join('first-name');

  String get lastName => _join('last-name');

  String get userAge => _join('user-age');

  String get isActiveUser => _join('is-active-user');
}

// coverage:ignore-end

// coverage:ignore-start

/// Field path accessors for [PascalCaseModel].
///
/// Usage:
/// ```dart
/// // Add to your class:
/// static const fields = $PascalCaseModelFields();
/// ```
extension type const $PascalCaseModelFields._(String _prefix)
    implements String {
  const $PascalCaseModelFields({String prefix = ''}) : this._(prefix);

  String _join(String field) => _prefix.isEmpty ? field : '$_prefix.$field';

  String get firstName => _join('FirstName');

  String get lastName => _join('LastName');

  String get userAge => _join('UserAge');

  String get isActiveUser => _join('IsActiveUser');
}

// coverage:ignore-end

// coverage:ignore-start

/// Field path accessors for [ScreamingSnakeCaseModel].
///
/// Usage:
/// ```dart
/// // Add to your class:
/// static const fields = $ScreamingSnakeCaseModelFields();
/// ```
extension type const $ScreamingSnakeCaseModelFields._(String _prefix)
    implements String {
  const $ScreamingSnakeCaseModelFields({String prefix = ''}) : this._(prefix);

  String _join(String field) => _prefix.isEmpty ? field : '$_prefix.$field';

  String get firstName => _join('FIRST_NAME');

  String get lastName => _join('LAST_NAME');

  String get userAge => _join('USER_AGE');

  String get isActiveUser => _join('IS_ACTIVE_USER');
}

// coverage:ignore-end

// coverage:ignore-start

/// Field path accessors for [JsonKeyNameModel].
///
/// Usage:
/// ```dart
/// // Add to your class:
/// static const fields = $JsonKeyNameModelFields();
/// ```
extension type const $JsonKeyNameModelFields._(String _prefix)
    implements String {
  const $JsonKeyNameModelFields({String prefix = ''}) : this._(prefix);

  String _join(String field) => _prefix.isEmpty ? field : '$_prefix.$field';

  String get firstName => _join('user_first_name');

  String get lastName => _join('user_last_name');

  String get age => _join('custom-age-field');

  String get normalField => _join('normalField');
}

// coverage:ignore-end

// coverage:ignore-start

/// Field path accessors for [JsonKeyWithFieldRenameModel].
///
/// Usage:
/// ```dart
/// // Add to your class:
/// static const fields = $JsonKeyWithFieldRenameModelFields();
/// ```
extension type const $JsonKeyWithFieldRenameModelFields._(String _prefix)
    implements String {
  const $JsonKeyWithFieldRenameModelFields({String prefix = ''})
    : this._(prefix);

  String _join(String field) => _prefix.isEmpty ? field : '$_prefix.$field';

  String get firstName => _join('customFirstName');

  String get lastName => _join('last_name');

  String get userAge => _join('AGE');
}

// coverage:ignore-end

// coverage:ignore-start

/// Field path accessors for [IgnoredFieldModel].
///
/// Usage:
/// ```dart
/// // Add to your class:
/// static const fields = $IgnoredFieldModelFields();
/// ```
extension type const $IgnoredFieldModelFields._(String _prefix)
    implements String {
  const $IgnoredFieldModelFields({String prefix = ''}) : this._(prefix);

  String _join(String field) => _prefix.isEmpty ? field : '$_prefix.$field';

  String get visibleField => _join('visibleField');

  String get anotherVisibleField => _join('anotherVisibleField');
}

// coverage:ignore-end

// coverage:ignore-start

/// Field path accessors for [Address].
///
/// Usage:
/// ```dart
/// // Add to your class:
/// static const fields = $AddressFields();
/// ```
extension type const $AddressFields._(String _prefix) implements String {
  const $AddressFields({String prefix = ''}) : this._(prefix);

  String _join(String field) => _prefix.isEmpty ? field : '$_prefix.$field';

  String get street => _join('street');

  String get city => _join('city');

  String get zipCode => _join('zipCode');
}

// coverage:ignore-end

// coverage:ignore-start

/// Field path accessors for [Person].
///
/// Usage:
/// ```dart
/// // Add to your class:
/// static const fields = $PersonFields();
/// ```
extension type const $PersonFields._(String _prefix) implements String {
  const $PersonFields({String prefix = ''}) : this._(prefix);

  String _join(String field) => _prefix.isEmpty ? field : '$_prefix.$field';

  String get name => _join('name');

  $AddressFields get homeAddress =>
      $AddressFields(prefix: _join('homeAddress'));

  $AddressFields get workAddress =>
      $AddressFields(prefix: _join('workAddress'));
}

// coverage:ignore-end

// coverage:ignore-start

/// Field path accessors for [Country].
///
/// Usage:
/// ```dart
/// // Add to your class:
/// static const fields = $CountryFields();
/// ```
extension type const $CountryFields._(String _prefix) implements String {
  const $CountryFields({String prefix = ''}) : this._(prefix);

  String _join(String field) => _prefix.isEmpty ? field : '$_prefix.$field';

  String get name => _join('name');

  String get code => _join('code');
}

// coverage:ignore-end

// coverage:ignore-start

/// Field path accessors for [FullAddress].
///
/// Usage:
/// ```dart
/// // Add to your class:
/// static const fields = $FullAddressFields();
/// ```
extension type const $FullAddressFields._(String _prefix) implements String {
  const $FullAddressFields({String prefix = ''}) : this._(prefix);

  String _join(String field) => _prefix.isEmpty ? field : '$_prefix.$field';

  String get street => _join('street');

  String get city => _join('city');

  $CountryFields get country => $CountryFields(prefix: _join('country'));
}

// coverage:ignore-end

// coverage:ignore-start

/// Field path accessors for [Company].
///
/// Usage:
/// ```dart
/// // Add to your class:
/// static const fields = $CompanyFields();
/// ```
extension type const $CompanyFields._(String _prefix) implements String {
  const $CompanyFields({String prefix = ''}) : this._(prefix);

  String _join(String field) => _prefix.isEmpty ? field : '$_prefix.$field';

  String get name => _join('name');

  $FullAddressFields get headquarters =>
      $FullAddressFields(prefix: _join('headquarters'));
}

// coverage:ignore-end

// coverage:ignore-start

/// Field path accessors for [Product].
///
/// Usage:
/// ```dart
/// // Add to your class:
/// static const fields = $ProductFields();
/// ```
extension type const $ProductFields._(String _prefix) implements String {
  const $ProductFields({String prefix = ''}) : this._(prefix);

  String _join(String field) => _prefix.isEmpty ? field : '$_prefix.$field';

  String get name => _join('name');

  String get price => _join('price');

  String get id => _join('id');

  String get createdAt => _join('createdAt');
}

// coverage:ignore-end

// coverage:ignore-start

/// Field path accessors for [CollectionModel].
///
/// Usage:
/// ```dart
/// // Add to your class:
/// static const fields = $CollectionModelFields();
/// ```
extension type const $CollectionModelFields._(String _prefix)
    implements String {
  const $CollectionModelFields({String prefix = ''}) : this._(prefix);

  String _join(String field) => _prefix.isEmpty ? field : '$_prefix.$field';

  String get tags => _join('tags');

  String get numbers => _join('numbers');

  String get metadata => _join('metadata');

  String get addresses => _join('addresses');
}

// coverage:ignore-end

// coverage:ignore-start

/// Field path accessors for [SnakeAddress].
///
/// Usage:
/// ```dart
/// // Add to your class:
/// static const fields = $SnakeAddressFields();
/// ```
extension type const $SnakeAddressFields._(String _prefix) implements String {
  const $SnakeAddressFields({String prefix = ''}) : this._(prefix);

  String _join(String field) => _prefix.isEmpty ? field : '$_prefix.$field';

  String get streetName => _join('street_name');

  String get cityName => _join('city_name');
}

// coverage:ignore-end

// coverage:ignore-start

/// Field path accessors for [SnakePerson].
///
/// Usage:
/// ```dart
/// // Add to your class:
/// static const fields = $SnakePersonFields();
/// ```
extension type const $SnakePersonFields._(String _prefix) implements String {
  const $SnakePersonFields({String prefix = ''}) : this._(prefix);

  String _join(String field) => _prefix.isEmpty ? field : '$_prefix.$field';

  String get firstName => _join('first_name');

  String get lastName => _join('last_name');

  $SnakeAddressFields get homeAddress =>
      $SnakeAddressFields(prefix: _join('home_address'));
}

// coverage:ignore-end

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DefaultModel _$DefaultModelFromJson(Map<String, dynamic> json) => DefaultModel(
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  age: (json['age'] as num).toInt(),
  isActive: json['isActive'] as bool,
);

Map<String, dynamic> _$DefaultModelToJson(DefaultModel instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'age': instance.age,
      'isActive': instance.isActive,
    };

SnakeCaseModel _$SnakeCaseModelFromJson(Map<String, dynamic> json) =>
    SnakeCaseModel(
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      userAge: (json['user_age'] as num).toInt(),
      isActiveUser: json['is_active_user'] as bool,
      httpUrl: json['http_url'] as String,
    );

Map<String, dynamic> _$SnakeCaseModelToJson(SnakeCaseModel instance) =>
    <String, dynamic>{
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'user_age': instance.userAge,
      'is_active_user': instance.isActiveUser,
      'http_url': instance.httpUrl,
    };

KebabCaseModel _$KebabCaseModelFromJson(Map<String, dynamic> json) =>
    KebabCaseModel(
      firstName: json['first-name'] as String,
      lastName: json['last-name'] as String,
      userAge: (json['user-age'] as num).toInt(),
      isActiveUser: json['is-active-user'] as bool,
    );

Map<String, dynamic> _$KebabCaseModelToJson(KebabCaseModel instance) =>
    <String, dynamic>{
      'first-name': instance.firstName,
      'last-name': instance.lastName,
      'user-age': instance.userAge,
      'is-active-user': instance.isActiveUser,
    };

PascalCaseModel _$PascalCaseModelFromJson(Map<String, dynamic> json) =>
    PascalCaseModel(
      firstName: json['FirstName'] as String,
      lastName: json['LastName'] as String,
      userAge: (json['UserAge'] as num).toInt(),
      isActiveUser: json['IsActiveUser'] as bool,
    );

Map<String, dynamic> _$PascalCaseModelToJson(PascalCaseModel instance) =>
    <String, dynamic>{
      'FirstName': instance.firstName,
      'LastName': instance.lastName,
      'UserAge': instance.userAge,
      'IsActiveUser': instance.isActiveUser,
    };

ScreamingSnakeCaseModel _$ScreamingSnakeCaseModelFromJson(
  Map<String, dynamic> json,
) => ScreamingSnakeCaseModel(
  firstName: json['FIRST_NAME'] as String,
  lastName: json['LAST_NAME'] as String,
  userAge: (json['USER_AGE'] as num).toInt(),
  isActiveUser: json['IS_ACTIVE_USER'] as bool,
);

Map<String, dynamic> _$ScreamingSnakeCaseModelToJson(
  ScreamingSnakeCaseModel instance,
) => <String, dynamic>{
  'FIRST_NAME': instance.firstName,
  'LAST_NAME': instance.lastName,
  'USER_AGE': instance.userAge,
  'IS_ACTIVE_USER': instance.isActiveUser,
};

JsonKeyNameModel _$JsonKeyNameModelFromJson(Map<String, dynamic> json) =>
    JsonKeyNameModel(
      firstName: json['user_first_name'] as String,
      lastName: json['user_last_name'] as String,
      age: (json['custom-age-field'] as num).toInt(),
      normalField: json['normalField'] as String,
    );

Map<String, dynamic> _$JsonKeyNameModelToJson(JsonKeyNameModel instance) =>
    <String, dynamic>{
      'user_first_name': instance.firstName,
      'user_last_name': instance.lastName,
      'custom-age-field': instance.age,
      'normalField': instance.normalField,
    };

JsonKeyWithFieldRenameModel _$JsonKeyWithFieldRenameModelFromJson(
  Map<String, dynamic> json,
) => JsonKeyWithFieldRenameModel(
  firstName: json['customFirstName'] as String,
  lastName: json['last_name'] as String,
  userAge: (json['AGE'] as num).toInt(),
);

Map<String, dynamic> _$JsonKeyWithFieldRenameModelToJson(
  JsonKeyWithFieldRenameModel instance,
) => <String, dynamic>{
  'customFirstName': instance.firstName,
  'last_name': instance.lastName,
  'AGE': instance.userAge,
};

IgnoredFieldModel _$IgnoredFieldModelFromJson(Map<String, dynamic> json) =>
    IgnoredFieldModel(
      visibleField: json['visibleField'] as String,
      anotherVisibleField: (json['anotherVisibleField'] as num).toInt(),
    );

Map<String, dynamic> _$IgnoredFieldModelToJson(IgnoredFieldModel instance) =>
    <String, dynamic>{
      'visibleField': instance.visibleField,
      'anotherVisibleField': instance.anotherVisibleField,
    };

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
  street: json['street'] as String,
  city: json['city'] as String,
  zipCode: json['zipCode'] as String,
);

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
  'street': instance.street,
  'city': instance.city,
  'zipCode': instance.zipCode,
};

Person _$PersonFromJson(Map<String, dynamic> json) => Person(
  name: json['name'] as String,
  homeAddress: Address.fromJson(json['homeAddress'] as Map<String, dynamic>),
  workAddress: json['workAddress'] == null
      ? null
      : Address.fromJson(json['workAddress'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PersonToJson(Person instance) => <String, dynamic>{
  'name': instance.name,
  'homeAddress': instance.homeAddress,
  'workAddress': instance.workAddress,
};

Country _$CountryFromJson(Map<String, dynamic> json) =>
    Country(name: json['name'] as String, code: json['code'] as String);

Map<String, dynamic> _$CountryToJson(Country instance) => <String, dynamic>{
  'name': instance.name,
  'code': instance.code,
};

FullAddress _$FullAddressFromJson(Map<String, dynamic> json) => FullAddress(
  street: json['street'] as String,
  city: json['city'] as String,
  country: Country.fromJson(json['country'] as Map<String, dynamic>),
);

Map<String, dynamic> _$FullAddressToJson(FullAddress instance) =>
    <String, dynamic>{
      'street': instance.street,
      'city': instance.city,
      'country': instance.country,
    };

Company _$CompanyFromJson(Map<String, dynamic> json) => Company(
  name: json['name'] as String,
  headquarters: FullAddress.fromJson(
    json['headquarters'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$CompanyToJson(Company instance) => <String, dynamic>{
  'name': instance.name,
  'headquarters': instance.headquarters,
};

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
  id: json['id'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  name: json['name'] as String,
  price: (json['price'] as num).toDouble(),
);

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
  'id': instance.id,
  'createdAt': instance.createdAt.toIso8601String(),
  'name': instance.name,
  'price': instance.price,
};

CollectionModel _$CollectionModelFromJson(Map<String, dynamic> json) =>
    CollectionModel(
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      numbers: (json['numbers'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toSet(),
      metadata: json['metadata'] as Map<String, dynamic>,
      addresses: (json['addresses'] as List<dynamic>)
          .map((e) => Address.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CollectionModelToJson(CollectionModel instance) =>
    <String, dynamic>{
      'tags': instance.tags,
      'numbers': instance.numbers.toList(),
      'metadata': instance.metadata,
      'addresses': instance.addresses,
    };

SnakeAddress _$SnakeAddressFromJson(Map<String, dynamic> json) => SnakeAddress(
  streetName: json['street_name'] as String,
  cityName: json['city_name'] as String,
);

Map<String, dynamic> _$SnakeAddressToJson(SnakeAddress instance) =>
    <String, dynamic>{
      'street_name': instance.streetName,
      'city_name': instance.cityName,
    };

SnakePerson _$SnakePersonFromJson(Map<String, dynamic> json) => SnakePerson(
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String,
  homeAddress: SnakeAddress.fromJson(
    json['home_address'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$SnakePersonToJson(SnakePerson instance) =>
    <String, dynamic>{
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'home_address': instance.homeAddress,
    };
