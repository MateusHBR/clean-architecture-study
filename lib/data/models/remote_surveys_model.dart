import '../../domain/entities/entities.dart';

import '../http/http.dart';

class RemoteSurveysModel {
  final String id;
  final String question;
  final DateTime date;
  final bool didAnswered;

  RemoteSurveysModel({
    required this.id,
    required this.question,
    required this.date,
    required this.didAnswered,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'date': date.millisecondsSinceEpoch,
      'didAnswered': didAnswered,
    };
  }

  factory RemoteSurveysModel.fromJson(Map<dynamic, dynamic> json) {
    if (!json.keys.toSet().containsAll(
      ['id', 'question', 'date', 'didAnswered'],
    )) {
      throw HttpError.invalidData;
    }

    return RemoteSurveysModel(
      id: json['id'] ?? '',
      question: json['question'] ?? '',
      date: DateTime.parse(
        json['date'] ?? DateTime.now().toIso8601String(),
      ),
      didAnswered: json['didAnswered'] ?? false,
    );
  }

  SurveyEntity toEntity() => SurveyEntity(
        id: this.id,
        date: this.date,
        didAnswered: this.didAnswered,
        question: this.question,
      );
}
