// Order_state.dart
part of 'order_bloc.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderByIdLoaded extends OrderState {
  final OrderModel order;

  const OrderByIdLoaded({required this.order});

  @override
  List<Object?> get props => [order];
}

class OrdersByStoreIDLoaded extends OrderState {
  final List<OrderModel>? orders;

  const OrdersByStoreIDLoaded({required this.orders});

  @override
  List<Object?> get props => [orders];
}

class OrderNotFound extends OrderState {}

class OrderError extends OrderState {
  final String error;

  const OrderError({required this.error});

  @override
  List<Object?> get props => [error];
}

class OrderCreating extends OrderState {}

class OrderCreated extends OrderState {
  final OrderModel order;

  const OrderCreated({required this.order});

  @override
  List<Object?> get props => [order];
}

class OrderUpdating extends OrderState {}

class OrderUpdated extends OrderState {
  final OrderModel order;

  const OrderUpdated({required this.order});

  @override
  List<Object?> get props => [order];
}

class OrderDeleting extends OrderState {}

class OrderDeleted extends OrderState {}