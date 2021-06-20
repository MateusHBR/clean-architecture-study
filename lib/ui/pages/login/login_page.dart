import 'package:flutter/material.dart';

import '../../assets/assets.dart';

import './login_presenter.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter? presenter;

  const LoginPage({
    Key? key,
    required this.presenter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _header(context),
            _body(context),
          ],
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
          'Login'.toUpperCase(),
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
    return Form(
      child: Column(
        children: [
          StreamBuilder<String?>(
            stream: presenter!.emailErrorStream,
            builder: (context, snapshot) {
              final errorMessage =
                  snapshot.data?.isEmpty == true ? null : snapshot.data;

              return TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  icon: Icon(
                    Icons.email,
                    color: Theme.of(context).primaryColorLight,
                  ),
                  errorText: errorMessage,
                ),
                onChanged: presenter!.validateEmail,
                keyboardType: TextInputType.emailAddress,
              );
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Senha',
              icon: Icon(
                Icons.lock,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
            onChanged: presenter!.validatePassword,
            obscureText: true,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: null,
            child: Text(
              'Entrar'.toUpperCase(),
            ),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: Icon(Icons.person),
            label: Text('Criar conta'),
          ),
        ],
      ),
    );
  }
}
