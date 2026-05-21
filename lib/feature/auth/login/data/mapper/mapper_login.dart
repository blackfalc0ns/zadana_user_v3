import 'package:zadana_user_v3/feature/auth/login/data/models/login_request_model_dto.dart';
import 'package:zadana_user_v3/feature/auth/login/data/models/login_response_model_dto.dart';
import 'package:zadana_user_v3/feature/auth/login/data/models/tokens_model_dto.dart';
import 'package:zadana_user_v3/feature/auth/login/data/models/user_model_dto.dart';
import 'package:zadana_user_v3/feature/auth/login/domain/entities/login_request_entity.dart';
import 'package:zadana_user_v3/feature/auth/login/domain/entities/login_response_entity.dart';
import 'package:zadana_user_v3/feature/auth/login/domain/entities/tokens_entity.dart';
import 'package:zadana_user_v3/feature/auth/login/domain/entities/user_entity.dart';

extension LoginRequestEntityMapper on LoginRequestEntity {
  LoginRequestModelDto toDto() {
    return LoginRequestModelDto(identifier: identifier, password: password);
  }
}

extension TokensModelMapper on TokensModelDto {
  TokensEntity toEntity() {
    return TokensEntity(accessToken: accessToken, refreshToken: refreshToken);
  }
}

extension UserModelMapper on UserModelDto {
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      fullName: fullName,
      email: email,
      phone: phone,
      role: role,
      profilePhotoUrl: profilePhotoUrl,
    );
  }
}

extension LoginResponseModelMapper on LoginResponseModelDto {
  LoginResponseEntity toEntity() {
    return LoginResponseEntity(
      tokens: tokens.toEntity(),
      user: user.toEntity(),
    );
  }
}
