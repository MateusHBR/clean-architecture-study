import 'package:localstorage/localstorage.dart';

import '../../data/cache/cache.dart';

class LocalStorageAdapter implements CacheStorage {
  final LocalStorage localStorage;

  LocalStorageAdapter({
    required this.localStorage,
  });

  @override
  Future<void> delete(String key) async {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<ResponseType> fetch<ResponseType>(String key) async {
    // TODO: implement fetch
    throw UnimplementedError();
  }

  @override
  Future<void> save<T>({required String key, required T value}) async {
    await localStorage.setItem(key, value);
  }
}
