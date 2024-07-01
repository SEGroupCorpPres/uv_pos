import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uv_pos/core/helpers/image_helper.dart';
import 'package:uv_pos/features/data/remote/models/product_model.dart';
import 'package:uv_pos/features/data/remote/models/store_model.dart';
import 'package:uv_pos/features/domain/repositories/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;

  ProductBloc(this._productRepository) : super(ProductInitial()) {
    on<LoadProductsEvent>(fetchProductList);
    on<FetchProductByIdEvent>(fetchProductById);
    on<CreateProductEvent>(createProduct);
    on<UpdateProductEvent>(updateProduct);
    on<DeleteProductEvent>(deleteProduct);
  }

  Future<void> fetchProductList(LoadProductsEvent event, Emitter<ProductState> emit) async {
    try {
      emit(ProductLoading());
      final products = await _productRepository.getProductsByStoreId(event.store!);
      if (products.isNotEmpty) {
        emit(ProductsByStoreIdLoaded(products: products));
      } else {
        emit(ProductNotFound());
      }
    } catch (e) {
      emit(ProductError(error: e.toString()));
    }
  }

  Future<void> fetchProductById(FetchProductByIdEvent event, Emitter<ProductState> emit) async {
    try {
      emit(ProductLoading());
      final product = await _productRepository.getProductById(event.product);
      if (product != null) {
        emit(ProductByIdLoaded(product: product));
      } else {
        emit(ProductNotFound());
      }
    } catch (e) {
      emit(ProductError(error: e.toString()));
    }
  }

  Future<void> createProduct(CreateProductEvent event, Emitter<ProductState> emit) async {
    late ProductModel? productModel;
    try {
      emit(ProductCreating());
      String? imageUrl;
      if (event.imageFile != null) {
        imageUrl = await ImageHelper().uploadImageToStorage(event.imageFile!, 'products/${event.product.id}.jpg');
        productModel = event.product.copyWith(image: imageUrl);
      }
      await _productRepository.createProduct(productModel!, event.store);
      final createdProduct = await _productRepository.getProductById(productModel);
      final products = await _productRepository.getProductsByStoreId(event.store);

      if (createdProduct != null) {
        emit(ProductCreated(product: createdProduct));
        emit(ProductsByStoreIdLoaded(products: products));
      } else {
        emit(const ProductError(error: 'Failed to create Product.'));
      }
    } catch (e) {
      emit(ProductError(error: e.toString()));
    }
  }

  Future<void> updateProduct(UpdateProductEvent event, Emitter<ProductState> emit) async {
    late ProductModel? productModel;

    try {
      emit(ProductUpdating());
      if (event.imageFile != null) {
        final imageUrl = await ImageHelper().uploadImageToStorage(event.imageFile!, 'products/${event.product.id}.jpg');
        productModel = event.product.copyWith(image: imageUrl);
      }
      await _productRepository.updateProduct(productModel!);
      final updatedProduct = await _productRepository.getProductById(productModel);
      final products = await _productRepository.getProductsByStoreId(event.store);

      if (updatedProduct != null) {
        emit(ProductUpdated(product: updatedProduct));
        emit(ProductsByStoreIdLoaded(products: products));
      } else {
        emit(ProductNotFound());
      }
    } catch (e) {
      emit(ProductError(error: e.toString()));
    }
  }

  Future<void> deleteProduct(DeleteProductEvent event, Emitter<ProductState> emit) async {
    try {
      emit(ProductDeleting());
      await _productRepository.deleteProduct(event.productId);
      final products = await _productRepository.getProductsByStoreId(event.store);

      emit(ProductDeleted());
      emit(ProductsByStoreIdLoaded(products: products));
    } catch (e) {
      emit(ProductError(error: e.toString()));
    }
  }
}