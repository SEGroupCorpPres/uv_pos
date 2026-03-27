// lib/app/data/models/user_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:future_pos/app/domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    @JsonKey(name: 'id') required String uid,
    required String email,
    @JsonKey(name: 'display_name') String? displayName,
    @JsonKey(name: 'photo_url') String? photoUrl,
    @JsonKey(name: 'phone_number') String? phone,
    @JsonKey(name: 'email_verified') @Default(false) bool isVerified,
    String? role,
    String? status,
    String? shift,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'last_login_at') DateTime? lastLoginAt,
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      uid: entity.uid,
      email: entity.email,
      displayName: entity.displayName,
      photoUrl: entity.photoUrl,
      phone: entity.phone,
      isVerified: entity.isVerified,
      status: entity.status,
      shift: entity.shift,
      role: entity.role,
      createdAt: entity.createdAt,
      lastLoginAt: entity.lastLoginAt,
    );
  }

  factory UserModel.empty() {
    return UserModel(
      uid: '',
      email: '',
      role: '',
      status: '',
      shift: '',
      createdAt: DateTime.now(),
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
      phone: phone,
      isVerified: isVerified,
      role: role,
      status: status,
      shift: shift,
      createdAt: createdAt,
      lastLoginAt: lastLoginAt,
    );
  }

  bool get isEmpty => uid.isEmpty;

  bool get isNotEmpty => uid.isNotEmpty;
}
