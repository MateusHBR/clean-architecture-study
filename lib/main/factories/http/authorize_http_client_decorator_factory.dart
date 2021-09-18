import '../../../data/http/http.dart';

import '../../decorators/decorators.dart';
import '../../factories/factories.dart';

HttpClient makeAuthorizeHttpDecorator() {
  final secureCacheAdapter = makeSecureLocalStorageAdapter();

  return AuthorizeHttpClientDecorator(
    fetchSecureCacheStorage: secureCacheAdapter,
    deleteSecureCacheStorage: secureCacheAdapter,
    decoratee: makeHttpAdapter(),
  );
}
