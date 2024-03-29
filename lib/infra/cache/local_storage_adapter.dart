import 'package:localstorage/localstorage.dart';

import '../../data/cache/cache.dart';

class LocalStorageAdapter implements CacheStorage {
  final LocalStorage localStorage;

  LocalStorageAdapter({
    required this.localStorage,
  });

  @override
  Future<void> delete(String key) async {
    await localStorage.deleteItem(key);
  }

  @override
  Future<ResponseType> fetch<ResponseType>(String key) async {
    return await localStorage.getItem(key);
  }

  @override
  Future<void> save<T>({required String key, required T value}) async {
    await localStorage.deleteItem(key);
    await localStorage.setItem(key, value);
  }
}
