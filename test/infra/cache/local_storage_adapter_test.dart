import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:course_clean_arch/infra/cache/cache.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

typedef VoidExpectation = When<void>;

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

  VoidExpectation mockSaveSecure() {
    return when(
      () => flutterSecureStorage.write(key: key, value: value),
    );
  }

  void mockSaveSecureSuccess() {
    mockSaveSecure().thenAnswer(
      (_) async => {},
    );
  }

  test('should call save secure with correct values', () async {
    mockSaveSecureSuccess();

    await sut.saveSecure(key: key, value: value);

    verify(() => flutterSecureStorage.write(key: key, value: value));
  });
}
