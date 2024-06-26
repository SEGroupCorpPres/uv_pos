import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uv_pos/core/helpers/image_helper.dart';
import 'package:uv_pos/features/data/remote/models/store_model.dart';
import 'package:uv_pos/features/domain/repositories/store_repository.dart';

part 'store_event.dart';
part 'store_state.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  final StoreRepository _storeRepository;

  StoreBloc(this._storeRepository) : super(StoreInitial()) {
    on<LoadStoresEvent>(fetchStoreList);
    on<FetchStoreByIdEvent>(fetchStoreById);
    on<CreateStoreEvent>(createStore);
    on<UpdateStoreEvent>(updateStore);
    on<DeleteStoreEvent>(deleteStore);
  }

  Future<void> fetchStoreList(LoadStoresEvent event, Emitter<StoreState> emit) async {
    try {
      emit(StoreLoading());
      final stores = await _storeRepository.getStoresByUserId();
      if (stores.isNotEmpty) {
        emit(StoresByUIDLoaded(stores: stores));
      } else {
        emit(StoreNotFound());
      }
    } catch (e) {
      emit(StoreError(error: e.toString()));
    }
  }

  Future<void> fetchStoreById(FetchStoreByIdEvent event, Emitter<StoreState> emit) async {
    try {
      emit(StoreLoading());
      final store = await _storeRepository.getStoreById(event.store.id);
      if (store != null) {
        emit(StoreByIdLoaded(store: store));
      } else {
        emit(StoreNotFound());
      }
    } catch (e) {
      emit(StoreError(error: e.toString()));
    }
  }

  Future<void> createStore(CreateStoreEvent event, Emitter<StoreState> emit) async {
    late StoreModel? storeModel;
    try {
      emit(StoreCreating());
      String? imageUrl;
      if (event.imageFile != null) {
        imageUrl = await ImageHelper().uploadImageToStorage(event.imageFile!, 'stores/${event.store.id}.jpg');
        storeModel = event.store.copyWith(imageUrl: imageUrl);
      }
      final storeId = await _storeRepository.createStore(storeModel!);
      final createdStore = await _storeRepository.getStoreById(storeId);
      if (createdStore != null) {
        emit(StoreCreated(store: createdStore));
      } else {
        emit(const StoreError(error: 'Failed to create store.'));
      }
    } catch (e) {
      emit(StoreError(error: e.toString()));
    }
  }

  Future<void> updateStore(UpdateStoreEvent event, Emitter<StoreState> emit) async {
    late StoreModel? storeModel;

    try {
      emit(StoreUpdating());
      if (event.imageFile != null) {
        final imageUrl = await ImageHelper().uploadImageToStorage(event.imageFile!, 'stores/${event.store.id}.jpg');
        storeModel = event.store.copyWith(imageUrl: imageUrl);
      }
      await _storeRepository.updateStore(storeModel!);
      final updatedStore = await _storeRepository.getStoreById(storeModel.id);
      if (updatedStore != null) {
        emit(StoreUpdated(store: updatedStore));
      } else {
        emit(StoreNotFound());
      }
    } catch (e) {
      emit(StoreError(error: e.toString()));
    }
  }

  Future<void> deleteStore(DeleteStoreEvent event, Emitter<StoreState> emit) async {
    try {
      emit(StoreDeleting());
      await _storeRepository.deleteStore(event.storeId);
      emit(StoreDeleted());
    } catch (e) {
      emit(StoreError(error: e.toString()));
    }
  }
}
