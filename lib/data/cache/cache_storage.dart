abstract class CacheStorage {
  Future<ResponseType> fetch<ResponseType>(String key);
  Future<void> delete(String key);
  Future<void> save<T>({
    required String key,
    required T value,
  });
}
