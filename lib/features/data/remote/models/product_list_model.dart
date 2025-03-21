import 'dart:convert';
import 'package:uv_pos/features/data/remote/models/product_model.dart';
class ProductListModel {
  final List<ProductModel> products;
  final int total;
  final int skip;
  final int limit;

  ProductListModel({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  ProductListModel copyWith({
    List<ProductModel>? products,
    int? total,
    int? skip,
    int? limit,
  }) =>
      ProductListModel(
        products: products ?? this.products,
        total: total ?? this.total,
        skip: skip ?? this.skip,
        limit: limit ?? this.limit,
      );

  factory ProductListModel.fromJson(String str) => ProductListModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductListModel.fromMap(Map<String, dynamic> json) => ProductListModel(
    products: List<ProductModel>.from(json["products"].map((x) => ProductModel.fromMap(x))),
    total: json["total"],
    skip: json["skip"],
    limit: json["limit"],
  );

  Map<String, dynamic> toMap() => {
    "products": List<dynamic>.from(products.map((x) => x.toMap())),
    "total": total,
    "skip": skip,
    "limit": limit,
  };
}
