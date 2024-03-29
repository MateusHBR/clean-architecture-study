import 'package:flutter/material.dart';

import '../../../utils/i18n/i18n.dart';
import '../../assets/assets.dart';
import '../../components/components.dart';
import '../../mixings/mixings.dart';
import 'login_presenter.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter presenter;

  const LoginPage({
    Key? key,
    required this.presenter,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState(presenter);
}

class _LoginPageState extends State<LoginPage> with NavigationMixing {
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

    pushNamedAndRemoveUntil(
      navigationStream: presenter.pushNamedAndRemoveUntilStream,
      context: context,
    );
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
            label: Text(R.strings.createAccount),
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
            labelText: R.strings.email,
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
            labelText: R.strings.password,
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
            R.strings.enter.toUpperCase(),
          ),
        );
      },
    );
  }
}
