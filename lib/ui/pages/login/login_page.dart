import 'package:flutter/material.dart';

import '../../assets/assets.dart';
import '../../components/components.dart';
import './login_presenter.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter? presenter;

  const LoginPage({
    Key? key,
    required this.presenter,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    widget.presenter!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          widget.presenter!.isLoadingStream.listen(
            (isLoading) {
              if (isLoading) {
                showLoading(context);
              } else {
                hideLoading(context);
              }
            },
          );

          widget.presenter!.isErrorStream.listen((error) {
            if (error != null) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red[900],
                  content: Text(error, textAlign: TextAlign.center),
                ),
              );
            }
          });

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _header(context),
                _body(context),
              ],
            ),
          );
        },
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
            stream: widget.presenter!.emailErrorStream,
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
                onChanged: widget.presenter!.validateEmail,
                keyboardType: TextInputType.emailAddress,
              );
            },
          ),
          const SizedBox(height: 8),
          StreamBuilder<String?>(
            stream: widget.presenter!.passwordErrorStream,
            builder: (context, snapshot) {
              final errorMessage =
                  snapshot.data?.isEmpty == true ? null : snapshot.data;

              return TextFormField(
                decoration: InputDecoration(
                  labelText: 'Senha',
                  icon: Icon(
                    Icons.lock,
                    color: Theme.of(context).primaryColorLight,
                  ),
                  errorText: errorMessage,
                ),
                onChanged: widget.presenter!.validatePassword,
                obscureText: true,
              );
            },
          ),
          const SizedBox(height: 32),
          StreamBuilder<bool>(
            stream: widget.presenter!.isFormValidStream,
            initialData: false,
            builder: (context, snapshot) {
              final isEnabled = snapshot.data ?? false;

              return ElevatedButton(
                onPressed: isEnabled ? widget.presenter!.authenticate : null,
                child: Text(
                  'Entrar'.toUpperCase(),
                ),
              );
            },
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
