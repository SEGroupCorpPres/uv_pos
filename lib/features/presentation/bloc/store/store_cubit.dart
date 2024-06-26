// // store_cubit.dart
// import 'dart:io';
//
// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:uv_pos/core/helpers/image_helper.dart';
// import 'package:uv_pos/features/data/remote/models/store_model.dart';
// import 'package:uv_pos/features/domain/repositories/store_repository.dart';
//
// part 'store_state.dart';
//
// class StoreCubit extends Cubit<StoreState> {
//   final StoreRepository _storeRepository;
//
//   StoreCubit(this._storeRepository) : super(StoreInitial());
//
//   Future<void> fetchStoreList() async {
//     try {
//       emit(StoreLoading());
//       final stores = await _storeRepository.getStoresByUserId();
//       if (stores.isNotEmpty) {
//         emit(StoresByUIDLoaded(stores: stores));
//       } else {
//         emit(StoreNotFound());
//       }
//     } catch (e) {
//       emit(StoreError(error: e.toString()));
//     }
//   }
//
//   Future<void> fetchStoreById(String storeId) async {
//     try {
//       emit(StoreLoading());
//       final store = await _storeRepository.getStoreById(storeId);
//       if (store != null) {
//         emit(StoreByIdLoaded(store: store));
//       } else {
//         emit(StoreNotFound());
//       }
//     } catch (e) {
//       emit(StoreError(error: e.toString()));
//     }
//   }
//
//   Future<void> createStore(StoreModel store, File? imageFile) async {
//     try {
//       emit(StoreCreating());
//       String? imageUrl;
//       if (imageFile != null) {
//         imageUrl = await ImageHelper().uploadImageToStorage(imageFile, 'stores/${store.id}/image.jpg');
//         store = store.copyWith(imageUrl: imageUrl);
//       }
//       final storeId = await _storeRepository.createStore(store);
//       final createdStore = await _storeRepository.getStoreById(storeId);
//       if (createdStore != null) {
//         emit(StoreCreated(store: createdStore));
//       } else {
//         emit(const StoreError(error: 'Failed to create store.'));
//       }
//     } catch (e) {
//       emit(StoreError(error: e.toString()));
//     }
//   }
//
//   Future<void> updateStore(StoreModel store, File? imageFile) async {
//     try {
//       emit(StoreUpdating());
//       if (imageFile != null) {
//         final imageUrl = await ImageHelper().uploadImageToStorage(imageFile, 'stores/${store.id}/image.jpg');
//         store = store.copyWith(imageUrl: imageUrl);
//       }
//       await _storeRepository.updateStore(store);
//       final updatedStore = await _storeRepository.getStoreById(store.id);
//       if (updatedStore != null) {
//         emit(StoreUpdated(store: updatedStore));
//       } else {
//         emit(StoreNotFound());
//       }
//     } catch (e) {
//       emit(StoreError(error: e.toString()));
//     }
//   }
//
//   Future<void> deleteStore(String storeId) async {
//     try {
//       emit(StoreDeleting());
//       await _storeRepository.deleteStore(storeId);
//       emit(StoreDeleted());
//     } catch (e) {
//       emit(StoreError(error: e.toString()));
//     }
//   }
// }
