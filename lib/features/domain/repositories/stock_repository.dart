import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uv_pos/features/data/remote/models/stock_model.dart';

class StockRepository {
  CollectionReference stocksReference = FirebaseFirestore.instance.collection('stocks');

  Future<void> updateStock(StockModel stock) async {
    try {
      stocksReference.doc(stock.id).update(stock.toMap());
    } catch (e) {
      throw Exception('Error updating Stock: $e');
    }
  }

  Future<String> createStock(StockModel stockModel) async {
// Create a Stock document in Firestore
    try {
      // Write Stock document to Firestore
      await stocksReference.doc(stockModel.id).set(stockModel.toMap()).onError(
        (e, _) {
          if (kDebugMode) {
            print("Error writing document: $e");
          }
        },
      );
      if (kDebugMode) {
        print('Stock created successfully!');
      }

      return stockModel.id;
    } on FirebaseException catch (e) {
      // Handle Firestore exceptions
      throw Exception('Error creating Stock: ${e.message}');
    } catch (e) {
      // Handle other exceptions
      throw Exception('An unknown error occurred: $e');
    }
  }

  Future<StockModel?> getStockById(StockModel stockModel) async {
    try {
      DocumentSnapshot documentSnapshot = await stocksReference.doc(stockModel.id).get();
      if (documentSnapshot.exists) {
        return StockModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
      } else {
        return null; // Handle the case where the document does not exist
      }
    } catch (e) {
      throw Exception('Error fetching Stock: $e');
    }
  }

  Future<List<StockModel>> getStocksByStoreId(String storeId) async {
    try {
      QuerySnapshot querySnapshot = await stocksReference
          .where(
            'store_id',
            isEqualTo: storeId,
          )
          .get();

      List<StockModel> stocks = querySnapshot.docs.map(
        (doc) {
          return StockModel.fromMap(doc.data() as Map<String, dynamic>);
        },
      ).toList();

      return stocks;
    } catch (e) {
      throw Exception('Error fetching Stocks: $e');
    }
  }

}


