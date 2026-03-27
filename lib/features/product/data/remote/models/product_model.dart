
// import '../../../../data/remote/models/model.dart';

// class ProductModel extends Equatable {
//   final String id;
//   final String name;
//   final String? description;
//   final String? categoryId;
//   final String? brand;
//   final String sku;
//   final int? weight;
//   final Dimensions? dimensions;
//   final Meta meta;
//   final List<String> imageUrls;
//   final List<String> supplierIds;
//   final String? thumbnail;
//   final double purchasePrice;
//   final double sellingPrice;
//   final String storeId;
//   final String? unit;
//   final String status;
//   final double? discount;

//   const ProductModel({
//     required this.id,
//     required this.name,
//     this.description,
//     required this.storeId,
//     required this.categoryId,
//     required this.brand,
//     required this.sku,
//     required this.weight,
//     required this.dimensions,
//     required this.meta,
//     required this.thumbnail,
//     required this.imageUrls,
//     required this.supplierIds,
//     required this.purchasePrice,
//     required this.sellingPrice,
//     required this.unit,
//     this.status = 'active',
//     this.discount,
//   });

//   @override
//   // TODO: implement props
//   List<Object?> get props => [
//         id,
//         name,
//         description,
//         storeId,
//         brand,
//         sku,
//         weight,
//         dimensions,
//         meta,
//         thumbnail,
//         imageUrls,
//         supplierIds,
//         purchasePrice,
//         sellingPrice,
//         unit,
//         categoryId,
//         status,
//         discount,
//       ];

//   factory ProductModel.fromMap(Map<String, dynamic> data) {
//     return ProductModel(
//       id: data['id'],
//       name: data['name'],
//       description: data['description'],
//       thumbnail: data['thumbnail'],
//       storeId: data['store_id'],
//       brand: data["brand"],
//       sku: data["sku"],
//       weight: data["weight"],
//       dimensions: Dimensions.fromMap(data["dimensions"]),
//       meta: Meta.fromMap(data["meta"]),
//       imageUrls: List<String>.from(data["image_urls"]),
//       supplierIds: List<String>.from(data["supplier_ids"]),
//       purchasePrice: data["purchase_price"],
//       sellingPrice: data["selling_price"],
//       unit: data["unit"],
//       categoryId: data["category_id"],
//       status: data["status"],
//       discount: data["discount"],
//     );
//   }


//   // Convert Product instance to map
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'name': name,
//       'description': description,
//       "brand": brand,
//       "sku": sku,
//       "weight": weight,
//       "dimensions": dimensions?.toMap(),
//       "thumbnail": thumbnail,
//       "meta": meta.toMap(),
//       "image_urls": imageUrls,
//       "supplier_ids": supplierIds,
//       "purchase_price": purchasePrice,
//       "selling_price": sellingPrice,
//       "unit": unit,
//       "category_id": categoryId,
//       "status": status,
//       "discount": discount,
//     };
//   }

//   ProductModel copyWith({
//     String? id,
//     String? name,
//     String? description,
//     String? categoryId,
//     String? brand,
//     String? sku,
//     int? weight,
//     Dimensions? dimensions,
//     Meta? meta,
//     List<String>? imageUrls,
//     List<String>? supplierIds,
//     String? thumbnail,
//     double? purchasePrice,
//     double? sellingPrice,
//     String? storeId,
//     String? unit,
//     String? status,
//     double? discount,
//   }) {
//     return ProductModel(
//       id: this.id,
//       name: name ?? this.name,
//       description: description ?? this.description,
//       storeId: storeId ?? this.storeId,
//       brand: brand ?? this.brand,
//       sku: sku ?? this.sku,
//       weight: weight ?? this.weight,
//       dimensions: dimensions ?? this.dimensions,
//       meta: meta ?? this.meta,
//       thumbnail: thumbnail ?? this.thumbnail,
//       imageUrls: imageUrls ?? this.imageUrls,
//       supplierIds: supplierIds ?? this.supplierIds,
//       purchasePrice: purchasePrice ?? this.purchasePrice,
//       sellingPrice: sellingPrice ?? this.sellingPrice,
//       unit: unit ?? this.unit,
//       categoryId: categoryId ?? this.categoryId,
//       status: status ?? this.status,
//       discount: discount ?? this.discount,
//     );
//   }
// }
