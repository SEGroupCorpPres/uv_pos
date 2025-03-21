import 'package:equatable/equatable.dart';

class OrderProductModel extends Equatable {
  final String id;
  final String name;
  final double quantity;
  final String? thumbnail;
  final double price;
  final double totalProductPrice;
  final double discountPercentage;
  final String productMeasurementUnit;
  final double discountedTotalPrice;

  const OrderProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.productMeasurementUnit,
    required this.quantity,
    required this.totalProductPrice,
    required this.discountedTotalPrice,
    required this.thumbnail,
    required this.discountPercentage,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        name,
        price,
        productMeasurementUnit,
        discountPercentage,
        quantity,
        totalProductPrice,
        discountedTotalPrice,
        thumbnail,
      ];

  factory OrderProductModel.fromMap(Map<String, dynamic> data) {
    return OrderProductModel(
      id: data['id'],
      name: data['name'],
      price: double.tryParse(data['price'].toString())!,
      discountPercentage: double.tryParse(data['discount_percentage'].toString())!,
      quantity: double.tryParse(data['quantity'].toString())!,
      productMeasurementUnit: data['product_measurement_unit'],
      thumbnail: data['thumbnail'],
      totalProductPrice: double.tryParse(data['total_product_price'].toString())!,
      discountedTotalPrice: double.tryParse(data['discounted_total_price'].toString())!,
    );
  }

  // Convert Product instance to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'product_measurement_unit': productMeasurementUnit,
      "thumbnail": thumbnail,
      "quantity": quantity,
      "total_product_price": totalProductPrice,
      "discounted_total_price": discountedTotalPrice,
      "discount_percentage": discountPercentage,
    };
  }

  OrderProductModel copyWith({
    String? id,
    String? name,
    double? price,
    double? quantity,
    String? thumbnail,
    double? totalProductPrice,
    double? discountedTotalPrice,
    double? discountPercentage,
    String? productMeasurementUnit,
  }) {
    return OrderProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      thumbnail: thumbnail ?? this.thumbnail,
      totalProductPrice: totalProductPrice ?? this.totalProductPrice,
      discountedTotalPrice: discountedTotalPrice ?? this.discountedTotalPrice,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      productMeasurementUnit: productMeasurementUnit ?? this.productMeasurementUnit,
    );
  }
}
