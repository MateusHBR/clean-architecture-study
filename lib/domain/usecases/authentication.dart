import 'package:equatable/equatable.dart';

import '../entities/account_entity.dart';

abstract class Authentication {
  Future<AccountEntity> call(AuthenticationParams params);
}

class AuthenticationParams extends Equatable {
  final String email;
  final String password;

  AuthenticationParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}
