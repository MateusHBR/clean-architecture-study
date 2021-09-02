import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/factories/factories.dart';

Authentication makeRemoteAuthentication() {
  return RemoteAuthentication(
    httpClient: makeHttpAdapter(),
    url: makeApiBaseUrl('login'),
  );
}
