import 'package:flutter/material.dart';

class SurveyResultPageArguments {
  final int id;

  SurveyResultPageArguments({
    required this.id,
  });
}

class SurveyResultPage extends StatelessWidget {
  final SurveyResultPageArguments arguments;

  const SurveyResultPage({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: ListView.builder(
        itemCount: 4,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Text('Qual é o seu framework web favorito?');
          }

          return Text('Flutter.');
        },
      ),
    );
  }
}
