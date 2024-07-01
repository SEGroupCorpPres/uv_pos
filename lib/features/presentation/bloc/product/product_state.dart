// Product_state.dart
part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductByIdLoaded extends ProductState {
  final ProductModel product;

  const ProductByIdLoaded({required this.product});

  @override
  List<Object?> get props => [product];
}

class ProductsByStoreIdLoaded extends ProductState {
  final List<ProductModel>? products;

  const ProductsByStoreIdLoaded({required this.products});


  @override
  List<Object?> get props => [products];
}

class ProductNotFound extends ProductState {}

class ProductError extends ProductState {
  final String error;

  const ProductError({required this.error});

  @override
  List<Object?> get props => [error];
}

class ProductCreating extends ProductState {}

class ProductCreated extends ProductState {
  final ProductModel product;

  const ProductCreated({required this.product});

  @override
  List<Object?> get props => [product];
}

class ProductUpdating extends ProductState {}

class ProductUpdated extends ProductState {
  final ProductModel product;

  const ProductUpdated({required this.product});

  @override
  List<Object?> get props => [product];
}

class ProductDeleting extends ProductState {}

class ProductDeleted extends ProductState {}
