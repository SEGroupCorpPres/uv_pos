import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'store_model.dart';

class UserModel extends Equatable {
  final String uid;
  final String? email;
  final String? displayName;
  final String? phoneNumber;
  final String? photoUrl;
  final String? password;

  const UserModel({
    required this.uid,
    this.email,
    this.password,
    this.displayName,
    this.phoneNumber,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [uid, email, password, displayName, phoneNumber, photoUrl];

  // Create a User instance from FirebaseUser
  factory UserModel.fromFirebaseUser(UserCredential userCredential) {
    final firebaseUser = userCredential.user!;
    return UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      phoneNumber: firebaseUser.phoneNumber,
      photoUrl: firebaseUser.photoURL,
    );
  }

  // Create a User instance from a map (including stores)
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'],
      email: data['email'],
      password: data['password'],
      displayName: data['displayName'],
      phoneNumber: data['phoneNumber'],
      photoUrl: data['photoUrl'],
    );
  }

  // Convert User instance to map (useful for database storage)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'password': password,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
    };
  }
}
