import 'package:course_clean_arch/utils/i18n/i18n.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'app.dart';

void main() {
  R.load(Platform.localeName);

  runApp(App());
}
