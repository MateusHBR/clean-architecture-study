import '../../domain/entities/entities.dart';

import '../http/http.dart';

class RemoteAccountModel {
  final String token;

  RemoteAccountModel({
    required this.token,
  });

  factory RemoteAccountModel.fromJson(Map json) {
    if (!json.containsKey('accessToken')) {
      throw HttpError.invalidData;
    }

    return RemoteAccountModel(token: json['accessToken']);
  }

  AccountEntity toEntity() => AccountEntity(token: token);
}
