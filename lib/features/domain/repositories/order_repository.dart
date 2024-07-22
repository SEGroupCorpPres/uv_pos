import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uv_pos/features/data/remote/models/order_model.dart';
import 'package:uv_pos/features/data/remote/models/store_model.dart';

class OrderRepository {
  CollectionReference ordersReference = FirebaseFirestore.instance.collection('orders');

  OrderRepository();

  Future<String> createOrder(OrderModel order) async {
    final orderDateFormatted = _formatDate(order.orderDate);
// Create a Order document in Firestore
    try {
      // Write Order document to Firestore
      await ordersReference.doc(orderDateFormatted).collection('daily_orders').add(order.toMap());
      if (kDebugMode) {
        print('Order created successfully!');
      }
      return order.id;
    } on FirebaseException catch (e) {
      // Handle Firestore exceptions
      throw Exception('Error creating Order: ${e.message}');
    } catch (e) {
      // Handle other exceptions
      throw Exception('An unknown error occurred: $e');
    }
  }

  Future<OrderModel?> getOrderById(OrderModel order) async {
    final orderDateFormatted = _formatDate(order.orderDate);
    try {
      DocumentSnapshot documentSnapshot = await ordersReference.doc(orderDateFormatted).collection('daily_orders').doc(order.id).get();
      if (documentSnapshot.exists) {
        return OrderModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
      } else {
        return null; // Handle the case where the document does not exist
      }
    } catch (e) {
      throw Exception('Error fetching Order: $e');
    }
  }

  Future<List<OrderModel>> getOrdersForDateByStoreId(StoreModel store, DateTime date) async {
    final orderDateFormatted = _formatDate(DateTime(2024, 7, 18));
    print('formatted order date is ---------> $orderDateFormatted');

    try {
      QuerySnapshot querySnapshot = await ordersReference
          .doc(orderDateFormatted)
          .collection('daily_orders')
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

  Future<List<OrderModel>> getOrdersForDate(String date) async {
    final querySnapshot = await ordersReference.doc(date).collection('dailyOrders').get();

    return querySnapshot.docs.map((doc) => OrderModel.fromMap(doc as Map<String, dynamic>)).toList();
  }

  Future<void> updateOrder(OrderModel order) async {
    final orderDateFormatted = _formatDate(order.orderDate);

    try {
      await ordersReference.doc(orderDateFormatted).collection('daily_orders').doc(order.id).update(
            order.toMap(),
          );
    } catch (e) {
      throw Exception('Error updating Order: $e');
    }
  }

  Future<void> deleteOrder(String orderId, DateTime orderDate) async {
    final orderDateFormatted = _formatDate(orderDate);

    try {
      await ordersReference.doc(orderDateFormatted).collection('daily_orders').doc(orderId).delete();
    } catch (e) {
      rethrow;
    }
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
