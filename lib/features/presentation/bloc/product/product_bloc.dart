import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
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
    on<FetchProductByBarcodeEvent>(onFetchProductByBarcode);
    on<FilterProductList>(fetchFilteredProductList);
    on<CreateProductEvent>(createProduct);
    on<UpdateProductEvent>(updateProduct);
    on<UpdateProductQuantity>(updateProductQuantity);
    on<DeleteProductEvent>(deleteProduct);
  }

  Future<void> fetchProductList(LoadProductsEvent event, Emitter<ProductState> emit) async {
    try {
      emit(ProductLoading());
      if (kDebugMode) {
        print('store is ${event.store}');
      }
      final products = await _productRepository.getProductsByStoreId(event.store!);
      if (kDebugMode) {
        print('first product is $products');
      }
      if (products.isNotEmpty) {
        emit(ProductsByStoreIdLoaded(products: products));
      } else {
        emit(ProductNotFound());
      }
    } catch (e) {
      emit(ProductError(error: e.toString()));
    }
  }

  Future<void> fetchFilteredProductList(FilterProductList event, Emitter<ProductState> emit) async {
    try {
      emit(ProductLoading());
      if (kDebugMode) {
        print('store is ${event.store}');
      }
      final products = await _productRepository.getProductsByStoreIdWithFilter(event.store, event.filter);
      if (kDebugMode) {
        print('first product is $products');
      }
      if (products.isNotEmpty) {
        emit(FilteredProductList(filteredProducts: products));
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
      final product = await _productRepository.getProductById(event.id);
      if (product != null) {
        emit(ProductByIdLoaded(product: product));
      } else {
        emit(ProductNotFound());
      }
    } catch (e) {
      emit(ProductError(error: e.toString()));
    }
  }

  Future<void> onFetchProductByBarcode(FetchProductByBarcodeEvent event, Emitter<ProductState> emit) async {
    try {
      emit(ProductLoading());
      if (kDebugMode) {
        print(event.barcode);
      }
      final product = await _productRepository.getProductByBarcode(event.barcode);
      if (kDebugMode) {
        print(product);
      }
      if (product != null) {
        emit(ProductSearchByBarcodeLoaded(product: product));
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
      } else {
        productModel = event.product;
      }
      await _productRepository.createProduct(productModel, event.store);
      final createdProduct = await _productRepository.getProductById(productModel.id);
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
    ProductModel? productModel;
    log(event.toString());
    try {
      emit(ProductUpdating());
      if (event.imageFile != null) {
        final imageUrl = await ImageHelper().uploadImageToStorage(event.imageFile!, 'products/${event.product.id}.jpg');
        productModel = event.product.copyWith(image: imageUrl);
      } else {
        productModel = event.product;
      }
      log(productModel.toString());
      await _productRepository.updateProduct(productModel);
      final updatedProduct = await _productRepository.getProductById(productModel.id);
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

  Future<void> updateProductQuantity(UpdateProductQuantity event, Emitter<ProductState> emit) async {
    late ProductModel? updatingProduct;

    try {
      ProductModel? oldProduct = await _productRepository.getProductById(event.product.id);
      if (oldProduct != null) {
        updatingProduct = event.product.copyWith(size: oldProduct.size - event.size);
      }
      await _productRepository.updateProduct(updatingProduct!);
      final updatedProduct = await _productRepository.getProductById(updatingProduct.id);
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
