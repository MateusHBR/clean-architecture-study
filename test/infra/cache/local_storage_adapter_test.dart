import 'package:localstorage/localstorage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:course_clean_arch/infra/cache/cache.dart';

class LocalStorageSpy extends Mock implements LocalStorage {}

void main() {
  late LocalStorageAdapter sut;
  late LocalStorageSpy localStorageSpy;

  When<Future<void>> mockSave() =>
      when(() => localStorageSpy.setItem(any(), any()));

  When<Future<void>> mockDelete() =>
      when(() => localStorageSpy.deleteItem(any()));

  mockSaveSuccess() => mockSave().thenAnswer((_) async => null);

  mockDeleteSuccess() => mockDelete().thenAnswer((_) async => null);

  mockDeleteError() => mockDelete().thenThrow(Exception());

  mockSaveError() => mockSave().thenThrow(Exception());

  setUp(() {
    localStorageSpy = LocalStorageSpy();
    sut = LocalStorageAdapter(
      localStorage: localStorageSpy,
    );

    mockSaveSuccess();
    mockDeleteSuccess();
  });

  group('save', () {
    test('should call local storage with correct values', () async {
      await sut.save(key: 'key', value: 'value');

      verify(() => localStorageSpy.deleteItem('key')).called(1);
      verify(() => localStorageSpy.setItem('key', 'value')).called(1);
    });

    test('should throw if delete item throws', () async {
      mockDeleteError();

      final future = sut.save(key: 'key', value: 'value');

      expect(future, throwsA(isA<Exception>()));
    });

    test('should throw if save item throws', () async {
      mockSaveError();

      final future = sut.save(key: 'key', value: 'value');

      expect(future, throwsA(isA<Exception>()));
    });
  });
}
