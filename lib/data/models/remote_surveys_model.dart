import '../../domain/entities/entities.dart';

import '../http/http.dart';

class RemoteSurveysModel {
  final String id;
  final String question;
  final DateTime date;
  final bool didAnswer;

  RemoteSurveysModel({
    required this.id,
    required this.question,
    required this.date,
    required this.didAnswer,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'date': date.millisecondsSinceEpoch,
      'didAnswer': didAnswer,
    };
  }

  factory RemoteSurveysModel.fromJson(Map<dynamic, dynamic> json) {
    if (!json.keys.toSet().containsAll(
      ['id', 'question', 'date', 'didAnswer'],
    )) {
      throw HttpError.invalidData;
    }

    return RemoteSurveysModel(
      id: json['id'] ?? '',
      question: json['question'] ?? '',
      date: DateTime.parse(
        json['date'] ?? DateTime.now().toIso8601String(),
      ),
      didAnswer: json['didAnswer'] ?? false,
    );
  }

  SurveyEntity toEntity() => SurveyEntity(
        id: this.id,
        date: this.date,
        didAnswer: this.didAnswer,
        question: this.question,
      );
}
