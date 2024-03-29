abstract class HttpClient {
  Future request({
    required String url,
    required String method,
    Map? headers,
    Map? body,
  });
}
