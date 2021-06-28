import '../../../domain/entities/account_entity.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';

class LocalSaveCurrentAccount implements SaveCurrentAccount {
  final SaveSecureCacheStorage saveSecureCacheStorage;

  LocalSaveCurrentAccount({
    required this.saveSecureCacheStorage,
  });

  @override
  Future<void> call(AccountEntity account) async {
    try {
      await saveSecureCacheStorage(key: 'token', value: account.token);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}

abstract class SaveSecureCacheStorage {
  Future<void> call({String key, String value});
}
