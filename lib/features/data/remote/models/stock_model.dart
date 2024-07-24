import 'package:equatable/equatable.dart';
import 'package:uv_pos/features/data/remote/models/product_model.dart';

class StockModel extends Equatable {
  const StockModel({
    required this.id,
    required this.storeId,
    required this.product,
    required this.qty,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [id, storeId, qty];
  final String id;
  final String storeId;
  final ProductModel product;
  final int qty;

  factory StockModel.fromMap(Map<String, dynamic> data) {
    return StockModel(
      id: data['id'] as String,
      storeId: data['store_id'] as String,
      product: ProductModel.fromMap(data['product']),
      qty: data['qty'] as int,
    );
  }

  // Convert Store instance to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'store_id': storeId,
      'product': product.toMap(),
      'qty': qty,
    };
  }

  StockModel copyWith({
    String? id,
    String? storeId,
    ProductModel? product,
    int? qty,
  }) {
    return StockModel(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      product: product ?? this.product,
      qty: qty ?? this.qty,
    );
  }
}
