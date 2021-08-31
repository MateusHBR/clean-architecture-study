import 'package:flutter/material.dart';

import '../../../../ui/pages/pages.dart';
import './survey_presenter_factory.dart';

Widget makeSurveysPage() => SurveysPage(
      presenter: makeGetxSurveysPresenter(),
    );
