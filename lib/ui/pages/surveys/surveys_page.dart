import 'package:course_clean_arch/ui/pages/surveys/survey_view_model.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../../ui/components/components.dart';
import '../../../utils/i18n/i18n.dart';
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
      body: Builder(
        builder: (context) {
          presenter!.isLoadingStream.listen((isLoading) {
            if (isLoading) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          });

          return StreamBuilder<List<SurveyViewModel>>(
            stream: presenter!.loadSurveysStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Column(
                  children: [
                    Text(snapshot.error.toString()),
                    TextButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.refresh),
                      label: Text(R.strings.reload),
                    ),
                  ],
                );
              }

              return Padding(
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
              );
            },
          );
        },
      ),
    );
  }
}
