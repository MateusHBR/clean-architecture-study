import 'package:equatable/equatable.dart';

import 'package:course_clean_arch/utils/i18n/i18n.dart';

import 'package:course_clean_arch/validation/protocols/protocols.dart';

class MinLengthValidation extends Equatable implements FieldValidation {
  final String field;
  final int size;

  MinLengthValidation({
    required this.field,
    required this.size,
  });

  @override
  List<Object?> get props => [field];

  @override
  String? validate(String? value) {
    if (value == null || value.length < this.size) {
      return R.strings.invalidField;
    }

    return null;
  }
}
