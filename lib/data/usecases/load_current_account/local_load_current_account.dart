import '../../../domain/entities/account_entity.dart';
import '../../../domain/usecases/usecases.dart';
import '../../cache/fetch_secure_cache_storage.dart';

class LocalLoadCurrentAccount implements LoadCurrentAccount {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCurrentAccount({
    required this.fetchSecureCacheStorage,
  });

  @override
  Future<AccountEntity> call() async {
    final token = await fetchSecureCacheStorage.fetchSecure("token");

    return AccountEntity(token: token);
  }
}
