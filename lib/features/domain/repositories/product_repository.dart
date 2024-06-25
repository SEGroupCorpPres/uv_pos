import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uv_pos/features/data/remote/models/product_model.dart';
import 'package:uv_pos/features/data/remote/models/store_model.dart';

class ProductRepository {
  CollectionReference productsReference = FirebaseFirestore.instance.collection('products');

  ProductRepository();

  Future<void> createProduct(ProductModel productModel, StoreModel storeModel) async {
    final createdDate = Timestamp.now();
// Create a Product document in Firestore
    try {
      // Write Product document to Firestore
      await productsReference.doc(createdDate.microsecondsSinceEpoch.toString()).set(productModel.toMap()).onError(
        (e, _) {
          if (kDebugMode) {
            print("Error writing document: $e");
          }
        },
      );
      if (kDebugMode) {
        print('Product created successfully!');
      }
    } on FirebaseException catch (e) {
      // Handle Firestore exceptions
      throw Exception('Error creating product: ${e.message}');
    } catch (e) {
      // Handle other exceptions
      throw Exception('An unknown error occurred: $e');
    }
  }

  Future<ProductModel?> getProductById(ProductModel productModel) async {
    try {
      DocumentSnapshot documentSnapshot = await productsReference.doc(productModel.id).get();
      if (documentSnapshot.exists) {
        return ProductModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
      } else {
        return null; // Handle the case where the document does not exist
      }
    } catch (e) {
      throw Exception('Error fetching product: $e');
    }
  }

  Future<List<ProductModel>> getSProductByUserId(StoreModel storeModel) async {
    try {
      QuerySnapshot querySnapshot = await productsReference
          .where(
            'store_id',
            isEqualTo: storeModel.id,
          )
          .get();

      List<ProductModel> products = querySnapshot.docs.map(
        (doc) {
          return ProductModel.fromMap(doc.data() as Map<String, dynamic>);
        },
      ).toList();

      return products;
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<void> updateProduct(ProductModel productModel) async {
    try {
      productsReference.doc(productModel.id).update(
            productModel.toMap(),
          );
    } catch (e) {
      throw Exception('Error updating product: $e');
    }
  }
}
