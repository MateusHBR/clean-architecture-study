import 'package:flutter/material.dart';

import '../../../../utils/i18n/i18n.dart';

class NameInputField extends StatelessWidget {
  const NameInputField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: R.strings.name,
        icon: Icon(
          Icons.person,
          color: Theme.of(context).primaryColorLight,
        ),
        // errorText: ,
      ),
      // onChanged: presenter.validateEmail,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
    );
  }
}
