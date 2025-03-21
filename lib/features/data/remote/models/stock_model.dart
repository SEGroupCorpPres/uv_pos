import 'package:equatable/equatable.dart';

import 'order_product_model.dart';

class StockModel extends Equatable {
  const StockModel({
    required this.id,
    required this.storeId,
    required this.product,
    // required this.size,
    // required this.measurementUnit,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        storeId,
        // size,
        // measurementUnit,
        product,
      ];
  final String id;
  final String storeId;
  final OrderProductModel product;
  // final double size;
  // final String measurementUnit;

  factory StockModel.fromMap(Map<String, dynamic> data) {
    return StockModel(
      id: data['id'] as String,
      storeId: data['store_id'] as String,
      product: OrderProductModel.fromMap(data['product']),
      // size: data['size'] as double,
      // measurementUnit: data['measurement_unit'] as String,
    );
  }

  // Convert Store instance to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'store_id': storeId,
      'product': product,
      // 'size': size,
      // 'measurement_unit': measurementUnit,
    };
  }

  StockModel copyWith({
    String? id,
    String? storeId,
    OrderProductModel? product,
    // double? size,
    // String? measurementUnit,
  }) {
    return StockModel(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      product: product ?? this.product,
      // size: size ?? this.size,
      // measurementUnit: measurementUnit ?? this.measurementUnit,
    );
  }
}
