class SurveyEntity {
  final String id;
  final String question;
  final DateTime date;
  final bool didAnswered;

  SurveyEntity({
    required this.id,
    required this.question,
    required this.date,
    required this.didAnswered,
  });
}
