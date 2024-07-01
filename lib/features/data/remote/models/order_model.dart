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
      customerId: data['customer_id'],
      productList: (data['product_list'] as List<dynamic>).map((item) => ProductModel.fromMap(item)).toList(),
      totalAmount: data['total_amount'],
      orderDate: DateTime.parse(data['order_date']),
    );
  }

  // Convert Order instance to map (if needed)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer_id': customerId,
      'product_list': productList.map((product) => product.toMap()).toList(),
      'total_amount': totalAmount,
      'order_date': orderDate.toIso8601String(),
    };
  }

  OrderModel copyWith({
    String? id,
    String? customerId,
    List<ProductModel>? productList,
    double? totalAmount,
    DateTime? orderDate,
  }) {
    return OrderModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      productList: productList ?? this.productList,
      totalAmount: totalAmount ?? this.totalAmount,
      orderDate: orderDate ?? this.orderDate,
    );
  }
}
