import 'package:cloud_firestore/cloud_firestore.dart';

import 'repository.dart';

class OrderRepository {
  CollectionReference ordersReference = FirebaseFirestore.instance.collection('orders');
  Query<Map<String, dynamic>> dailyOrdersReference =
      FirebaseFirestore.instance.collectionGroup('daily_orders');

  OrderRepository();

  Future<String> createOrder(OrderModel order) async {
    final orderDateFormatted = _formatDate(order.orderDate);
// Create a Order document in Firestore
    try {
      // Write Order document to Firestore
      await ordersReference
          .doc(orderDateFormatted)
          .collection('daily_orders')
          .doc(order.id)
          .set(order.toMap());
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
      DocumentSnapshot documentSnapshot = await ordersReference
          .doc(orderDateFormatted)
          .collection('daily_orders')
          .doc(order.id)
          .get();
      log('documentSnapshot isExist:   ------->  ${documentSnapshot.exists.toString()}\n\n\n\n\n');

      if (documentSnapshot.exists) {
        return OrderModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
      } else {
        return null; // Handle the case where the document does not exist
      }
    } catch (e) {
      throw Exception('Error fetching Order: $e');
    }
  }

  Future<List<OrderModel>> getOrdersForDateByStoreId(String storeID, DateTime? date) async {
    // final orderDateFormatted = _formatDate(DateTime(2024, 7, 18));

    try {
      QuerySnapshot querySnapshot = await dailyOrdersReference
          .where(
            'store_id',
            isEqualTo: storeID,
          )
          .get();
      print('daily_order date is ---------> ${querySnapshot}');

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
    final querySnapshot = await ordersReference.doc(date).collection('daily_orders').get();

    return querySnapshot.docs
        .map((doc) => OrderModel.fromMap(doc as Map<String, dynamic>))
        .toList();
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
      await ordersReference
          .doc(orderDateFormatted)
          .collection('daily_orders')
          .doc(orderId)
          .delete();
    } catch (e) {
      rethrow;
    }
  }

  // filter orders by date
  Future<List<OrderModel>> filterOrdersByDate(
      {required DateTime startDate, required DateTime endDate, required String storeID}) async {
    // final startDateFormatted = _formatDate(startDate);
    // final endDateFormatted = _formatDate(endDate);
    try {
      QuerySnapshot querySnapshot = await ordersReference
          .where('storeID', isEqualTo: storeID)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy('date', descending: false)
          .get();
      final orders = querySnapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList();

      return orders;
    } catch (e) {
      // Error handling (log to console, rethrow, or custom exception)
      print('Error fetching filtered orders: $e');
      return [];
    }
  }

  // filter order by customer name
  Future<List<OrderModel>> filterOrdersByCustomerName({required String customerName,required String storeID}) async {
    try {
      QuerySnapshot querySnapshot =
          await ordersReference.where('customer_name', isEqualTo: customerName).get();
      return querySnapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList();
    } catch (e) {
      return [];
    }
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
