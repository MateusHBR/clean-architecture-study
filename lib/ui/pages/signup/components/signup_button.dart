import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/i18n/i18n.dart';
import '../signup_presenter.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);

    return StreamBuilder<bool>(
      stream: presenter.isFormValidStream,
      initialData: false,
      builder: (context, snapshot) {
        final isFormValid = snapshot.data!;

        return ElevatedButton(
          onPressed: isFormValid ? presenter.signUp : null,
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
      },
    );
  }
}
