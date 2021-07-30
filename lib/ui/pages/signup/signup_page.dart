import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/i18n/i18n.dart';
import '../../assets/assets.dart';
import '../../components/components.dart';
import 'components/components.dart';
import 'signup_presenter.dart';

class SignUpPage extends StatelessWidget {
  final SignUpPresenter presenter;

  const SignUpPage({
    Key? key,
    required this.presenter,
  }) : super(key: key);

  void _hideKeyboard(BuildContext context) {
    final currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    presenter.isLoadingStream.listen((isLoading) {
      if (isLoading) {
        showLoading(context);
      } else {
        hideLoading(context);
      }
    });

    return Scaffold(
      body: GestureDetector(
        onTap: () => _hideKeyboard(context),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _header(context),
              _body(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      height: 240,
      margin: EdgeInsets.only(bottom: 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Theme.of(context).primaryColorLight,
            Theme.of(context).primaryColorDark,
          ],
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 0),
            spreadRadius: 0,
            blurRadius: 4,
            color: Colors.black,
          ),
        ],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(80),
        ),
      ),
      child: Image(
        image: AssetImage(Images.logo),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      children: [
        Text(
          R.strings.login.toUpperCase(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline1,
        ),
        Padding(
          padding: EdgeInsets.all(32),
          child: _form(context),
        ),
      ],
    );
  }

  Widget _form(context) {
    return Provider(
      create: (_) => presenter,
      child: Form(
        child: Column(
          children: [
            NameInputField(),
            const SizedBox(height: 8),
            EmailInputField(),
            const SizedBox(height: 8),
            PasswordInputField(),
            const SizedBox(height: 32),
            PasswordConfirmationInputField(),
            const SizedBox(height: 32),
            const SignUpButton(),
            TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.exit_to_app),
              label: Text(R.strings.login),
            ),
          ],
        ),
      ),
    );
  }
}
