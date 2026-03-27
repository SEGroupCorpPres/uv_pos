// import '../../../../presentation/bloc/bloc.dart';

// part 'product_event.dart';
// part 'product_state.dart';

// class ProductBloc extends Bloc<ProductEvent, ProductState> {
//   final ProductRepository _productRepository;

//   ProductBloc(this._productRepository) : super(ProductInitial()) {
//     on<LoadProductsEvent>(fetchProductList);
//     on<FetchProductByIdEvent>(fetchProductById);
//     on<FetchProductByBarcodeEvent>(onFetchProductByBarcode);
//     on<FilterProductList>(fetchFilteredProductList);
//     on<CreateProductEvent>(createProduct);
//     on<UpdateProductEvent>(updateProduct);
//     on<DeleteProductEvent>(deleteProduct);
//   }

//   Future<void> fetchProductList(LoadProductsEvent event, Emitter<ProductState> emit) async {
//     try {
//       emit(ProductLoading());
//       if (kDebugMode) {
//         log('store is ${event.storeID}');
//       }
//       final products = await _productRepository.getProducts(event.storeID);
//       if (kDebugMode) {
//         log('first product is $products');
//       }
//       if (products.isNotEmpty) {
//         emit(ProductsLoaded(products: products));
//       } else {
//         emit(ProductNotFound());
//       }
//     } catch (e) {
//       emit(ProductError(error: e.toString()));
//     }
//   }

//   Future<void> fetchFilteredProductList(FilterProductList event, Emitter<ProductState> emit) async {
//     try {
//       emit(ProductLoading());
//       if (kDebugMode) {
//         log('store is ${event.storeID}');
//       }
//       final products =
//           await _productRepository.getProductsWithFilter(event.storeID, event.filter);
//       if (kDebugMode) {
//         log('first product is $products');
//       }
//       if (products.isNotEmpty) {
//         emit(FilteredProductList(filteredProducts: products));
//       } else {
//         emit(ProductNotFound());
//       }
//     } catch (e) {
//       emit(ProductError(error: e.toString()));
//     }
//   }

//   Future<void> fetchProductById(FetchProductByIdEvent event, Emitter<ProductState> emit) async {
//     try {
//       emit(ProductLoading());
//       final product = await _productRepository.getProductById(event.id);
//       if (product != null) {
//         emit(ProductByIdLoaded(product: product));
//       } else {
//         emit(ProductNotFound());
//       }
//     } catch (e) {
//       emit(ProductError(error: e.toString()));
//     }
//   }

//   Future<void> onFetchProductByBarcode(
//       FetchProductByBarcodeEvent event, Emitter<ProductState> emit) async {
//     try {
//       emit(ProductLoading());
//       if (kDebugMode) {
//         log(event.barcode);
//       }
//       final product = await _productRepository.getProductByBarcode(event.barcode);
//       if (kDebugMode) {
//         log(product.toString());
//       }
//       if (product != null) {
//         emit(ProductSearchByBarcodeLoaded(product: product));
//       } else {
//         emit(ProductNotFound());
//       }
//     } catch (e) {
//       emit(ProductError(error: e.toString()));
//     }
//   }

//   Future<void> createProduct(CreateProductEvent event, Emitter<ProductState> emit) async {
//     late ProductModel? productModel;
//     try {
//       emit(ProductCreating());
//       String? imageUrl;
//       if (event.imageFile != null) {
//         imageUrl = await ImageHelper()
//             .uploadImageToStorage(event.imageFile!, 'products/${event.product.id}.jpg');
//         productModel = event.product.copyWith(thumbnail: imageUrl);
//       } else {
//         productModel = event.product;
//       }
//       await _productRepository.createProduct(productModel);
//       final createdProduct = await _productRepository.getProductById(productModel.id);
//       final products = await _productRepository.getProducts(event.storeID);

//       if (createdProduct != null) {
//         emit(ProductCreated(product: createdProduct));
//         emit(ProductsLoaded(products: products));
//       } else {
//         emit(const ProductError(error: 'Failed to create Product.'));
//       }
//     } catch (e) {
//       emit(ProductError(error: e.toString()));
//     }
//   }

//   Future<void> updateProduct(UpdateProductEvent event, Emitter<ProductState> emit) async {
//     ProductModel? productModel;
//     log(event.toString());
//     try {
//       emit(ProductUpdating());
//       if (event.imageFile != null) {
//         final imageUrl = await ImageHelper()
//             .uploadImageToStorage(event.imageFile!, 'products/${event.product.id}.jpg');
//         productModel = event.product.copyWith(thumbnail: imageUrl);
//       } else {
//         productModel = event.product;
//       }
//       log(productModel.toString());
//       await _productRepository.updateProduct(productModel);
//       final updatedProduct = await _productRepository.getProductById(productModel.id);
//       final products = await _productRepository.getProducts(event.storeID);

//       if (updatedProduct != null) {
//         emit(ProductUpdated(product: updatedProduct));
//         emit(ProductsLoaded(products: products));
//       } else {
//         emit(ProductNotFound());
//       }
//     } catch (e) {
//       emit(ProductError(error: e.toString()));
//     }
//   }

//   Future<void> deleteProduct(DeleteProductEvent event, Emitter<ProductState> emit) async {
//     try {
//       emit(ProductDeleting());
//       await _productRepository.deleteProduct(event.productId);
//       final products = await _productRepository.getProducts(event.storeID);

//       emit(ProductDeleted());
//       emit(ProductsLoaded(products: products));
//     } catch (e) {
//       emit(ProductError(error: e.toString()));
//     }
//   }
// }
