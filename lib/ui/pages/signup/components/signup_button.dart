import 'package:flutter/material.dart';

import '../../../../utils/i18n/i18n.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: null,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.grey[300]!;
            }

            return Theme.of(context).primaryColor;
          },
        ),
      ),
      child: Text(
        R.strings.createAccount.toUpperCase(),
      ),
    );
  }
}
