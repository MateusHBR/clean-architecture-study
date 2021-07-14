import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:course_clean_arch/infra/cache/cache.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

typedef VoidExpectation = When<Future<void>>;
typedef StringExpectation = When<Future<String?>>;

void main() {
  late FlutterSecureStorageSpy flutterSecureStorage;
  late LocalStorageAdapter sut;
  late String key;
  late String value;

  setUp(() {
    flutterSecureStorage = FlutterSecureStorageSpy();
    sut = LocalStorageAdapter(secureStorage: flutterSecureStorage);

    key = faker.lorem.word();
    value = faker.guid.guid();
  });

  group('save secure', () {
    VoidExpectation mockSaveSecure() {
      return when(
        () => flutterSecureStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      );
    }

    void mockSaveSecureSuccess() {
      mockSaveSecure().thenAnswer(
        (_) async => {},
      );
    }

    void mockSaveSecureError() {
      mockSaveSecure().thenThrow(Exception());
    }

    test('should call save secure with correct values', () async {
      mockSaveSecureSuccess();

      await sut.saveSecure(key: key, value: value);

      verify(() => flutterSecureStorage.write(key: key, value: value));
    });

    test('should throw if save secure throws', () async {
      mockSaveSecureError();

      final future = sut.saveSecure(key: key, value: value);

      expect(future, throwsA(isA<Exception>()));
    });
  });

  group('fetch secure', () {
    StringExpectation mockFetchSecure() {
      return when(() => flutterSecureStorage.read(key: key));
    }

    void mockFetchSecureSuccess({String? response}) {
      mockFetchSecure().thenAnswer(
        (_) async => response,
      );
    }

    test('should call fetch secure with correct values', () async {
      mockFetchSecureSuccess();

      await sut.fetchSecure(key);

      verify(() => flutterSecureStorage.read(key: key));
    });
    test('should return correct value on success', () async {
      final expectedValue = faker.guid.guid();

      mockFetchSecureSuccess(response: expectedValue);

      final value = await sut.fetchSecure(key);

      expect(value, expectedValue);
    });
  });
}
