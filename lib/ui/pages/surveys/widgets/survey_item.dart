import 'package:course_clean_arch/ui/pages/surveys/survey_view_model.dart';
import 'package:flutter/material.dart';

class SurveyItem extends StatelessWidget {
  final SurveyViewModel item;

  const SurveyItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: item.didAnswered
            ? Theme.of(context).secondaryHeaderColor
            : Theme.of(context).primaryColorDark,
        boxShadow: [
          const BoxShadow(
            offset: Offset(0, 1),
            spreadRadius: 0,
            blurRadius: 2,
            color: Colors.black,
          ),
        ],
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.date,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            item.question,
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
