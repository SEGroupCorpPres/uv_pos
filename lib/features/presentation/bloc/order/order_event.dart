// Order_event.dart
part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrdersEvent extends OrderEvent {
  final StoreModel? store;

  const LoadOrdersEvent([this.store]);
  @override
  // TODO: implement props
  List<Object?> get props => [store];

}

class CreateOrderEvent extends OrderEvent {
  final OrderModel order;
  final StoreModel store;

  const CreateOrderEvent(this.order, this.store);

  @override
  List<Object?> get props => [order, store];
}

class UpdateOrderEvent extends OrderEvent {
  final OrderModel order;
  final StoreModel store;

  const UpdateOrderEvent(this.order, this.store);

  @override
  List<Object?> get props => [order, store];
}

class DeleteOrderEvent extends OrderEvent {
  final String orderId;
  final StoreModel store;


  const DeleteOrderEvent(this.orderId, this.store);

  @override
  List<Object?> get props => [orderId, store];
}

class FetchOrderByIdEvent extends OrderEvent {
  final OrderModel order;

  const FetchOrderByIdEvent(this.order);

  @override
  List<Object?> get props => [order];
}

// class FetchOrderByUIDEvent extends OrderEvent {
//   final String uid;
//
//   const FetchOrderByUIDEvent(this.uid);
//
//   @override
//   List<Object?> get props => [uid];
// }
