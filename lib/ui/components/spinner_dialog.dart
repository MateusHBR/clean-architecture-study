import 'package:course_clean_arch/utils/i18n/i18n.dart';
import 'package:flutter/material.dart';

void showLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return _loadingDialogWidget();
    },
  );
}

Widget _loadingDialogWidget() {
  return SimpleDialog(
    children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          const SizedBox(height: 10),
          Text(
            R.strings.wait,
            textAlign: TextAlign.center,
          ),
        ],
      )
    ],
  );
}

void hideLoading(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.of(context).pop();
  }
}
