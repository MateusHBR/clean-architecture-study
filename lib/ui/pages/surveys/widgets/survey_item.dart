import 'package:flutter/material.dart';

class SurveyItem extends StatelessWidget {
  const SurveyItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).secondaryHeaderColor,
        boxShadow: [
          const BoxShadow(
            offset: Offset(0, 1),
            spreadRadius: 0,
            blurRadius: 2,
            color: Colors.black,
          ),
        ],
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '20 ago 2020',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Qual é o seu framework mobile favorito?',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
