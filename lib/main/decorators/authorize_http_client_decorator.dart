import 'package:course_clean_arch/data/cache/cache.dart';
import 'package:course_clean_arch/data/http/http.dart';

class AuthorizeHttpClientDecorator implements HttpClient {
  final FetchSecureCacheStorage fetchSecureCacheStorage;
  final DeleteSecureCacheStorage deleteSecureCacheStorage;
  final HttpClient httpClient;

  AuthorizeHttpClientDecorator({
    required this.fetchSecureCacheStorage,
    required this.deleteSecureCacheStorage,
    required HttpClient decoratee,
  }) : httpClient = decoratee;

  @override
  Future request({
    required String url,
    required String method,
    Map? headers,
    Map? body,
  }) async {
    try {
      final token = await fetchSecureCacheStorage.fetchSecure(
        'token',
      );

      return await httpClient.request(
        url: url,
        method: method,
        body: body,
        headers: headers ?? {}
          ..addAll({
            "x-access-token": token,
          }),
      );
    } on HttpError catch (e) {
      if (e == HttpError.forbidden) {
        await deleteSecureCacheStorage.delete('token');
      }

      rethrow;
    } catch (_) {
      await deleteSecureCacheStorage.delete('token');
      throw HttpError.forbidden;
    }
  }
}
