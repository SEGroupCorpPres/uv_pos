import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uv_pos/features/data/remote/models/user_model.dart';

class AuthenticationRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthenticationRepository({firebase_auth.FirebaseAuth? firebaseAuth, FirebaseFirestore? firestore})
      : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<User?> getUser() async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) {
      return null;
    }

    // Fetch additional user data from Firestore if needed
    final userDoc = await _firestore.collection('users').doc(firebaseUser.uid).get();
    if (userDoc.exists) {
      return User.fromMap(userDoc.data()!);
    } else {
      // Create a basic User instance from FirebaseUser
      return User(
        uid: firebaseUser.uid,
        email: firebaseUser.email,
        displayName: firebaseUser.displayName,
        phoneNumber: firebaseUser.phoneNumber,
        photoUrl: firebaseUser.photoURL,
        stores: const [], // Initialize with an empty list if no additional data
      );
    }
  }

  Future<void> createUser(String email, String password, String phoneNumber, String name) async {
    final registrationDate = Timestamp.now();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Create user with email and password

    try {
      firebase_auth.UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Get user from the user credentials
      firebase_auth.User? user = userCredential.user;

      if (user == null) {
        throw Exception('User registration failed');
      }
// Send verification email
      await user.sendEmailVerification();
      // Listen to the auth state changes to handle email verification
      _firebaseAuth.authStateChanges().listen((user) async {
        if (user != null && user.emailVerified) {
          // Once the user is verified, store their data in Firestore
// Create a user document in Firestore
          User userModel = User(
            uid: user.uid,
            displayName: name,
            email: email,
            password: password,
            phoneNumber: phoneNumber,
            stores: [], // Assuming a new user has no stores initially
          );
          // Write user document to Firestore
          await _firestore.collection('users').doc(user.uid).set(userModel.toMap()).onError(
            (e, _) {
              if (kDebugMode) {
                print("Error writing document: $e");
              }
            },
          );
          // Optionally, you might want to sign the user out until they verify their email
          await _firebaseAuth.signOut();
          // At this point, notify the user to check their email for verification
          print("Check your email to verify your account!");
          await prefs.setString('uid', user.uid);
          if (kDebugMode) {
            print('User created successfully!');
          }
        }
      });
    } on FirebaseException catch (e) {
      // Handle Firestore exceptions
      throw Exception('Error registering user: ${e.message}');
    } catch (e) {
      // Handle other exceptions
      throw Exception('An unknown error occurred: $e');
    }
  }

  Future<void> updateUser(User user) async {
    await _firestore.collection('users').doc(user.uid).set(
          user.toMap(),
          SetOptions(merge: true),
        );
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await GoogleSignIn().signOut();
  }

  Future<User> signInWithEmail(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Fetch additional user data from Firestore if needed
    final user = await getUser();
    return user ?? User.fromFirebaseUser(userCredential);
  }

  Future<User> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      throw Exception("Google sign-in aborted");
    }
    final googleAuth = await googleUser.authentication;
    final credential = firebase_auth.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final userCredential = await _firebaseAuth.signInWithCredential(credential);

    // Fetch additional user data from Firestore if needed
    final user = await getUser();
    return user ?? User.fromFirebaseUser(userCredential);
  }

  Future<void> verifyPhoneNumber(
    String phoneNumber,
    Duration timeout, {
    required void Function(String verificationId) codeSent,
    required void Function(firebase_auth.PhoneAuthCredential credential) verificationCompleted,
    required void Function(firebase_auth.FirebaseAuthException exception) verificationFailed,
    required void Function(String verificationId) codeAutoRetrievalTimeout,
  }) async {
    await _firebaseAuth.verifyPhoneNumber(
      timeout: timeout,
      phoneNumber: phoneNumber,
      codeSent: (verificationId, [forceResendingToken]) => codeSent(verificationId),
      verificationCompleted: (credential) => verificationCompleted(credential),
      verificationFailed: (exception) => verificationFailed(exception),
      codeAutoRetrievalTimeout: (verificationId) => codeAutoRetrievalTimeout(verificationId),
    );
  }

  Future<User> verifyOTP(String verificationId, String smsCode) async {
    final credential = firebase_auth.PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    final userCredential = await _firebaseAuth.signInWithCredential(credential);

    // Fetch additional user data from Firestore if needed
    final user = await getUser();
    return user ?? User.fromFirebaseUser(userCredential);
  }
}
