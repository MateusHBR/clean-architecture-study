import '../entities/account_entity.dart';

abstract class SaveCurrentAccount {
  Future<void> call(AccountEntity account);
}
