import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uv_pos/features/data/remote/models/order_model.dart';
import 'package:uv_pos/features/data/remote/models/store_model.dart';

class OrderRepository {
  CollectionReference ordersReference = FirebaseFirestore.instance.collection('orders');

  OrderRepository();

  Future<String> createOrder(OrderModel orderModel) async {
// Create a Order document in Firestore
    try {
      // Write Order document to Firestore
      await ordersReference.doc(orderModel.id).set(orderModel.toMap()).onError(
        (e, _) {
          if (kDebugMode) {
            print("Error writing document: $e");
          }
        },
      );
      if (kDebugMode) {
        print('Order created successfully!');
      }
      return orderModel.id;
    } on FirebaseException catch (e) {
      // Handle Firestore exceptions
      throw Exception('Error creating Order: ${e.message}');
    } catch (e) {
      // Handle other exceptions
      throw Exception('An unknown error occurred: $e');
    }
  }

  Future<OrderModel?> getOrderById(OrderModel order) async {
    try {
      DocumentSnapshot documentSnapshot = await ordersReference.doc(order.id).get();
      if (documentSnapshot.exists) {
        return OrderModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
      } else {
        return null; // Handle the case where the document does not exist
      }
    } catch (e) {
      throw Exception('Error fetching Order: $e');
    }
  }

  Future<List<OrderModel>> getOrdersByStoreId(StoreModel store) async {
    try {
      QuerySnapshot querySnapshot = await ordersReference
          .where(
            'store_id',
            isEqualTo: store.id,
          )
          .get();

      List<OrderModel> orders = querySnapshot.docs.map(
        (doc) {
          return OrderModel.fromMap(doc.data() as Map<String, dynamic>);
        },
      ).toList();

      return orders;
    } catch (e) {
      throw Exception('Error fetching Orders: $e');
    }
  }

  Future<void> updateOrder(OrderModel order) async {
    try {
      await ordersReference.doc(order.id).update(
            order.toMap(),
          );
    } catch (e) {
      throw Exception('Error updating Order: $e');
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      await ordersReference.doc(orderId).delete();
    } catch (e) {
      rethrow;
    }
  }
}
