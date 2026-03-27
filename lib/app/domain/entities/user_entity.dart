import 'package:future_pos/core/core.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.phone,
    this.isVerified = false,
    this.role,
    this.status,
    this.shift,
    this.createdAt,
    this.lastLoginAt,
  });

  // JSON dan Entity
  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      uid: json['uid'] as String,
      displayName: json['displayName'] as String,
      photoUrl: json['photoUrl'] as String,
      phone: json['phone'] as String,
      isVerified: json['isVerified'] as bool,
      email: json['email'] as String,
      role: json['role'] as String,
      status: json['status'] as String,
      shift: json['shift'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLoginAt: DateTime.parse(json['lastLoginAt'] as String),
    );
  }

  @override
  List<Object?> get props => [
        uid,
        displayName,
        photoUrl,
        isVerified,
        phone,
        email,
        role,
        status,
        shift,
        createdAt,
        lastLoginAt
      ];

  final String uid;
  final String? displayName;
  final String? photoUrl;
  final String? phone;
  final bool isVerified;
  final String email;
  final String? role;
  final String? status;
  final String? shift;
  final DateTime? createdAt;
  final DateTime? lastLoginAt;

// Entity dan JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'phone': phone,
      'email': email,
      'role': role,
      'isVerified': isVerified,
      'status': status,
      'shift': shift,
      'createdAt': createdAt?.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          uid == other.uid;

  @override
  int get hashCode => uid.hashCode;

  @override
  String toString() =>
      'UserEntity(uid: $uid, email: $email, displayName: $displayName, photoUrl: $photoUrl, phone: $phone, isVerified: $isVerified, role: $role, status: $status, shift: $shift, createdAt: $createdAt, lastLoginAt: $lastLoginAt)';
}
