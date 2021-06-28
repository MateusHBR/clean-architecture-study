import 'package:flutter/material.dart';

import '../../assets/assets.dart';
import '../../components/components.dart';
import './login_presenter.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter presenter;

  const LoginPage({
    Key? key,
    required this.presenter,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState(presenter);
}

class _LoginPageState extends State<LoginPage> {
  final LoginPresenter presenter;

  _LoginPageState(this.presenter);

  @override
  void initState() {
    super.initState();

    presenter.isLoadingStream.listen(
      (isLoading) {
        if (isLoading) {
          showLoading(context);
        } else {
          hideLoading(context);
        }
      },
    );

    presenter.errorStream.listen((error) {
      if (error == null) {
        return;
      }
      showErrorMessage(context, error);
    });

    presenter.pushNamedAndRemoveUntilStream.listen((page) {
      if (page?.isNotEmpty ?? false) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          page!,
          (route) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    presenter.dispose();
    super.dispose();
  }

  void _hideKeyboard() {
    final currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _hideKeyboard,
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
          _emailInputField(),
          const SizedBox(height: 8),
          _passwordInputField(),
          const SizedBox(height: 32),
          _loginButton(),
          TextButton.icon(
            onPressed: () {},
            icon: Icon(Icons.person),
            label: Text('Criar conta'),
          ),
        ],
      ),
    );
  }

  Widget _emailInputField() {
    return StreamBuilder<String?>(
      stream: presenter.emailErrorStream,
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
          onChanged: presenter.validateEmail,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        );
      },
    );
  }

  Widget _passwordInputField() {
    return StreamBuilder<String?>(
      stream: presenter.passwordErrorStream,
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
          onChanged: presenter.validatePassword,
          obscureText: true,
        );
      },
    );
  }

  Widget _loginButton() {
    return StreamBuilder<bool>(
      stream: presenter.isFormValidStream,
      initialData: false,
      builder: (context, snapshot) {
        final isEnabled = snapshot.data ?? false;

        return ElevatedButton(
          onPressed: isEnabled
              ? () async {
                  _hideKeyboard();

                  await presenter.authenticate();
                }
              : null,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.disabled)) {
                return Colors.grey[300]!;
              }

              return Theme.of(context).primaryColor;
            }),
          ),
          child: Text(
            'Entrar'.toUpperCase(),
          ),
        );
      },
    );
  }
}
