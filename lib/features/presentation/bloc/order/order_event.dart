// Order_event.dart
part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrdersEvent extends OrderEvent {
  final String? storeID;
  final DateTime? date;

  const LoadOrdersEvent([this.storeID, this.date]);

  @override
  // TODO: implement props
  List<Object?> get props => [storeID];
}

class CreateOrderEvent extends OrderEvent {
  final OrderModel order;
  final String storeID;

  const CreateOrderEvent(this.order, this.storeID);

  @override
  List<Object?> get props => [order, storeID];
}

class UpdateOrderEvent extends OrderEvent {
  final OrderModel order;
  final String storeID;

  const UpdateOrderEvent(this.order, this.storeID);

  @override
  List<Object?> get props => [order, storeID];
}

class DeleteOrderEvent extends OrderEvent {
  final OrderModel order;
  final String storeID;

  const DeleteOrderEvent(this.order, this.storeID);

  @override
  List<Object?> get props => [order, storeID];
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

class OrderDiscountedEvent extends OrderEvent {
  final double discount;
  final bool isFlat;

  const OrderDiscountedEvent({
    required this.discount,
    required this.isFlat,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [discount, isFlat];
}

class ClearProductList extends OrderEvent {}
