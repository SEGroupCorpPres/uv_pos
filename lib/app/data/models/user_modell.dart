import 'dart:convert';

/// id : "u_1024"
/// username : "cashier_01"
/// fullName : "Ali Valiyev"
/// image : "djkfgasukd"
/// phone : "+998901234567"
/// email : "ali@pos.com"
/// role : "cashier"
/// status : "active"
/// shift : "morning"
/// createdAt : "2025-01-10T08:30:00.000Z"
/// lastLoginAt : "2025-01-16T09:01:22.000Z"

UserModell userModellFromJson(String str) => UserModell.fromJson(json.decode(str));

String userModellToJson(UserModell data) => json.encode(data.toJson());

class UserModell {
  UserModell({
    String? id,
    String? username,
    String? fullName,
    String? image,
    String? phone,
    String? email,
    String? role,
    String? status,
    String? shift,
    String? createdAt,
    String? lastLoginAt,
  }) {
    _id = id;
    _username = username;
    _fullName = fullName;
    _image = image;
    _phone = phone;
    _email = email;
    _role = role;
    _status = status;
    _shift = shift;
    _createdAt = createdAt;
    _lastLoginAt = lastLoginAt;
  }

  UserModell.fromJson(dynamic json) {
    _id = json['id'] as String;
    _username = json['username'] as String;
    _fullName = json['fullName'] as String;
    _image = json['image'] as String;
    _phone = json['phone'] as String;
    _email = json['email'] as String;
    _role = json['role'] as String;
    _status = json['status'] as String;
    _shift = json['shift'] as String;
    _createdAt = json['createdAt'] as String;
    _lastLoginAt = json['lastLoginAt'] as String;
  }

  String? _id;
  String? _username;
  String? _fullName;
  String? _image;
  String? _phone;
  String? _email;
  String? _role;
  String? _status;
  String? _shift;
  String? _createdAt;
  String? _lastLoginAt;

  UserModell copyWith({
    String? id,
    String? username,
    String? fullName,
    String? image,
    String? phone,
    String? email,
    String? role,
    String? status,
    String? shift,
    String? createdAt,
    String? lastLoginAt,
  }) =>
      UserModell(
        id: id ?? _id,
        username: username ?? _username,
        fullName: fullName ?? _fullName,
        image: image ?? _image,
        phone: phone ?? _phone,
        email: email ?? _email,
        role: role ?? _role,
        status: status ?? _status,
        shift: shift ?? _shift,
        createdAt: createdAt ?? _createdAt,
        lastLoginAt: lastLoginAt ?? _lastLoginAt,
      );

  String? get id => _id;

  String? get username => _username;

  String? get fullName => _fullName;

  String? get image => _image;

  String? get phone => _phone;

  String? get email => _email;

  String? get role => _role;

  String? get status => _status;

  String? get shift => _shift;

  String? get createdAt => _createdAt;

  String? get lastLoginAt => _lastLoginAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['username'] = _username;
    map['fullName'] = _fullName;
    map['image'] = _image;
    map['phone'] = _phone;
    map['email'] = _email;
    map['role'] = _role;
    map['status'] = _status;
    map['shift'] = _shift;
    map['createdAt'] = _createdAt;
    map['lastLoginAt'] = _lastLoginAt;
    return map;
  }
}
