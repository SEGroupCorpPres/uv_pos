import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/repositories/stock_repository.dart';
import '../remote/models/stock_model.dart';

class StockRepositoryImpl implements StockRepository {
  final FirebaseFirestore firestore;

  StockRepositoryImpl({required this.firestore});

  @override
  Stream<List<StockModel>> fetchStocks() {
    try {
      return firestore.collection('stocks').snapshots().map(
        (snapshot) {
          return snapshot.docs.map((doc) => StockModel.fromMap(doc.data(), doc.id)).toList();
        },
      );
    } on FirebaseException catch (e) {
      print('Error fetching stocks: $e');
      return Stream.value([]);
    } catch (e) {
      print('Error fetching stocks: $e');
      return Stream.value([]);
    }
  }

  @override
  Future<void> createStock(StockModel stock) async {
    await firestore.collection('stocks').add(stock.toMap());
  }

  @override
  Future<void> updateStock(StockModel stock) async {
    await firestore.collection('stocks').doc(stock.id).update(stock.toMap());
  }

  @override
  Future<void> deleteStock(String id) async {
    await firestore.collection('stocks').doc(id).delete();
  }

  @override
  Future<StockModel?> getStockById(String id) {
    return firestore.collection('stocks').doc(id).get().then((doc) {
      if (doc.exists) {
        return StockModel.fromMap(doc.data()!, doc.id);
      } else {
        return null;
      }
    }).catchError((error) {
      print('Error fetching stock: $error');
      return null;
    });
  }
}
