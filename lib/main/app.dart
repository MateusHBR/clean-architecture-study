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
      initialRoute: '/survey_result/4',
      routes: {
        '/': (context) => makeSplashPage(),
        '/login': (context) => makeLoginPage(),
        '/surveys': (context) => makeSurveysPage(),
        '/survey_result/:survey_id': (context) => makeSurveyResultPage(),
      },
    );
  }
}
