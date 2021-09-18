import 'package:flutter/material.dart';

import '../ui/values/values.dart';

import 'factories/factories.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Clean Architecture',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => makeSplashPage(),
        '/login': (context) => makeLoginPage(),
        '/surveys': (context) => makeSurveysPage(),
        '/survey_result': (context) {
          // final args = ModalRoute.of(context)!.settings.arguments
          //     as SurveyResultPageArguments;

          return makeSurveyResultPage(SurveyResultPageArguments(id: 0));
          // return makeSurveyResultPage(args);
        }
      },
    );
  }
}
