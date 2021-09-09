import '../../../data/usecases/usecases.dart';

import '../../../domain/usecases/usecases.dart';

import '../../composites/composites.dart';

import '../factories.dart';

LoadSurveys makeRemoteLoadSurveys() {
  return RemoteLoadSurveys(
    httpClient: makeAuthorizeHttpDecorator(),
    url: makeApiBaseUrl('surveys'),
  );
}

LoadSurveys makeLocalLoadSurveys() {
  return LocalLoadSurveys(cacheStorage: makeLocalStorageAdapter());
}

LoadSurveys makeRemoteLoadSurveysWithLocalFallback() {
  return RemoteLoadSurveysWithLocalFallback(
    remoteLoadSurveys: makeRemoteLoadSurveys() as RemoteLoadSurveys,
    localLoadSurveys: makeLocalLoadSurveys() as LocalLoadSurveys,
  );
}
