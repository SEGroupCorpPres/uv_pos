import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:uv_pos/features/data/remote/models/store_model.dart';

class StoreRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  CollectionReference storesReference = FirebaseFirestore.instance.collection('stores');

  StoreRepository({firebase_auth.FirebaseAuth? firebaseAuth, FirebaseFirestore? firestore})
      : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<String> createStore(StoreModel storeModel) async {
// Create a store document in Firestore
    try {
      // Write store document to Firestore
      await storesReference.doc(storeModel.id).set(storeModel.toMap()).onError(
        (e, _) {
          if (kDebugMode) {
            print("Error writing document: $e");
          }
        },
      );
      if (kDebugMode) {
        print('Store created successfully!');
      }
      return storeModel.id;
    } on FirebaseException catch (e) {
      // Handle Firestore exceptions
      throw Exception('Error creating store: ${e.message}');
    } catch (e) {
      // Handle other exceptions
      throw Exception('An unknown error occurred: $e');
    }
  }

  Future<StoreModel?> getStoreById(String id) async {
    try {
      DocumentSnapshot documentSnapshot = await storesReference.doc(id).get();
      if (documentSnapshot.exists) {
        return StoreModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
      } else {
        return null; // Handle the case where the document does not exist
      }
    } catch (e) {
      throw Exception('Error fetching store: $e');
    }
  }

  Future<List<StoreModel>> getStoresByUserId() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('stores')
          .where(
            'uid',
            isEqualTo: _firebaseAuth.currentUser!.uid,
          )
          .get();

      List<StoreModel> stores = querySnapshot.docs.map(
        (doc) {
          return StoreModel.fromMap(doc.data() as Map<String, dynamic>);
        },
      ).toList();

      return stores;
    } catch (e) {
      throw Exception('Error fetching stores: $e');
    }
  }

  Future<void> updateStore(StoreModel store) async {
    try {
      await _firestore.collection('stores').doc(store.id).update(
            store.toMap(),
          );
    } catch (e) {
      throw Exception('Error updating store: $e');
    }
  }

  Future<void> deleteStore(String storeId) async {
    try {
      await _firestore.collection('stores').doc(storeId).delete();
    } catch (e) {
      rethrow;
    }
  }
  // Send an image in a chat
  // static Future<void> sendChatImage(UserModel userModel, File file) async {
  //   final String ext = file.path.split('.').last;
  //   final Reference reference = _firebaseStorage.ref().child('images/${getConversationId(userModel.id!)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
  //   try {
  //     // Upload image to Firebase Storage
  //     await reference.putFile(file, SettableMetadata(contentType: 'image/$ext')).then(
  //           (p0) => log('Data Transferred: ${p0.bytesTransferred / 1000} kb'),
  //     );
  //     // Get image URL and send it as a message
  //     final String imageUrl = await reference.getDownloadURL();
  //     await sendMessage(userModel, imageUrl, Type.image);
  //   } on FirebaseException catch (e) {
  //     return;
  //   } catch (e) {
  //     return;
  //   }
  // }
}
