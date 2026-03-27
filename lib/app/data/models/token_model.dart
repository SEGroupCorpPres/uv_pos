// lib/app/data/models/token_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:future_pos/app/domain/entities/token_entity.dart';

part 'token_model.freezed.dart';
part 'token_model.g.dart';

@freezed
abstract class TokenModel with _$TokenModel {
  const factory TokenModel({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    @JsonKey(name: 'expires_in') int? expiresIn,
    @JsonKey(name: 'token_type') @Default('Bearer') String tokenType,
  }) = _TokenModel;

  const TokenModel._();

  factory TokenModel.fromJson(Map<String, dynamic> json) =>
      _$TokenModelFromJson(json);

  factory TokenModel.fromEntity(TokenEntity entity) {
    return TokenModel(
      accessToken: entity.accessToken,
      refreshToken: entity.refreshToken,
      expiresIn: entity.expiresIn,
      tokenType: entity.tokenType,
    );
  }

  TokenEntity toEntity() {
    return TokenEntity(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresIn: expiresIn,
      tokenType: tokenType,
    );
  }
}
