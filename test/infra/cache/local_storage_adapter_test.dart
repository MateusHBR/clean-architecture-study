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

  setUp(() {
    localStorageSpy = LocalStorageSpy();
    sut = LocalStorageAdapter(
      localStorage: localStorageSpy,
    );

    mockSaveSuccess();
    mockDeleteSuccess();
  });

  test('should call local storage with correct values', () async {
    await sut.save(key: 'key', value: 'value');

    verify(() => localStorageSpy.deleteItem('key')).called(1);
    verify(() => localStorageSpy.setItem('key', 'value')).called(1);
  });
}
