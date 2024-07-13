// Order_event.dart
part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrdersEvent extends OrderEvent {
  final StoreModel? store;
  final String? date;

  const LoadOrdersEvent([this.store, this.date]);
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
  final OrderModel order;
  final StoreModel store;


  const DeleteOrderEvent(this.order, this.store);

  @override
  List<Object?> get props => [order, store];
}

class FetchOrderByIdEvent extends OrderEvent {
  final OrderModel order;
  final String date;

  const FetchOrderByIdEvent(this.order, this.date);

  @override
  List<Object?> get props => [order, date];
}

class AddProduct extends OrderEvent {
  final ProductModel product;

  const AddProduct(this.product);

  @override
  List<Object?> get props => [product];
}

class RemoveProduct extends OrderEvent {
  final String productId;

  const RemoveProduct(this.productId);

  @override
  List<Object?> get props => [productId];
}

class UpdateOrderProductQuantity extends OrderEvent {
  final String productId;
  final int quantity;

  const UpdateOrderProductQuantity({
    required this.productId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [productId, quantity];
}

class ClearProductList extends OrderEvent {}