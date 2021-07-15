import 'package:flutter/material.dart';

import 'splash_presenter.dart';

class SplashPage extends StatelessWidget {
  final SplashPresenter presenter;

  SplashPage({
    Key? key,
    required this.presenter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    presenter.pushReplacementStream.listen((page) {
      if (page?.isNotEmpty == true) {
        Navigator.of(context).pushReplacementNamed(page!);
      }
    });

    presenter.loadCurrentAccount();

    return Scaffold(
      appBar: AppBar(
        title: Text('4Dev'),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
