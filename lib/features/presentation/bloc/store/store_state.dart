// store_state.dart
part of 'store_bloc.dart';

abstract class StoreState extends Equatable {
  const StoreState();

  @override
  List<Object?> get props => [];
}

class StoreInitial extends StoreState {}

class StoreLoading extends StoreState {}

class StoreByIdLoaded extends StoreState {
  final StoreModel store;

  const StoreByIdLoaded({required this.store});

  @override
  List<Object?> get props => [store];
}

class StoresByUIDLoaded extends StoreState {
  final List<StoreModel>? stores;

  const StoresByUIDLoaded({required this.stores});

  @override
  List<Object?> get props => [stores];
}

class StoreNotFound extends StoreState {}

class StoreError extends StoreState {
  final String error;

  const StoreError({required this.error});

  @override
  List<Object?> get props => [error];
}
class StoreCreating extends StoreState {}

class StoreCreated extends StoreState {
  final StoreModel store;

  const StoreCreated({required this.store});

  @override
  List<Object?> get props => [store];
}
class StoreUpdating extends StoreState {}

class StoreUpdated extends StoreState {
  final StoreModel store;

  const StoreUpdated({required this.store});

  @override
  List<Object?> get props => [store];
}

class StoreDeleting extends StoreState {}

class StoreDeleted extends StoreState {}
