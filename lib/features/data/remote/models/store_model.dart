import 'package:equatable/equatable.dart';

import 'order_model.dart';
import 'product_model.dart';

class Store extends Equatable {
  final String id;
  final String name;
  final String description;
  final String phone;
  final String imageUrl;
  final List<ProductModel> productList;
  final List<OrderModel> orderList;

  const Store({
    required this.id,
    required this.name,
    required this.description,
    required this.phone,
    required this.imageUrl,
    required this.productList,
    required this.orderList,
  });

  @override
  List<Object?> get props => [id, name, description, phone, imageUrl, productList, orderList];

  // Factory constructor to create a Store instance from a map
  factory Store.fromMap(Map<String, dynamic> data) {
    return Store(
      id: data['id'],
      name: data['name'],
      description: data['description'],
      phone: data['phone'],
      imageUrl: data['imageUrl'],
      productList: (data['productList'] as List<dynamic>).map((item) => ProductModel.fromMap(item)).toList(),
      orderList: (data['orderList'] as List<dynamic>).map((item) => OrderModel.fromMap(item)).toList(),
    );
  }

  // Convert Store instance to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'phone': phone,
      'imageUrl': imageUrl,
      'productList': productList.map((ProductModel? product) => product?.toMap()).toList(),
      'orderList': orderList.map((order) => order.toMap()).toList(),
    };
  }
}
