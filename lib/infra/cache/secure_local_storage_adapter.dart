import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../data/cache/cache.dart';

class SecureLocalStorageAdapter
    implements
        SaveSecureCacheStorage,
        FetchSecureCacheStorage,
        DeleteSecureCacheStorage {
  final FlutterSecureStorage secureStorage;

  SecureLocalStorageAdapter({
    required this.secureStorage,
  });

  @override
  Future<void> saveSecure({required String key, required String value}) async {
    try {
      await secureStorage.write(key: key, value: value);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<String> fetchSecure(String key) async {
    try {
      final data = await secureStorage.read(key: key);

      return data ?? "";
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> delete(String key) async {
    try {
      await secureStorage.delete(key: key);
    } catch (_) {
      rethrow;
    }
  }
}
