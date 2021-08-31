import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../ui/components/components.dart';
import '../../../utils/i18n/i18n.dart';
import './widgets/widgets.dart';
import 'states/surveys_state.dart';
import 'survey_view_model.dart';
import 'surveys_presenter.dart';

class SurveysPage extends StatefulWidget {
  final SurveysPresenter presenter;

  const SurveysPage({
    Key? key,
    required this.presenter,
  }) : super(key: key);

  @override
  _SurveysPageState createState() => _SurveysPageState(presenter);
}

class _SurveysPageState extends State<SurveysPage> {
  final SurveysPresenter presenter;

  _SurveysPageState(this.presenter);

  @override
  void initState() {
    presenter.loadData();
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
          presenter.isLoadingStream.listen((isLoading) {
            if (isLoading) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          });

          return StreamBuilder<SurveysState>(
            stream: presenter.surveysStream,
            initialData: SurveysInitialState(),
            builder: (context, snapshot) {
              final data = snapshot.data!;

              if (data is SurveysErrorState) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        data.errorMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton.icon(
                        onPressed: () {
                          presenter.loadData();
                        },
                        icon: Icon(Icons.refresh),
                        label: Text(R.strings.reload),
                      ),
                    ],
                  ),
                );
              }

              if (data is SurveysSuccessState) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      enlargeCenterPage: true,
                      aspectRatio: 1,
                    ),
                    items: data.surveys.map((survey) {
                      return SurveyItem(
                        item: survey,
                      );
                    }).toList(),
                  ),
                );
              }

              return SizedBox();
            },
          );
        },
      ),
    );
  }
}
