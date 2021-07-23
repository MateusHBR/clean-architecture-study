import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/i18n/i18n.dart';
import '../signup.dart';

class PasswordConfirmationInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);

    return StreamBuilder<String?>(
      stream: presenter.emailErrorStream,
      builder: (context, snapshot) {
        final errorMessage = snapshot.data;

        return TextFormField(
          decoration: InputDecoration(
            labelText: R.strings.passwordConfirmation,
            icon: Icon(
              Icons.lock,
              color: Theme.of(context).primaryColorLight,
            ),
            errorText: errorMessage,
          ),
          onChanged: presenter.validatePasswordConfirmation,
          obscureText: true,
        );
      },
    );
  }
}
