import '../protocols/protocols.dart';

class EmailFieldValidation implements FieldValidation {
  final String field;

  EmailFieldValidation(this.field);

  @override
  String? validate(String? value) {
    return null;
  }
}
