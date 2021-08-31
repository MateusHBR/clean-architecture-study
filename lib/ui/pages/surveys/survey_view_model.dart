import 'package:equatable/equatable.dart';

class SurveyViewModel extends Equatable {
  final String id;
  final String question;
  final String date;
  final bool didAnswered;

  SurveyViewModel({
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
