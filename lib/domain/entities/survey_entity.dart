import 'package:equatable/equatable.dart';

class SurveyEntity extends Equatable {
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

  @override
  List<Object> get props => [
        id,
        question,
        date,
        didAnswered,
      ];
}
