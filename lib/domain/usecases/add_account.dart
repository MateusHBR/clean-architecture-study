import 'package:equatable/equatable.dart';

import '../entities/account_entity.dart';

abstract class AddAccount {
  Future<AccountEntity> call(AddAccountParams params);
}

class AddAccountParams extends Equatable {
  final String email;
  final String password;
  final String name;
  final String passwordConfirmation;

  AddAccountParams({
    required this.email,
    required this.password,
    required this.name,
    required this.passwordConfirmation,
  });

  @override
  List<Object?> get props => [
        email,
        password,
        name,
        passwordConfirmation,
      ];
}
