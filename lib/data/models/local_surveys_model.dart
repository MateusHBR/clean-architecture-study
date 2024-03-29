import '../../domain/entities/entities.dart';

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

  factory LocalSurveysModel.fromJson(Map<dynamic, dynamic> json) {
    if (!json.keys.toSet().containsAll(
      ['id', 'question', 'date', 'didAnswer'],
    )) {
      throw Exception('Error, does not have the correct values');
    }

    return LocalSurveysModel(
      id: json['id'] ?? '',
      question: json['question'] ?? '',
      date: DateTime.parse(
        json['date'] ?? DateTime.now().toIso8601String(),
      ),
      didAnswer: bool.fromEnvironment(json['didAnswer']),
    );
  }

  factory LocalSurveysModel.fromEntity(SurveyEntity entity) =>
      LocalSurveysModel(
        id: entity.id,
        question: entity.question,
        date: entity.date,
        didAnswer: entity.didAnswer,
      );

  SurveyEntity toEntity() => SurveyEntity(
        id: this.id,
        date: this.date,
        didAnswer: this.didAnswer,
        question: this.question,
      );

  Map<String, String> toJson() {
    return {
      'id': id,
      'question': question,
      'date': date.toIso8601String(),
      'didAnswer': didAnswer.toString(),
    };
  }
}
