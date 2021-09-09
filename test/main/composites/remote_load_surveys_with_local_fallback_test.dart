import 'package:course_clean_arch/domain/entities/entities.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:course_clean_arch/data/usecases/usecases.dart';
import 'package:course_clean_arch/main/composites/composites.dart';

class RemoteLoadSurveysSpy extends Mock implements RemoteLoadSurveys {}

typedef SurveysExpectation = When<Future<List<SurveyEntity>>>;
void main() {
  late RemoteLoadSurveysWithLocalFallback sut;
  late RemoteLoadSurveysSpy remote;

  SurveysExpectation mockRemote() => when(() => remote());

  void mockRemoteSuccess(List<SurveyEntity> response) {
    mockRemote().thenAnswer((invocation) async => response);
  }

  setUp(() {
    remote = RemoteLoadSurveysSpy();
    sut = RemoteLoadSurveysWithLocalFallback(
      remoteLoadSurveys: remote,
    );

    mockRemoteSuccess([]);
  });

  test('Should call remote load', () async {
    await sut();

    verify(() => remote()).called(1);
  });
}
