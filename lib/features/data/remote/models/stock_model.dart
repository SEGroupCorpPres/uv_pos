import 'package:equatable/equatable.dart';

class StockModel extends Equatable {
  const StockModel({
    required this.id,
    required this.storeId,
    required this.qty,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [id, storeId, qty];
  final String id;
  final String storeId;
  final int qty;

  factory StockModel.fromMap(Map<String, dynamic> data) {
    return StockModel(
      id: data['id'] as String,
      storeId: data['store_id'] as String,
      qty: data['qty'] as int,
    );
  }

  // Convert Store instance to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'store_id': storeId,
      'qty': qty,
    };
  }

  StockModel copyWith({
    String? id,
    String? storeId,
    int? qty,
  }) {
    return StockModel(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      qty: qty ?? this.qty,
    );
  }
}
