import 'package:course_clean_arch/domain/entities/entities.dart';

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

  factory RemoteSurveysModel.fromJson(Map<dynamic, dynamic> map) {
    return RemoteSurveysModel(
      id: map['id'] ?? '',
      question: map['question'] ?? '',
      date: DateTime.parse(
        map['date'] ?? DateTime.now().toIso8601String(),
      ),
      didAnswered: map['didAnswered'] ?? false,
    );
  }

  SurveyEntity toEntity() => SurveyEntity(
        id: this.id,
        date: this.date,
        didAnswered: this.didAnswered,
        question: this.question,
      );
}
