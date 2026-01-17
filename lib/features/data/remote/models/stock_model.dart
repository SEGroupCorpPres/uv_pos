
import 'model.dart';

class StockModel extends Equatable {
  const StockModel({
    required this.id,
    required this.storeId,
    required this.productId,
    required this.name,
    required this.branchId,
    required this.qty,
    required this.minQty,
    required this.lastRestockDate,
    required this.lastOutDate,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        storeId,
        productId,
        name,
        branchId,
        qty,
        minQty,
        lastRestockDate,
        lastOutDate,
        createdAt,
        updatedAt,
      ];
  final String id;
  final String storeId;
  final String productId;
  final String name;
  final String branchId;
  final double qty;
  final double minQty;
  final DateTime lastRestockDate;
  final DateTime lastOutDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  // final double size;
  // final String measurementUnit;

  factory StockModel.fromMap(Map<String, dynamic> data, String dataID) {
    return StockModel(
      id: dataID,
      storeId: data['store_id'] as String,
      productId: data['product_id'] as String,
      name: data['name'] as String,
      branchId: data['branch_id'] as String,
      qty: data['qty'] as double,
      minQty: data['min_qty'] as double,
      lastRestockDate: data['last_restock_date'] as DateTime,
      lastOutDate: data['last_out_date'] as DateTime,
      createdAt: data['created_at'] as DateTime,
      updatedAt: data['updated_at'] as DateTime,
    );
  }


  // Convert Store instance to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'store_id': storeId,
      'product_id': productId,
      'name': name,
      'branch_id': branchId,
      'qty': qty,
      'min_qty': minQty,
      'last_restock_date': lastRestockDate,
      'last_out_date': lastOutDate,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  StockModel copyWith({
    String? id,
    String? storeId,
    String? productId,
    String? name,
    String? branchId,
    double? qty,
    double? minQty,
    DateTime? lastRestockDate,
    DateTime? lastOutDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StockModel(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      branchId: branchId ?? this.branchId,
      qty: qty ?? this.qty,
      minQty: minQty ?? this.minQty,
      lastRestockDate: lastRestockDate ?? this.lastRestockDate,
      lastOutDate: lastOutDate ?? this.lastOutDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
