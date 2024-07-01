import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uv_pos/features/data/remote/models/order_model.dart';
import 'package:uv_pos/features/data/remote/models/store_model.dart';
import 'package:uv_pos/features/domain/repositories/order_repository.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _orderRepository;

  OrderBloc(this._orderRepository) : super(OrderInitial()) {
    on<LoadOrdersEvent>(fetchOrderList);
    on<FetchOrderByIdEvent>(fetchOrderById);
    on<CreateOrderEvent>(createOrder);
    on<UpdateOrderEvent>(updateOrder);
    on<DeleteOrderEvent>(deleteOrder);
  }

  Future<void> fetchOrderList(LoadOrdersEvent event, Emitter<OrderState> emit) async {
    try {
      emit(OrderLoading());
      final orders = await _orderRepository.getOrdersByStoreId(event.store!);
      if (orders.isNotEmpty) {
        emit(OrdersByStoreIDLoaded(orders: orders));
      } else {
        emit(OrderNotFound());
      }
    } catch (e) {
      emit(OrderError(error: e.toString()));
    }
  }

  Future<void> fetchOrderById(FetchOrderByIdEvent event, Emitter<OrderState> emit) async {
    try {
      emit(OrderLoading());
      final order = await _orderRepository.getOrderById(event.order);
      if (order != null) {
        emit(OrderByIdLoaded(order: order));
      } else {
        emit(OrderNotFound());
      }
    } catch (e) {
      emit(OrderError(error: e.toString()));
    }
  }

  Future<void> createOrder(CreateOrderEvent event, Emitter<OrderState> emit) async {
    try {
      emit(OrderCreating());
      await _orderRepository.createOrder(event.order);
      final createdOrder = await _orderRepository.getOrderById(event.order);
      final orders = await _orderRepository.getOrdersByStoreId(event.store);

      if (createdOrder != null) {
        emit(OrderCreated(order: createdOrder));
        emit(OrdersByStoreIDLoaded(orders: orders));
      } else {
        emit(const OrderError(error: 'Failed to create Order.'));
      }
    } catch (e) {
      emit(OrderError(error: e.toString()));
    }
  }

  Future<void> updateOrder(UpdateOrderEvent event, Emitter<OrderState> emit) async {
    try {
      emit(OrderUpdating());
      await _orderRepository.updateOrder(event.order);
      final updatedOrder = await _orderRepository.getOrderById(event.order);
      final orders = await _orderRepository.getOrdersByStoreId(event.store);

      if (updatedOrder != null) {
        emit(OrderUpdated(order: updatedOrder));
        emit(OrdersByStoreIDLoaded(orders: orders));
      } else {
        emit(OrderNotFound());
      }
    } catch (e) {
      emit(OrderError(error: e.toString()));
    }
  }

  Future<void> deleteOrder(DeleteOrderEvent event, Emitter<OrderState> emit) async {
    try {
      emit(OrderDeleting());
      await _orderRepository.deleteOrder(event.orderId);
      final List<OrderModel> orders = (await _orderRepository.getOrdersByStoreId(event.store)).cast<OrderModel>();

      emit(OrderDeleted());
      emit(OrdersByStoreIDLoaded(orders: orders));
    } catch (e) {
      emit(OrderError(error: e.toString()));
    }
  }
}
