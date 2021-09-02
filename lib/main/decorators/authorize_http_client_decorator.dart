import 'package:course_clean_arch/data/cache/cache.dart';
import 'package:course_clean_arch/data/http/http.dart';

class AuthorizeHttpClientDecorator implements HttpClient {
  final FetchSecureCacheStorage fetchSecureCacheStorage;
  final HttpClient httpClient;

  AuthorizeHttpClientDecorator({
    required this.fetchSecureCacheStorage,
    required this.httpClient,
  });

  @override
  Future request({
    required String url,
    required String method,
    Map? headers,
    Map? body,
  }) async {
    final token = await fetchSecureCacheStorage.fetchSecure(
      'token',
    );

    await httpClient.request(
      url: url,
      method: method,
      body: body,
      headers: headers ?? {}
        ..addAll({
          "x-access-token": token,
        }),
    );
  }
}
