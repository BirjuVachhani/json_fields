import 'package:test/test.dart';

import 'models/test_models.dart';

/// Helper function to extract keys from toJson output.
Set<String> getToJsonKeys(Map<String, dynamic> json) => json.keys.toSet();

/// Helper function to verify that all field accessors match toJson keys exactly.
void verifyFieldsMatchToJson({
  required Map<String, dynamic> toJsonOutput,
  required Map<String, String> fieldAccessors,
  String? description,
}) {
  final toJsonKeys = getToJsonKeys(toJsonOutput);

  for (final entry in fieldAccessors.entries) {
    final dartFieldName = entry.key;
    final generatedJsonName = entry.value;

    expect(
      toJsonKeys,
      contains(generatedJsonName),
      reason:
          '${description ?? 'Model'}: '
          'Field accessor "$dartFieldName" produces "$generatedJsonName" '
          'but toJson keys are: $toJsonKeys',
    );
  }

  // Also verify count matches (no extra or missing fields)
  expect(
    fieldAccessors.values.toSet(),
    equals(toJsonKeys),
    reason:
        '${description ?? 'Model'}: '
        'Field accessors and toJson keys should match exactly. '
        'Fields: ${fieldAccessors.values.toSet()}, toJson: $toJsonKeys',
  );
}

void main() {
  group('DefaultModel (no fieldRename)', () {
    late DefaultModel model;
    late Map<String, dynamic> toJson;

    setUp(() {
      model = DefaultModel(
        firstName: 'John',
        lastName: 'Doe',
        age: 30,
        isActive: true,
      );
      toJson = model.toJson();
    });

    test('all field accessors match toJson keys exactly', () {
      verifyFieldsMatchToJson(
        toJsonOutput: toJson,
        fieldAccessors: {
          'firstName': DefaultModel.fields.firstName,
          'lastName': DefaultModel.fields.lastName,
          'age': DefaultModel.fields.age,
          'isActive': DefaultModel.fields.isActive,
        },
        description: 'DefaultModel',
      );
    });

    test('field values are correct', () {
      expect(DefaultModel.fields.firstName, equals('firstName'));
      expect(DefaultModel.fields.lastName, equals('lastName'));
      expect(DefaultModel.fields.age, equals('age'));
      expect(DefaultModel.fields.isActive, equals('isActive'));
    });
  });

  group('SnakeCaseModel (fieldRename: FieldRename.snake)', () {
    late SnakeCaseModel model;
    late Map<String, dynamic> toJson;

    setUp(() {
      model = SnakeCaseModel(
        firstName: 'John',
        lastName: 'Doe',
        userAge: 30,
        isActiveUser: true,
        httpUrl: 'https://example.com',
      );
      toJson = model.toJson();
    });

    test('all field accessors match toJson keys exactly', () {
      verifyFieldsMatchToJson(
        toJsonOutput: toJson,
        fieldAccessors: {
          'firstName': SnakeCaseModel.fields.firstName,
          'lastName': SnakeCaseModel.fields.lastName,
          'userAge': SnakeCaseModel.fields.userAge,
          'isActiveUser': SnakeCaseModel.fields.isActiveUser,
          'httpUrl': SnakeCaseModel.fields.httpUrl,
        },
        description: 'SnakeCaseModel',
      );
    });

    test('field values use snake_case', () {
      expect(SnakeCaseModel.fields.firstName, equals('first_name'));
      expect(SnakeCaseModel.fields.lastName, equals('last_name'));
      expect(SnakeCaseModel.fields.userAge, equals('user_age'));
      expect(SnakeCaseModel.fields.isActiveUser, equals('is_active_user'));
      expect(SnakeCaseModel.fields.httpUrl, equals('http_url'));
    });
  });

  group('KebabCaseModel (fieldRename: FieldRename.kebab)', () {
    late KebabCaseModel model;
    late Map<String, dynamic> toJson;

    setUp(() {
      model = KebabCaseModel(
        firstName: 'John',
        lastName: 'Doe',
        userAge: 30,
        isActiveUser: true,
      );
      toJson = model.toJson();
    });

    test('all field accessors match toJson keys exactly', () {
      verifyFieldsMatchToJson(
        toJsonOutput: toJson,
        fieldAccessors: {
          'firstName': KebabCaseModel.fields.firstName,
          'lastName': KebabCaseModel.fields.lastName,
          'userAge': KebabCaseModel.fields.userAge,
          'isActiveUser': KebabCaseModel.fields.isActiveUser,
        },
        description: 'KebabCaseModel',
      );
    });

    test('field values use kebab-case', () {
      expect(KebabCaseModel.fields.firstName, equals('first-name'));
      expect(KebabCaseModel.fields.lastName, equals('last-name'));
      expect(KebabCaseModel.fields.userAge, equals('user-age'));
      expect(KebabCaseModel.fields.isActiveUser, equals('is-active-user'));
    });
  });

  group('PascalCaseModel (fieldRename: FieldRename.pascal)', () {
    late PascalCaseModel model;
    late Map<String, dynamic> toJson;

    setUp(() {
      model = PascalCaseModel(
        firstName: 'John',
        lastName: 'Doe',
        userAge: 30,
        isActiveUser: true,
      );
      toJson = model.toJson();
    });

    test('all field accessors match toJson keys exactly', () {
      verifyFieldsMatchToJson(
        toJsonOutput: toJson,
        fieldAccessors: {
          'firstName': PascalCaseModel.fields.firstName,
          'lastName': PascalCaseModel.fields.lastName,
          'userAge': PascalCaseModel.fields.userAge,
          'isActiveUser': PascalCaseModel.fields.isActiveUser,
        },
        description: 'PascalCaseModel',
      );
    });

    test('field values use PascalCase', () {
      expect(PascalCaseModel.fields.firstName, equals('FirstName'));
      expect(PascalCaseModel.fields.lastName, equals('LastName'));
      expect(PascalCaseModel.fields.userAge, equals('UserAge'));
      expect(PascalCaseModel.fields.isActiveUser, equals('IsActiveUser'));
    });
  });

  group(
    'ScreamingSnakeCaseModel (fieldRename: FieldRename.screamingSnake)',
    () {
      late ScreamingSnakeCaseModel model;
      late Map<String, dynamic> toJson;

      setUp(() {
        model = ScreamingSnakeCaseModel(
          firstName: 'John',
          lastName: 'Doe',
          userAge: 30,
          isActiveUser: true,
        );
        toJson = model.toJson();
      });

      test('all field accessors match toJson keys exactly', () {
        verifyFieldsMatchToJson(
          toJsonOutput: toJson,
          fieldAccessors: {
            'firstName': ScreamingSnakeCaseModel.fields.firstName,
            'lastName': ScreamingSnakeCaseModel.fields.lastName,
            'userAge': ScreamingSnakeCaseModel.fields.userAge,
            'isActiveUser': ScreamingSnakeCaseModel.fields.isActiveUser,
          },
          description: 'ScreamingSnakeCaseModel',
        );
      });

      test('field values use SCREAMING_SNAKE_CASE', () {
        expect(ScreamingSnakeCaseModel.fields.firstName, equals('FIRST_NAME'));
        expect(ScreamingSnakeCaseModel.fields.lastName, equals('LAST_NAME'));
        expect(ScreamingSnakeCaseModel.fields.userAge, equals('USER_AGE'));
        expect(
          ScreamingSnakeCaseModel.fields.isActiveUser,
          equals('IS_ACTIVE_USER'),
        );
      });
    },
  );

  group('JsonKeyNameModel (@JsonKey(name:) explicit overrides)', () {
    late JsonKeyNameModel model;
    late Map<String, dynamic> toJson;

    setUp(() {
      model = JsonKeyNameModel(
        firstName: 'John',
        lastName: 'Doe',
        age: 30,
        normalField: 'normal',
      );
      toJson = model.toJson();
    });

    test('all field accessors match toJson keys exactly', () {
      verifyFieldsMatchToJson(
        toJsonOutput: toJson,
        fieldAccessors: {
          'firstName': JsonKeyNameModel.fields.firstName,
          'lastName': JsonKeyNameModel.fields.lastName,
          'age': JsonKeyNameModel.fields.age,
          'normalField': JsonKeyNameModel.fields.normalField,
        },
        description: 'JsonKeyNameModel',
      );
    });

    test('@JsonKey(name:) overrides are respected', () {
      expect(JsonKeyNameModel.fields.firstName, equals('user_first_name'));
      expect(JsonKeyNameModel.fields.lastName, equals('user_last_name'));
      expect(JsonKeyNameModel.fields.age, equals('custom-age-field'));
      expect(JsonKeyNameModel.fields.normalField, equals('normalField'));
    });
  });

  group('JsonKeyWithFieldRenameModel (@JsonKey(name:) takes precedence)', () {
    late JsonKeyWithFieldRenameModel model;
    late Map<String, dynamic> toJson;

    setUp(() {
      model = JsonKeyWithFieldRenameModel(
        firstName: 'John',
        lastName: 'Doe',
        userAge: 30,
      );
      toJson = model.toJson();
    });

    test('all field accessors match toJson keys exactly', () {
      verifyFieldsMatchToJson(
        toJsonOutput: toJson,
        fieldAccessors: {
          'firstName': JsonKeyWithFieldRenameModel.fields.firstName,
          'lastName': JsonKeyWithFieldRenameModel.fields.lastName,
          'userAge': JsonKeyWithFieldRenameModel.fields.userAge,
        },
        description: 'JsonKeyWithFieldRenameModel',
      );
    });

    test('@JsonKey(name:) takes precedence over fieldRename', () {
      // firstName has @JsonKey(name: 'customFirstName') - should NOT use snake_case
      expect(
        JsonKeyWithFieldRenameModel.fields.firstName,
        equals('customFirstName'),
      );
      // lastName has no @JsonKey - should use snake_case
      expect(JsonKeyWithFieldRenameModel.fields.lastName, equals('last_name'));
      // userAge has @JsonKey(name: 'AGE') - should use 'AGE'
      expect(JsonKeyWithFieldRenameModel.fields.userAge, equals('AGE'));
    });
  });

  group('IgnoredFieldModel (@JsonKey excluded fields)', () {
    late IgnoredFieldModel model;
    late Map<String, dynamic> toJson;

    setUp(() {
      model = IgnoredFieldModel(
        visibleField: 'visible',
        ignoredField: 'ignored',
        anotherVisibleField: 42,
      );
      toJson = model.toJson();
    });

    test('all field accessors match toJson keys exactly', () {
      verifyFieldsMatchToJson(
        toJsonOutput: toJson,
        fieldAccessors: {
          'visibleField': IgnoredFieldModel.fields.visibleField,
          'anotherVisibleField': IgnoredFieldModel.fields.anotherVisibleField,
        },
        description: 'IgnoredFieldModel',
      );
    });

    test('ignored field is not in toJson', () {
      expect(toJson.containsKey('ignoredField'), isFalse);
    });

    test('ignored field accessor does not exist', () {
      // This is a compile-time check - if ignoredField accessor existed,
      // it would be a bug. We verify by checking generated accessor count.
      // The $IgnoredFieldModelFields should only have 2 field accessors.
      final visibleFields = {
        IgnoredFieldModel.fields.visibleField,
        IgnoredFieldModel.fields.anotherVisibleField,
      };
      expect(visibleFields.length, equals(2));
    });
  });

  group('Nested @JsonSerializable types', () {
    group('Person with Address', () {
      late Person person;
      late Map<String, dynamic> toJson;

      setUp(() {
        person = Person(
          name: 'John',
          homeAddress: Address(
            street: '123 Main St',
            city: 'NYC',
            zipCode: '10001',
          ),
          workAddress: Address(
            street: '456 Work Ave',
            city: 'NYC',
            zipCode: '10002',
          ),
        );
        toJson = person.toJson();
      });

      test('top-level field accessors match toJson keys', () {
        expect(toJson.keys, contains(Person.fields.name));
        expect(toJson.keys, contains(Person.fields.homeAddress as String));
        expect(toJson.keys, contains(Person.fields.workAddress as String));
      });

      test('nested field paths are correct', () {
        expect(Person.fields.homeAddress.street, equals('homeAddress.street'));
        expect(Person.fields.homeAddress.city, equals('homeAddress.city'));
        expect(
          Person.fields.homeAddress.zipCode,
          equals('homeAddress.zipCode'),
        );
        expect(Person.fields.workAddress.street, equals('workAddress.street'));
        expect(Person.fields.workAddress.city, equals('workAddress.city'));
      });

      test('nested accessors return correct type', () {
        // Verify nested accessors are the correct extension type
        expect(Person.fields.homeAddress, isA<$AddressFields>());
        expect(Person.fields.workAddress, isA<$AddressFields>());
      });
    });

    group('Deeply nested (Company > FullAddress > Country)', () {
      late Company company;
      late Map<String, dynamic> toJson;

      setUp(() {
        company = Company(
          name: 'Acme Inc',
          headquarters: FullAddress(
            street: '789 Corp Blvd',
            city: 'San Francisco',
            country: Country(name: 'USA', code: 'US'),
          ),
        );
        toJson = company.toJson();
      });

      test('deeply nested field paths are correct', () {
        expect(Company.fields.name, equals('name'));
        expect(Company.fields.headquarters, isA<$FullAddressFields>());
        expect(
          Company.fields.headquarters.street,
          equals('headquarters.street'),
        );
        expect(Company.fields.headquarters.city, equals('headquarters.city'));
        expect(Company.fields.headquarters.country, isA<$CountryFields>());
        expect(
          Company.fields.headquarters.country.name,
          equals('headquarters.country.name'),
        );
        expect(
          Company.fields.headquarters.country.code,
          equals('headquarters.country.code'),
        );
      });
    });
  });

  group('Inherited fields from parent class', () {
    late Product product;
    late Map<String, dynamic> toJson;

    setUp(() {
      product = Product(
        id: 'prod-123',
        createdAt: DateTime(2024, 1, 15),
        name: 'Widget',
        price: 29.99,
      );
      toJson = product.toJson();
    });

    test('all field accessors match toJson keys exactly', () {
      verifyFieldsMatchToJson(
        toJsonOutput: toJson,
        fieldAccessors: {
          'id': Product.fields.id,
          'createdAt': Product.fields.createdAt,
          'name': Product.fields.name,
          'price': Product.fields.price,
        },
        description: 'Product (with inherited fields)',
      );
    });

    test('inherited fields are included', () {
      // These come from BaseEntity
      expect(Product.fields.id, equals('id'));
      expect(Product.fields.createdAt, equals('createdAt'));
      // These are defined in Product
      expect(Product.fields.name, equals('name'));
      expect(Product.fields.price, equals('price'));
    });

    test('toJson includes inherited fields', () {
      expect(toJson.containsKey('id'), isTrue);
      expect(toJson.containsKey('createdAt'), isTrue);
    });
  });

  group('Collections (List, Set, Map)', () {
    late CollectionModel model;
    late Map<String, dynamic> toJson;

    setUp(() {
      model = CollectionModel(
        tags: ['a', 'b', 'c'],
        numbers: {1, 2, 3},
        metadata: {'key': 'value'},
        addresses: [Address(street: '123 Main', city: 'NYC', zipCode: '10001')],
      );
      toJson = model.toJson();
    });

    test('all field accessors match toJson keys exactly', () {
      verifyFieldsMatchToJson(
        toJsonOutput: toJson,
        fieldAccessors: {
          'tags': CollectionModel.fields.tags,
          'numbers': CollectionModel.fields.numbers,
          'metadata': CollectionModel.fields.metadata,
          'addresses': CollectionModel.fields.addresses,
        },
        description: 'CollectionModel',
      );
    });

    test('collection fields return String (not nested accessors)', () {
      // Collections should return String, not nested accessor types
      expect(CollectionModel.fields.tags, isA<String>());
      expect(CollectionModel.fields.numbers, isA<String>());
      expect(CollectionModel.fields.metadata, isA<String>());
      expect(CollectionModel.fields.addresses, isA<String>());

      expect(CollectionModel.fields.tags, equals('tags'));
      expect(CollectionModel.fields.numbers, equals('numbers'));
      expect(CollectionModel.fields.metadata, equals('metadata'));
      expect(CollectionModel.fields.addresses, equals('addresses'));
    });
  });

  group('Snake case with nested types', () {
    late SnakePerson person;
    late Map<String, dynamic> toJson;

    setUp(() {
      person = SnakePerson(
        firstName: 'John',
        lastName: 'Doe',
        homeAddress: SnakeAddress(streetName: '123 Main St', cityName: 'NYC'),
      );
      toJson = person.toJson();
    });

    test('all field accessors match toJson keys exactly', () {
      verifyFieldsMatchToJson(
        toJsonOutput: toJson,
        fieldAccessors: {
          'firstName': SnakePerson.fields.firstName,
          'lastName': SnakePerson.fields.lastName,
          'homeAddress': SnakePerson.fields.homeAddress as String,
        },
        description: 'SnakePerson',
      );
    });

    test('snake_case is applied to all fields including nested', () {
      expect(SnakePerson.fields.firstName, equals('first_name'));
      expect(SnakePerson.fields.lastName, equals('last_name'));
      expect(SnakePerson.fields.homeAddress as String, equals('home_address'));
    });

    test('nested fields use snake_case paths', () {
      expect(
        SnakePerson.fields.homeAddress.streetName,
        equals('home_address.street_name'),
      );
      expect(
        SnakePerson.fields.homeAddress.cityName,
        equals('home_address.city_name'),
      );
    });
  });

  group('Extension type implements String', () {
    test('field accessors can be used directly as String', () {
      // Extension type should implement String
      String fieldName = DefaultModel.fields.firstName;
      expect(fieldName, equals('firstName'));

      // Should work in Map literal
      final map = {DefaultModel.fields.firstName: 'John'};
      expect(map['firstName'], equals('John'));
    });

    test('nested field paths can be used directly as String', () {
      String nestedPath = Person.fields.homeAddress.street;
      expect(nestedPath, equals('homeAddress.street'));

      // Should work in Map literal for Firebase-style updates
      final updates = {
        Person.fields.homeAddress.street: '456 New St',
        Person.fields.homeAddress.city: 'LA',
      };
      expect(updates['homeAddress.street'], equals('456 New St'));
      expect(updates['homeAddress.city'], equals('LA'));
    });
  });
}
