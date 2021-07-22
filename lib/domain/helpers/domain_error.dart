import '../../utils/i18n/i18n.dart';

enum DomainError {
  unexpected,
  invalidCredentials,
  emailInUse,
}

extension DomainErrorExtension on DomainError {
  String get description {
    switch (this) {
      case DomainError.invalidCredentials:
        return R.strings.invalidCredentials;

      case DomainError.unexpected:
        return R.strings.unexpectedErrorTryAgain;

      case DomainError.emailInUse:
        return R.strings.emailInUse;

      default:
        return '';
    }
  }
}
