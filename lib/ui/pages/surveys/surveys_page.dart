import 'package:course_clean_arch/utils/i18n/i18n.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import './widgets/widgets.dart';
import 'surveys_presenter.dart';

class SurveysPage extends StatefulWidget {
  final SurveysPresenter? presenter;

  const SurveysPage({
    Key? key,
    this.presenter,
  }) : super(key: key);

  @override
  _SurveysPageState createState() => _SurveysPageState(presenter);
}

class _SurveysPageState extends State<SurveysPage> {
  final SurveysPresenter? presenter;

  _SurveysPageState(this.presenter);

  @override
  void initState() {
    presenter!.loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(R.strings.surveys),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: CarouselSlider(
          options: CarouselOptions(
            enlargeCenterPage: true,
            aspectRatio: 1,
          ),
          items: [
            SurveyItem(),
          ],
        ),
      ),
    );
  }
}
