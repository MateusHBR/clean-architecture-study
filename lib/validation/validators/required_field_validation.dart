import '../protocols/protocols.dart';

class RequiredFieldValidation implements FieldValidation {
  final String field;

  RequiredFieldValidation(this.field);

  @override
  String? validate(String? value) {
    final fieldIsBlankOrNull = value?.isEmpty ?? true;

    if (fieldIsBlankOrNull) {
      return 'Campo obrigatório.';
    }

    return null;
  }
}
