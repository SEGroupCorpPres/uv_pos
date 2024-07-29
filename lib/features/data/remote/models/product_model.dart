import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String id;
  final String name;
  final String? barcode;
  final String? description;
  final double price;
  final double cost;
  final int quantity;
  final String? image;
  final String storeId;

  const ProductModel({
    required this.id,
    required this.name,
     this.barcode,
     this.description,
    required this.price,
    required this.cost,
    required this.quantity,
    this.image,
    required this.storeId,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        name,
        barcode,
        description,
        price,
        cost,
        quantity,
        image,
        storeId,
      ];

  factory ProductModel.fromMap(Map<String, dynamic> data) {
    return ProductModel(
      id: data['id'],
      name: data['name'],
      barcode: data['bar_code'],
      description: data['description'],
      price: data['price'],
      cost: data['cost'],
      quantity: data['quantity'],
      image: data['image'],
      storeId: data['store_id'],
    );
  }

  // Convert Product instance to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'bar_code': barcode,
      'description': description,
      'price': price,
      'cost': cost,
      'quantity': quantity,
      'image': image,
      'store_id': storeId,
    };
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? barcode,
    String? description,
    double? price,
    double? cost,
    int? quantity,
    String? image,
    String? storeId,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      description: description ?? this.description,
      price: price ?? this.price,
      cost: cost ?? this.cost,
      quantity: quantity ?? this.quantity,
      image: image ?? this.image,
      storeId: storeId ?? this.storeId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          other.name == name &&
          other.barcode == barcode &&
          other.description == description &&
          other.price == price &&
          other.cost == cost &&
          other.quantity == quantity &&
          other.image == image &&
          other.storeId == storeId;

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ barcode.hashCode ^ description.hashCode ^ price.hashCode ^ cost.hashCode ^ quantity.hashCode ^ image.hashCode ^ storeId.hashCode;
  }
}
