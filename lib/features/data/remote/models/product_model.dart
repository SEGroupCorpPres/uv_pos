import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String id;
  final String name;
  final String barCode;
  final String description;
  final double price;
  final double cost;
  final String inStock;
  final int notifyQuantity;
  final String image;

  const ProductModel({
    required this.id,
    required this.name,
    required this.barCode,
    required this.description,
    required this.price,
    required this.cost,
    required this.inStock,
    required this.notifyQuantity,
    required this.image,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        name,
        barCode,
        description,
        price,
        cost,
        inStock,
        notifyQuantity,
        image,
      ];

  factory ProductModel.fromMap(Map<String, dynamic> data) {
    return ProductModel(
      id: data['id'],
      name: data['name'],
      barCode: data['bar_code'],
      description: data['description'],
      price: data['price'],
      cost: data['cost'],
      inStock: data['in_stock'],
      notifyQuantity: data['notify_quantity'],
      image: data['image'],
    );
  }

  // Convert Product instance to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'bar_code': barCode,
      'description': description,
      'price': price,
      'cost': cost,
      'in_stock': inStock,
      'notify_quantity': notifyQuantity,
      'image': image,
    };
  }
}
