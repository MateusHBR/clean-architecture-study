import '../../../domain/entities/account_entity.dart';
import '../../../domain/usecases/usecases.dart';

class LocalSaveCurrentAccount implements SaveCurrentAccount {
  final SaveSecureCacheStorage saveSecureCacheStorage;

  LocalSaveCurrentAccount({
    required this.saveSecureCacheStorage,
  });

  @override
  Future<void> call(AccountEntity account) async {
    await saveSecureCacheStorage(key: 'token', value: account.token);
  }
}

abstract class SaveSecureCacheStorage {
  Future<void> call({String key, String value});
}
