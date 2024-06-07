import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'store_model.dart';

class User extends Equatable {
  final String uid;
  final String? email;
  final String? displayName;
  final String? phoneNumber;
  final String? photoUrl;
  final String? password;
  final List<Store>? stores;

  const User({
    required this.uid,
    this.email,
    this.password,
    this.displayName,
    this.phoneNumber,
    this.photoUrl,
    this.stores = const [],
  });

  @override
  List<Object?> get props => [uid, email, password, displayName, phoneNumber, photoUrl, stores];

  // Create a User instance from FirebaseUser
  factory User.fromFirebaseUser(UserCredential userCredential) {
    final firebaseUser = userCredential.user!;
    return User(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      phoneNumber: firebaseUser.phoneNumber,
      photoUrl: firebaseUser.photoURL,
      stores: [], // Initially empty, to be fetched from database if necessary
    );
  }

  // Create a User instance from a map (including stores)
  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      uid: data['uid'],
      email: data['email'],
      password: data['password'],
      displayName: data['displayName'],
      phoneNumber: data['phoneNumber'],
      photoUrl: data['photoUrl'],
      stores: (data['stores'] as List<dynamic>).map((storeData) => Store.fromMap(storeData)).toList(),
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
      'stores': stores == null ? [] : stores!.map((store) => store.toMap()).toList(),
    };
  }
}
