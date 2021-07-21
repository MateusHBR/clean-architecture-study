import 'package:equatable/equatable.dart';

import '../../utils/i18n/i18n.dart';
import '../protocols/protocols.dart';

class RequiredFieldValidation extends Equatable implements FieldValidation {
  final String field;

  RequiredFieldValidation(this.field);

  @override
  List<Object?> get props => [field];

  @override
  String? validate(String? value) {
    final fieldIsBlankOrNull = value?.isEmpty ?? true;

    if (fieldIsBlankOrNull) {
      return R.strings.requiredField;
    }

    return null;
  }
}
