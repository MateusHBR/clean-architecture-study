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
      initialRoute: '/login',
      routes: {
        '/login': (context) => makeLoginPage(),
        '/surveys': (context) => Scaffold(body: Text('Enquetes')),
      },
    );
  }
}
