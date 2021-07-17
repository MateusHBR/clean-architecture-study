import 'package:flutter/material.dart';

import 'splash_presenter.dart';

class SplashPage extends StatefulWidget {
  final SplashPresenter presenter;

  SplashPage({
    Key? key,
    required this.presenter,
  }) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState(presenter);
}

class _SplashPageState extends State<SplashPage> {
  final SplashPresenter presenter;

  _SplashPageState(this.presenter);

  @override
  void initState() {
    super.initState();
    presenter.pushReplacementStream.listen((page) {
      if (page?.isNotEmpty == true) {
        Navigator.of(context).pushReplacementNamed(page!);
      }
    });

    presenter.checkAccount();
  }

  @override
  Widget build(BuildContext context) {
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
