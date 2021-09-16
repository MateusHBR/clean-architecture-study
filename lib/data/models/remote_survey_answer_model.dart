import '../../domain/entities/entities.dart';

import '../http/http.dart';

class RemoteSurveyAnswerModel {
  final String answer;
  final String? image;
  final bool isCurrentAccountAnswer;
  final int percent;

  RemoteSurveyAnswerModel({
    this.image,
    required this.answer,
    required this.isCurrentAccountAnswer,
    required this.percent,
  });

  Map<String, dynamic> toJson() {
    return {
      'answer': answer,
      'image': image,
      'isCurrentAccountAnswer': isCurrentAccountAnswer,
      'percent': percent,
    };
  }

  factory RemoteSurveyAnswerModel.fromJson(Map<dynamic, dynamic> json) {
    if (!json.keys.toSet().containsAll(
      ['answer', 'isCurrentAccountAnswer', 'percent'],
    )) {
      throw HttpError.invalidData;
    }

    return RemoteSurveyAnswerModel(
      image: json['image'],
      answer: json['answer'] ?? '',
      percent: json['percent'] ?? 0,
      isCurrentAccountAnswer: json['isCurrentAccountAnswer'] ?? false,
    );
  }

  SurveyAnswerEntity toEntity() => SurveyAnswerEntity(
        answer: this.answer,
        image: this.image,
        percent: this.percent,
        isCurrentAnswer: this.isCurrentAccountAnswer,
      );
}
