import 'package:course_clean_arch/data/cache/cache.dart';
import 'package:course_clean_arch/data/http/http.dart';

class AuthorizeHttpClientDecorator implements HttpClient {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  AuthorizeHttpClientDecorator({
    required this.fetchSecureCacheStorage,
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
  }
}
