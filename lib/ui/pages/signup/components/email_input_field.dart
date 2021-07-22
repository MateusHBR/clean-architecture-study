import 'package:flutter/material.dart';

import '../../../../utils/i18n/i18n.dart';

class EmailInputField extends StatelessWidget {
  const EmailInputField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: R.strings.email,
        icon: Icon(
          Icons.email,
          color: Theme.of(context).primaryColorLight,
        ),
        // errorText: ,
      ),
      // onChanged: presenter.validateEmail,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
    );
  }
}
