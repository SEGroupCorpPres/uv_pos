// // Product_event.dart
// part of 'product_bloc.dart';

// abstract class ProductEvent extends Equatable {
//   const ProductEvent();

//   @override
//   List<Object?> get props => [];
// }

// class LoadProductsEvent extends ProductEvent {
//   final String storeID;

//   const LoadProductsEvent({required this.storeID});

//   @override
//   // TODO: implement props
//   List<Object?> get props => [storeID];
// }

// class CreateProductEvent extends ProductEvent {
//   final ProductModel product;
//   final String storeID;

//   final File? imageFile;

//   const CreateProductEvent( this.imageFile,{required this.product, required this.storeID});

//   @override
//   List<Object?> get props => [product, storeID, imageFile];
// }

// class UpdateProductEvent extends ProductEvent {
//   final ProductModel product;
//   final String storeID;

//   final File? imageFile;

//   const UpdateProductEvent(this.imageFile,{required this.product,  required this.storeID});

//   @override
//   List<Object?> get props => [product, storeID];
// }

// class DeleteProductEvent extends ProductEvent {
//   final String productId;
//   final String storeID;

//   const DeleteProductEvent({required this.productId, required this.storeID});

//   @override
//   List<Object?> get props => [productId, storeID];
// }

// class FetchProductByIdEvent extends ProductEvent {
//   final String id;

//   const FetchProductByIdEvent(this.id);

//   @override
//   List<Object?> get props => [id];
// }

// class FetchProductByBarcodeEvent extends ProductEvent {
//   final String barcode;

//   const FetchProductByBarcodeEvent(
//     this.barcode,
//   );

//   @override
//   List<Object?> get props => [
//         barcode,
//       ];
// }

// class FilterProductList extends ProductEvent {
//   final String storeID;
//   final String? filter;

//   const FilterProductList({this.filter, required this.storeID});

//   @override
//   // TODO: implement props
//   List<Object?> get props => [filter, storeID];
// }
