import '../../domain/entities/entities.dart';

class RemoteAccountModel {
  final String token;

  RemoteAccountModel({
    required this.token,
  });

  factory RemoteAccountModel.fromJson(Map json) => RemoteAccountModel(
        token: json['accessToken'],
      );

  AccountEntity toEntity() => AccountEntity(token: token);
}
