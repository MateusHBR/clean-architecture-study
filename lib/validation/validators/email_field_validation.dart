import 'package:equatable/equatable.dart';

import '../protocols/protocols.dart';

class EmailFieldValidation extends Equatable implements FieldValidation {
  final String field;

  EmailFieldValidation(this.field);

  @override
  List<Object?> get props => [field];

  @override
  String? validate(String? value) {
    final fieldIsBlankOrNull = value?.isEmpty ?? true;

    if (fieldIsBlankOrNull) {
      return null;
    }

    final emailValidatorRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );

    final isValid = emailValidatorRegExp.hasMatch(value!);

    if (!isValid) {
      return 'Email inválido.';
    }

    return null;
  }
}
