// store_event.dart
part of 'store_bloc.dart';

abstract class StoreEvent extends Equatable {
  const StoreEvent();

  @override
  List<Object?> get props => [];
}

class LoadStoresEvent extends StoreEvent {}

class CreateStoreEvent extends StoreEvent {
  final StoreModel store;
  final File? imageFile;

  const CreateStoreEvent(this.store, this.imageFile);

  @override
  List<Object?> get props => [store, imageFile];
}

class UpdateStoreEvent extends StoreEvent {
  final StoreModel store;
  final File? imageFile;

  const UpdateStoreEvent(this.store, this.imageFile);

  @override
  List<Object?> get props => [store];
}

class DeleteStoreEvent extends StoreEvent {
  final String storeId;

  const DeleteStoreEvent(this.storeId);

  @override
  List<Object?> get props => [storeId];
}

class FetchStoreByIdEvent extends StoreEvent {
  final StoreModel store;

  const FetchStoreByIdEvent(this.store);

  @override
  List<Object?> get props => [store];
}

// class FetchStoreByUIDEvent extends StoreEvent {
//   final String uid;
//
//   const FetchStoreByUIDEvent(this.uid);
//
//   @override
//   List<Object?> get props => [uid];
// }
