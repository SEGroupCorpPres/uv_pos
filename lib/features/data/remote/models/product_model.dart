import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String id;
  final String name;
  final String? barcode;
  final String? description;
  final String vendor;
  final double price;
  final double cost;
  final double discount;
  final double size;
  final double notifySize;
  final String? image;
  final String storeId;
  final String? productMeasurementUnit;

  const ProductModel({
    required this.id,
    required this.name,
    this.barcode,
    this.description,
    required this.vendor,
    required this.price,
    required this.cost,
    required this.size,
    required this.discount,
    required this.notifySize,
    this.productMeasurementUnit,
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
        vendor,
        price,
        cost,
        discount,
        size,
        notifySize,
        productMeasurementUnit,
        image,
        storeId,
      ];

  factory ProductModel.fromMap(Map<String, dynamic> data) {
    return ProductModel(
      id: data['id'],
      name: data['name'],
      barcode: data['bar_code'],
      description: data['description'],
      vendor: data['vendor'],
      price: double.tryParse(data['price'].toString())!,
      cost: double.tryParse(data['cost'].toString())!,
      discount: double.tryParse(data['discount'].toString())!,
      size: double.tryParse(data['size'].toString())!,
      notifySize: double.tryParse(data['notify_size'].toString())!,
      productMeasurementUnit: data['product_measurement_unit'],
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
      'vendor': vendor,
      'price': price,
      'cost': cost,
      'discount': discount,
      'size': size,
      'notify_size': notifySize,
      'product_measurement_unit': productMeasurementUnit,
      'image': image,
      'store_id': storeId,
    };
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? barcode,
    String? description,
    String? vendor,
    double? price,
    double? cost,
    double? size,
    double? notifySize,
    String? productMeasurementUnit,
    String? image,
    String? storeId,
    double? discount,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      description: description ?? this.description,
      vendor: vendor ?? this.vendor,
      price: price ?? this.price,
      cost: cost ?? this.cost,
      discount: discount ?? this.discount,
      size: size ?? this.size,
      notifySize: notifySize ?? this.notifySize,
      productMeasurementUnit: productMeasurementUnit ?? this.productMeasurementUnit,
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
          other.vendor == vendor &&
          other.price == price &&
          other.cost == cost &&
          other.discount == discount &&
          other.size == size &&
          other.notifySize == notifySize &&
          other.productMeasurementUnit == productMeasurementUnit &&
          other.image == image &&
          other.storeId == storeId;

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        barcode.hashCode ^
        description.hashCode ^
        vendor.hashCode ^
        price.hashCode ^
        cost.hashCode ^
        discount.hashCode ^
        size.hashCode ^
        notifySize.hashCode ^
        productMeasurementUnit.hashCode ^
        image.hashCode ^
        storeId.hashCode;
  }
}
