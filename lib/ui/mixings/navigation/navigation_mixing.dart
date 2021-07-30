import 'package:flutter/widgets.dart';

mixin NavigationMixing {
  void pushNamedAndRemoveUntil({
    required Stream<String?> navigationStream,
    required BuildContext context,
  }) {
    navigationStream.listen((page) {
      if (page?.isNotEmpty ?? false) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          page!,
          (route) => false,
        );
      }
    });
  }
}
