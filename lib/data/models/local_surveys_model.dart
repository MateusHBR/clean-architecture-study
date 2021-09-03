import '../../domain/entities/entities.dart';

import '../http/http.dart';

class LocalSurveysModel {
  final String id;
  final String question;
  final DateTime date;
  final bool didAnswer;

  LocalSurveysModel({
    required this.id,
    required this.question,
    required this.date,
    required this.didAnswer,
  });

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'question': question,
  //     'date': date.millisecondsSinceEpoch,
  //     'didAnswer': didAnswer,
  //   };
  // }

  factory LocalSurveysModel.fromJson(Map<dynamic, dynamic> json) {
    // if (!json.keys.toSet().containsAll(
    //   ['id', 'question', 'date', 'didAnswer'],
    // )) {
    //   throw HttpError.invalidData;
    // }

    return LocalSurveysModel(
      id: json['id'] ?? '',
      question: json['question'] ?? '',
      date: DateTime.parse(
        json['date'] ?? DateTime.now().toIso8601String(),
      ),
      didAnswer: bool.fromEnvironment(json['didAnswer']),
    );
  }

  SurveyEntity toEntity() => SurveyEntity(
        id: this.id,
        date: this.date,
        didAnswer: this.didAnswer,
        question: this.question,
      );
}
