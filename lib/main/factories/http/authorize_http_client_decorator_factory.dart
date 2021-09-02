import '../../../data/http/http.dart';

import '../../decorators/decorators.dart';
import '../../factories/factories.dart';

HttpClient makeAuthorizeHttpDecorator() {
  return AuthorizeHttpClientDecorator(
    fetchSecureCacheStorage: makeLocalStorageAdapter(),
    decoratee: makeHttpAdapter(),
  );
}
