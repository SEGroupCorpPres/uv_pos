// lib/app/data/models/auth_response_model.dart
import 'package:uv_pos/app/app_barrel.dart';
import 'package:uv_pos/core/core.dart';

part 'auth_response_model.freezed.dart';
part 'auth_response_model.g.dart';

@freezed
abstract class AuthResponseModel with _$AuthResponseModel {
  const factory AuthResponseModel({
    required UserModel user,
    required TokenModel token,
  }) = _AuthResponseModel;

  const AuthResponseModel._();

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);
}
