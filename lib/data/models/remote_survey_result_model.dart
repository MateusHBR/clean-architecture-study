import '../../domain/entities/entities.dart';

import '../http/http.dart';
import './models.dart';

class RemoteSurveyResultModel {
  final String surveyId;
  final String question;
  final List<RemoteSurveyAnswerModel> answers;

  RemoteSurveyResultModel({
    required this.surveyId,
    required this.question,
    required this.answers,
  });

  Map<String, dynamic> toJson() {
    return {
      'surveyId': surveyId,
      'question': question,
      'answers': answers,
    };
  }

  factory RemoteSurveyResultModel.fromJson(Map<dynamic, dynamic> json) {
    if (!json.keys.toSet().containsAll(
      ['surveyId', 'question', 'answers'],
    )) {
      throw HttpError.invalidData;
    }

    return RemoteSurveyResultModel(
      surveyId: json['surveyId'] ?? '',
      question: json['question'] ?? '',
      answers: json['answers']
              .map<RemoteSurveyAnswerModel>(
                (answerJson) => RemoteSurveyAnswerModel.fromJson(answerJson),
              )
              .toList() ??
          [],
    );
  }

  SurveyResultEntity toEntity() => SurveyResultEntity(
        surveyId: this.surveyId,
        question: this.question,
        answers: this
            .answers
            .map<SurveyAnswerEntity>((answer) => answer.toEntity())
            .toList(),
      );
}
