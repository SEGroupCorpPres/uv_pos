import 'package:equatable/equatable.dart';
import 'package:uv_pos/features/data/remote/models/product_model.dart';

class StockModel extends Equatable {
  const StockModel({
    required this.id,
    required this.storeId,
    required this.product,
    required this.size,
    required this.mesurementType,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [id, storeId, size];
  final String id;
  final String storeId;
  final ProductModel product;
  final double size;
  final String mesurementType;

  factory StockModel.fromMap(Map<String, dynamic> data) {
    return StockModel(
      id: data['id'] as String,
      storeId: data['store_id'] as String,
      product: ProductModel.fromMap(data['product']),
      size: data['size'] as double,
      mesurementType: data['mesurement_type'] as String,
    );
  }

  // Convert Store instance to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'store_id': storeId,
      'product': product.toMap(),
      'size': size,
      'mesurement_type': mesurementType,
    };
  }

  StockModel copyWith({
    String? id,
    String? storeId,
    ProductModel? product,
    double? size,
    String? mesurementType,
  }) {
    return StockModel(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      product: product ?? this.product,
      size: size ?? this.size,
      mesurementType: mesurementType ?? this.mesurementType,
    );
  }
}
