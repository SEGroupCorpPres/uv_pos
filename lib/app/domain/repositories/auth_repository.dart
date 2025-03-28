import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uv_pos/features/data/remote/models/user_model.dart';

// Repository for handling user authentication and data
class AuthenticationRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  // Initialize with Firebase instances
  AuthenticationRepository({firebase_auth.FirebaseAuth? firebaseAuth, FirebaseFirestore? firestore})
      : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  // Get the currently logged-in user
  Future<UserModel?> getUser() async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) {
      return null;
    }
    // Store UID locally
    // Fetch additional user data from Firestore
    saveUID(firebaseUser.uid);
    // Fetch additional user data from Firestore if needed
    final userDoc = await _firestore.collection('users').doc(firebaseUser.uid).get();
    if (userDoc.exists) {
      return UserModel.fromMap(userDoc.data()!);
    } else {
      // Create a basic User instance if no Firestore data exists
      return UserModel(
        uid: firebaseUser.uid,
        email: firebaseUser.email,
        displayName: firebaseUser.displayName,
        phoneNumber: firebaseUser.phoneNumber,
        photoUrl: firebaseUser.photoURL,
      );
    }
  }

  // Create a new user account with email and password
  Future<void> createUser(String email, String password, String phoneNumber, String name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Create user with email and password

    try {
      // Create user in Firebase Authentication
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
          UserModel userModel = UserModel(
            uid: user.uid,
            displayName: name,
            email: email,
            password: password,
            phoneNumber: phoneNumber,
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
          if (kDebugMode) {
            print("Check your email to verify your account!");
          }
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

  // Update user information in Firestore
  Future<void> updateUser(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(
          user.toMap(),
          SetOptions(merge: true), // Merge with existing data
        );
  }

  // Sign the user out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await GoogleSignIn().signOut();
  }

  // Sign in with email and password
  Future<UserModel> signInWithEmail(String email, String password) async {
    // try {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Fetchuser data and store UID
    final user = await getUser();
    await saveUID(UserModel.fromFirebaseUser(userCredential).uid);
    return user ?? UserModel.fromFirebaseUser(userCredential);
    // } on firebase_auth.FirebaseAuthException catch (e) {
    //   if (e.code == 'user-not-found') {
    //     print('No user found for that email.');
    //     rethrow;
    //   } else if (e.code == 'wrong-password') {
    //     print('Wrong password provided for that user.');
    //     rethrow;
    //   }
    // } catch (e){
    //   rethrow;
    // }
  }

  // Sign in with Google
  Future<UserModel> signInWithGoogle() async {
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

    // Fetch user data and store UID
    final user = await getUser();
    await saveUID(UserModel.fromFirebaseUser(userCredential).uid);

    return user ?? UserModel.fromFirebaseUser(userCredential);
  }

  // Initiate phone number verification
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

  // Verify OTP code for phone authentication
  Future<UserModel> verifyOTP(String verificationId, String smsCode) async {
    final credential = firebase_auth.PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    final userCredential = await _firebaseAuth.signInWithCredential(credential);

    // Fetch user data
    final user = await getUser();
    return user ?? UserModel.fromFirebaseUser(userCredential);
  }

  // Save the user's UID in shared preferences
  Future<void> saveUID(String uid) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('uid', uid);
  }
}
