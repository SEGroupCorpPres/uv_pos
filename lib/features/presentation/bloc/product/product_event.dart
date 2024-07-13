// Product_event.dart
part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductsEvent extends ProductEvent {
  final StoreModel? store;

  const LoadProductsEvent([this.store]);

  @override
  // TODO: implement props
  List<Object?> get props => [store];
}

class CreateProductEvent extends ProductEvent {
  final ProductModel product;
  final StoreModel store;

  final File? imageFile;

  const CreateProductEvent(this.product, this.imageFile, this.store);

  @override
  List<Object?> get props => [product, store, imageFile];
}

class UpdateProductEvent extends ProductEvent {
  final ProductModel product;
  final StoreModel store;

  final File? imageFile;

  const UpdateProductEvent(this.product, this.imageFile, this.store);

  @override
  List<Object?> get props => [product, store];
}

class DeleteProductEvent extends ProductEvent {
  final String productId;
  final StoreModel store;

  const DeleteProductEvent(this.productId, this.store);

  @override
  List<Object?> get props => [productId, store];
}

class FetchProductByIdEvent extends ProductEvent {
  final ProductModel product;

  const FetchProductByIdEvent(this.product);

  @override
  List<Object?> get props => [product];
}

class FetchProductByBarcodeEvent extends ProductEvent {
  final String barcode;

  const FetchProductByBarcodeEvent(
    this.barcode,
  );

  @override
  List<Object?> get props => [
        barcode,
      ];
}

class UpdateProductQuantity extends ProductEvent {
  final String productId;
  final int quantity;

  const UpdateProductQuantity({
    required this.productId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [productId, quantity];
}
