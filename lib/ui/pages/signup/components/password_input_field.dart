import 'package:flutter/material.dart';

import '../../../../utils/i18n/i18n.dart';

class PasswordInputField extends StatelessWidget {
  const PasswordInputField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: R.strings.password,
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
