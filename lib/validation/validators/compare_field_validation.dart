import 'package:equatable/equatable.dart';

import 'package:course_clean_arch/utils/i18n/i18n.dart';

import 'package:course_clean_arch/validation/protocols/protocols.dart';

class CompareFieldValidation extends Equatable implements FieldValidation {
  final String field;
  final String valueToCompare;

  CompareFieldValidation({
    required this.field,
    required this.valueToCompare,
  });

  @override
  List<Object?> get props => [
        field,
        valueToCompare,
      ];

  @override
  String? validate(String? value) {
    return R.strings.invalidField;
  }
}
