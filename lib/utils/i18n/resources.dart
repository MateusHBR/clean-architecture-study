import 'strings/strings.dart';

class R {
  static Translations strings = EnUs();

  static void load(String localeName) {
    print(localeName);
    switch (localeName) {
      case 'pt_BR':
        strings = PtBr();
        break;
      default:
        strings = EnUs();
        break;
    }
  }
}
