import 'package:equatable/equatable.dart';

import 'product_model.dart';

class OrderModel extends Equatable implements Comparable<OrderModel> {
  final String id;
  final String customerName;
  final String employeeName;
  final List<ProductModel> productList;
  final double totalAmount;
  final DateTime orderDate;
  final String? barcode;
  final String? qrcode;
  final String storeId;

  const OrderModel({
    required this.id,
    required this.customerName,
    required this.employeeName,
    required this.productList,
    required this.totalAmount,
    required this.orderDate,
    this.barcode,
    this.qrcode,
    required this.storeId,
  });

  @override
  List<Object?> get props => [id, customerName, employeeName, productList, totalAmount, orderDate, storeId, barcode, qrcode];

  // Factory constructor to create an Order instance from a map (if needed)
  factory OrderModel.fromMap(Map<String, dynamic> data) {
    return OrderModel(
      id: data['id'],
      customerName: data['customer_anme'],
      employeeName: data['employee_name'],
      productList: (data['product_list'] as List<dynamic>).map((item) => ProductModel.fromMap(item)).toList(),
      totalAmount: data['total_amount'],
      orderDate: DateTime.parse(data['order_date']),
      storeId: data['store_id'],
      barcode: data['barcode'],
      qrcode: data['qrcode'],
    );
  }

  // Convert Order instance to map (if needed)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer_anme': customerName,
      'employee_name': employeeName,
      'product_list': productList.map((product) => product.toMap()).toList(),
      'total_amount': totalAmount,
      'order_date': orderDate.toIso8601String(),
      'store_id': storeId,
      'barcode': barcode,
      'qrcode': qrcode,
    };
  }

  OrderModel copyWith({
    String? id,
    String? customerName,
    String? employeeName,
    List<ProductModel>? productList,
    double? totalAmount,
    DateTime? orderDate,
    String? storeId,
    String? barcode,
    String? qrcode,
  }) {
    return OrderModel(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      employeeName: employeeName ?? this.employeeName,
      productList: productList ?? this.productList,
      totalAmount: totalAmount ?? this.totalAmount,
      orderDate: orderDate ?? this.orderDate,
      storeId: storeId ?? this.storeId,
      barcode: barcode ?? this.barcode,
      qrcode: qrcode ?? this.qrcode,
    );
  }

  @override
  int compareTo(other) {
    // TODO: implement compareTo
    return orderDate.compareTo(other.orderDate);
  }
}
