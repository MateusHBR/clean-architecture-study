import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../ui/values/values.dart';

import 'factories/factories.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Course Clean Architecture',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: makeLoginPage),
      ],
    );
  }
}
