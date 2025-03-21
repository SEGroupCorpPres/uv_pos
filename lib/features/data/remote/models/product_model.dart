import 'package:equatable/equatable.dart';
import 'package:uv_pos/features/data/remote/models/dimensions_model.dart';
import 'package:uv_pos/features/data/remote/models/meta_model.dart';
import 'package:uv_pos/features/data/remote/models/review_model.dart';

class ProductModel extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? category;
  final double stock;
  final List<String>? tags;
  final String? brand;
  final String sku;
  final int? weight;
  final Dimensions dimensions;
  final String? warrantyInformation;
  final String shippingInformation;
  final String availabilityStatus;
  final List<Review>? reviews;
  final String? returnPolicy;
  final int minimumOrderQuantity;
  final Meta meta;
  final List<String> images;
  final String? thumbnail;
  final String vendor;
  final double price;
  final double cost;
  final double discountPercentage;
  final double notifySize;
  final String storeId;
  final String? startDiscountDate;
  final String? endDiscountDate;
  final String? productMeasurementUnit;
  final String createdAt;
  final String updatedAt;

  const ProductModel({
    required this.id,
    required this.name,
    this.description,
    required this.vendor,
    required this.price,
    required this.notifySize,
    required this.cost,
    this.productMeasurementUnit,
    this.endDiscountDate,
    this.startDiscountDate,
    required this.storeId,
    required this.createdAt,
    required this.updatedAt,
    required this.discountPercentage,
    required this.stock,
    required this.tags,
    required this.brand,
    required this.sku,
    required this.weight,
    required this.dimensions,
    required this.warrantyInformation,
    required this.shippingInformation,
    required this.availabilityStatus,
    required this.reviews,
    required this.returnPolicy,
    required this.minimumOrderQuantity,
    required this.meta,
    required this.images,
    required this.category,
    required this.thumbnail,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        name,
        description,
        vendor,
        price,
        cost,
        notifySize,
        startDiscountDate,
        endDiscountDate,
        productMeasurementUnit,
        storeId,
        createdAt,
        updatedAt,
        discountPercentage,
        stock,
        tags,
        brand,
        sku,
        weight,
        dimensions,
        warrantyInformation,
        shippingInformation,
        availabilityStatus,
        reviews,
        returnPolicy,
        minimumOrderQuantity,
        meta,
        images,
        category,
        thumbnail,
      ];

  factory ProductModel.fromMap(Map<String, dynamic> data) {
    return ProductModel(
      id: data['id'],
      name: data['name'],
      category: data["category"],
      description: data['description'],
      vendor: data['vendor'],
      price: double.tryParse(data['price'].toString())!,
      cost: double.tryParse(data['cost'].toString())!,
      discountPercentage: double.tryParse(data['discount_percentage'].toString())!,
      startDiscountDate: data['start_discount_date'],
      endDiscountDate: data['end_discount_date'],
      stock: double.tryParse(data['stock'].toString())!,
      notifySize: double.tryParse(data['notify_size'].toString())!,
      productMeasurementUnit: data['product_measurement_unit'],
      thumbnail: data['thumbnail'],
      storeId: data['store_id'],
      createdAt: data['created_at'],
      updatedAt: data['updated_at'],
      tags: List<String>.from(data["tags"].map((x) => x)),
      brand: data["brand"],
      sku: data["sku"],
      weight: data["weight"],
      dimensions: Dimensions.fromMap(data["dimensions"]),
      warrantyInformation: data["warranty_information"],
      shippingInformation: data["shipping_information"],
      availabilityStatus: data["availability_status"],
      reviews: List<Review>.from(data["reviews"].map((x) => Review.fromMap(x))),
      returnPolicy: data["return_policy"],
      minimumOrderQuantity: data["minimum_order_quantity"],
      meta: Meta.fromMap(data["meta"]),
      images: List<String>.from(data["images"].map((x) => x)),
    );
  }

  // Convert Product instance to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'vendor': vendor,
      'price': price,
      'cost': cost,
      'start_discount_date': startDiscountDate,
      'end_discount_date': endDiscountDate,
      'notify_size': notifySize,
      'product_measurement_unit': productMeasurementUnit,
      'store_id': storeId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      "stock": stock,
      "tags": List<dynamic>.from(tags?.map(( String?x) => x) ?? []),
      "brand": brand,
      "sku": sku,
      "weight": weight,
      "dimensions": dimensions.toMap(),
      "warranty_information": warrantyInformation,
      "shipping_information": shippingInformation,
      "availability_status": availabilityStatus,
      "reviews": List<dynamic>.from(reviews?.map((x) => x.toMap()) ?? []),
      "return_policy": returnPolicy,
      "minimum_order_quantity": minimumOrderQuantity,
      "meta": meta.toMap(),
      "images": List<dynamic>.from(images.map((x) => x)),
      "thumbnail": thumbnail,
      "category": category,
      "discount_percentage": discountPercentage,
    };
  }

  ProductModel copyWith({
    String? category,
    double? price,
    double? discountPercentage,
    double? rating,
    double? stock,
    List<String>? tags,
    String? brand,
    String? sku,
    int? weight,
    Dimensions? dimensions,
    String? warrantyInformation,
    String? shippingInformation,
    String? availabilityStatus,
    List<Review>? reviews,
    String? returnPolicy,
    int? minimumOrderQuantity,
    Meta? meta,
    List<String>? images,
    String? thumbnail,
    String? id,
    String? name,
    String? barcode,
    String? description,
    String? vendor,
    double? cost,
    double? size,
    double? notifySize,
    String? productMeasurementUnit,
    String? image,
    String? storeId,
    double? discount,
    String? startDiscountDate,
    String? endDiscountDate,
    String? createdAt,
    String? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      vendor: vendor ?? this.vendor,
      price: price ?? this.price,
      cost: cost ?? this.cost,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      category: category ?? this.category,
      startDiscountDate: startDiscountDate ?? this.startDiscountDate,
      endDiscountDate: endDiscountDate ?? this.endDiscountDate,
      notifySize: notifySize ?? this.notifySize,
      productMeasurementUnit: productMeasurementUnit ?? this.productMeasurementUnit,
      storeId: storeId ?? this.storeId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      stock: stock ?? this.stock,
      tags: tags ?? this.tags,
      brand: brand ?? this.brand,
      sku: sku ?? this.sku,
      weight: weight ?? this.weight,
      dimensions: dimensions ?? this.dimensions,
      warrantyInformation: warrantyInformation ?? this.warrantyInformation,
      shippingInformation: shippingInformation ?? this.shippingInformation,
      availabilityStatus: availabilityStatus ?? this.availabilityStatus,
      reviews: reviews ?? this.reviews,
      returnPolicy: returnPolicy ?? this.returnPolicy,
      minimumOrderQuantity: minimumOrderQuantity ?? this.minimumOrderQuantity,
      meta: meta ?? this.meta,
      images: images ?? this.images,
      thumbnail: thumbnail ?? this.thumbnail,
    );
  }
}
