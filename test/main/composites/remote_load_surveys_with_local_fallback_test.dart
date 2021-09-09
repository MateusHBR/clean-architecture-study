import 'package:course_clean_arch/domain/entities/entities.dart';
import 'package:course_clean_arch/domain/helpers/helpers.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:course_clean_arch/data/usecases/usecases.dart';
import 'package:course_clean_arch/main/composites/composites.dart';

class RemoteLoadSurveysSpy extends Mock implements RemoteLoadSurveys {}

class LocalLoadSurveysSpy extends Mock implements LocalLoadSurveys {}

typedef SurveysExpectation = When<Future<List<SurveyEntity>>>;

void main() {
  late RemoteLoadSurveysWithLocalFallback sut;
  late RemoteLoadSurveysSpy remote;
  late LocalLoadSurveysSpy local;

  List<SurveyEntity> mockSurveys() => [
        SurveyEntity(
          id: faker.guid.guid(),
          date: faker.date.dateTime(),
          didAnswer: true,
          question: faker.randomGenerator.string(10),
        ),
      ];

  SurveysExpectation mockRemote() => when(() => remote());
  SurveysExpectation mockLocal() => when(() => local());

  When<Future<void>> mockSave() => when(() => local.save(any()));
  When<Future<void>> mockValidate() => when(() => local.validate());

  void mockRemoteSuccess(List<SurveyEntity> response) {
    mockRemote().thenAnswer((_) async => response);
  }

  void mockLocalSuccess(List<SurveyEntity> response) =>
      mockLocal().thenAnswer((_) async => response);

  void mockSaveSuccess() => mockSave().thenAnswer((_) async => {});

  void mockValidateSuccess() => mockValidate().thenAnswer((_) async => {});

  void mockRemoteError(DomainError error) {
    mockRemote().thenThrow(error);
  }

  setUp(() {
    local = LocalLoadSurveysSpy();
    remote = RemoteLoadSurveysSpy();
    sut = RemoteLoadSurveysWithLocalFallback(
      remoteLoadSurveys: remote,
      localLoadSurveys: local,
    );

    final surveys = mockSurveys();

    mockRemoteSuccess(surveys);
    mockSaveSuccess();

    mockLocalSuccess(surveys);
    mockValidateSuccess();
  });

  test('Should call remote load', () async {
    await sut();

    verify(() => remote()).called(1);
  });

  test('Should call local save', () async {
    final surveys = mockSurveys();

    mockRemoteSuccess(surveys);
    mockSaveSuccess();

    await sut();

    verify(() => local.save(surveys)).called(1);
  });

  test('should return remote data', () async {
    final surveys = mockSurveys();

    mockRemoteSuccess(surveys);

    final remoteResult = await sut();

    expect(surveys, remoteResult);
  });

  test('should rethrow if remote load throws AccessDeniedError', () async {
    mockRemoteError(DomainError.accessDenied);
    final future = sut();

    expect(future, throwsA(DomainError.accessDenied));
  });

  test('should call local fetch on remote error', () async {
    mockRemoteError(DomainError.unexpected);

    await sut();

    verify(() => local.validate());
    verify(() => local());
  });

  test('should return local data on remote error', () async {
    mockRemoteError(DomainError.unexpected);

    final surveys = mockSurveys();
    mockLocalSuccess(surveys);
    mockValidateSuccess();
    final localData = await sut();

    expect(localData, surveys);
  });
}
