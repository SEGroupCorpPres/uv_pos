// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'repository.dart';


// class ProductRepository {
//   CollectionReference productsReference = FirebaseFirestore.instance.collection('products');

//   ProductRepository();

//   Future<String> createProduct(ProductModel productModel) async {
// // Create a Product document in Firestore
//     try {
//       // Write Product document to Firestore
//       await productsReference.doc(productModel.id).set(productModel.toMap()).onError(
//         (e, _) {
//           if (kDebugMode) {
//             print("Error writing document: $e");
//           }
//         },
//       );
//       if (kDebugMode) {
//         print('Product created successfully!');
//       }
//       return productModel.id;
//     } on FirebaseException catch (e) {
//       // Handle Firestore exceptions
//       throw Exception('Error creating product: ${e.message}');
//     } catch (e) {
//       // Handle other exceptions
//       throw Exception('An unknown error occurred: $e');
//     }
//   }

//   Future<ProductModel?> getProductById(String id) async {
//     try {
//       DocumentSnapshot documentSnapshot = await productsReference.doc(id).get();
//       if (documentSnapshot.exists) {
//         return ProductModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
//       } else {
//         return null; // Handle the case where the document does not exist
//       }
//     } catch (e) {
//       throw Exception('Error fetching product: $e');
//     }
//   }

//   Future<List<ProductModel>> getProducts(String storeId) async {
//     try {
//       QuerySnapshot querySnapshot = await productsReference
//           .where(
//             'store_id',
//             isEqualTo: storeId,
//           )
//           .get();

//       List<ProductModel> products = querySnapshot.docs.map(
//         (doc) {
//           return ProductModel.fromMap(doc.data() as Map<String, dynamic>);
//         },
//       ).toList();

//       return products;
//     } catch (e) {
//       throw Exception('Error fetching products: $e');
//     }
//   }

//   Future<List<ProductModel>> getProductsWithFilter(String storyId, String? filter) async {
//     List<QueryDocumentSnapshot> documents = [];
//     try {
//       QuerySnapshot querySnapshot = await productsReference
//           .where(
//             'store_id',
//             isEqualTo: storyId,
//           )
//           .get();
//       // Filtrlash: name maydonida 'value2' substranti bor hujjatlar
//       if (filter != null || filter!.isNotEmpty) {
//         documents = querySnapshot.docs.where((doc) {
//           String name = doc['name'];
//           return name.contains(filter ?? '');
//         }).toList();
//       } else {
//         documents = querySnapshot.docs;
//       }

//       List<ProductModel> products = documents.map(
//         (doc) {
//           return ProductModel.fromMap(doc.data() as Map<String, dynamic>);
//         },
//       ).toList();

//       return products;
//     } catch (e) {
//       throw Exception('Error fetching products: $e');
//     }
//   }

//   Future<ProductModel?> getProductByBarcode(String barcode) async {
//     try {
//       QuerySnapshot querySnapshot = await productsReference
//           .where(
//             'meta.barcode',
//             isEqualTo: barcode,
//           )
//           .limit(1)
//           .get();

//       if (querySnapshot.docs.isNotEmpty) {
//         return ProductModel.fromMap(querySnapshot.docs.first.data() as Map<String, dynamic>);
//       } else {
//         return null;
//       }
//     } catch (e) {
//       throw Exception('Error fetching products: $e');
//     }
//   }

//   Future<void> updateProduct(ProductModel product) async {
//     try {
//       productsReference.doc(product.id).update(
//             product.toMap(),
//           );
//     } catch (e) {
//       throw Exception('Error updating product: $e');
//     }
//   }

//   Future<void> deleteProduct(String productId) async {
//     try {
//       await productsReference.doc(productId).delete();
//     } catch (e) {
//       rethrow;
//     }
//   }
// }
