import 'package:flutter/material.dart';

import '../../../../utils/i18n/i18n.dart';

class PasswordConfirmationInputField extends StatelessWidget {
  const PasswordConfirmationInputField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: R.strings.passwordConfirmation,
        icon: Icon(
          Icons.lock,
          color: Theme.of(context).primaryColorLight,
        ),
        // errorText: errorMessage,
      ),
      // onChanged: presenter.validatePassword,
      obscureText: true,
    );
  }
}
