import 'package:equatable/equatable.dart';

import 'product_model.dart';

class OrderModel extends Equatable {
  final String id;
  final String customerId;
  final List<ProductModel> productList;
  final double totalAmount;
  final DateTime orderDate;

  const OrderModel({
    required this.id,
    required this.customerId,
    required this.productList,
    required this.totalAmount,
    required this.orderDate,
  });

  @override
  List<Object?> get props => [id, customerId, productList, totalAmount, orderDate];

  // Factory constructor to create an Order instance from a map (if needed)
  factory OrderModel.fromMap(Map<String, dynamic> data) {
    return OrderModel(
      id: data['id'],
      customerId: data['customerId'],
      productList: (data['productList'] as List<dynamic>).map((item) => ProductModel.fromMap(item)).toList(),
      totalAmount: data['totalAmount'],
      orderDate: DateTime.parse(data['orderDate']),
    );
  }

  // Convert Order instance to map (if needed)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerId': customerId,
      'productList': productList.map((product) => product.toMap()).toList(),
      'totalAmount': totalAmount,
      'orderDate': orderDate.toIso8601String(),
    };
  }
}
