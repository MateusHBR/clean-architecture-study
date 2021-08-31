import 'package:equatable/equatable.dart';

import '../survey_view_model.dart';

abstract class SurveysState {}

class SurveysInitialState implements SurveysState {}

class SurveysSuccessState extends Equatable implements SurveysState {
  final List<SurveyViewModel> surveys;

  SurveysSuccessState({
    required this.surveys,
  });

  @override
  List<Object> get props => [surveys];
}

class SurveysErrorState extends Equatable implements SurveysState {
  final String errorMessage;

  SurveysErrorState({
    required this.errorMessage,
  });

  @override
  List<Object> get props => [errorMessage];
}
