import '../../utils/i18n/i18n.dart';

enum DomainError {
  unexpected,
  invalidCredentials,
}

extension DomainErrorExtension on DomainError {
  String get description {
    switch (this) {
      case DomainError.invalidCredentials:
        return R.strings.invalidCredentials;

      case DomainError.unexpected:
        return R.strings.unexpectedErrorTryAgain;

      default:
        return '';
    }
  }
}
