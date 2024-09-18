import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uv_pos/features/data/remote/models/order_model.dart';
import 'package:uv_pos/features/data/remote/models/product_model.dart';
import 'package:uv_pos/features/data/remote/models/store_model.dart';
import 'package:uv_pos/features/data/remote/models/user_model.dart';
import 'package:uv_pos/features/domain/repositories/order_repository.dart';
import 'package:uv_pos/features/domain/repositories/product_repository.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _orderRepository;
  final ProductRepository _productRepository;

  OrderBloc(this._orderRepository, this._productRepository) : super(OrderInitial()) {
    on<LoadOrdersEvent>(_fetchOrderList);
    on<FetchOrderByIdEvent>(_fetchOrderById);
    on<CreateOrderEvent>(_createOrder);
    on<AddProduct>(_onAddProduct);
    on<RemoveProduct>(_onRemoveProduct);
    on<UpdateOrderProductQuantity>(_onUpdateProductQuantity);
    on<OrderDiscountedEvent>(_onOrderAmountDiscounting);
    on<ClearProductList>(_onClearProductList);
  }

  Future<void> _fetchOrderList(LoadOrdersEvent event, Emitter<OrderState> emit) async {
    try {
      print('event.storeID is  ------>  ${event.storeID}');
      emit(OrderLoading());
      final orders = await _orderRepository.getOrdersForDateByStoreId(event.storeID!, event.date);
      print('orders is  ------>  $orders');

      if (orders.isNotEmpty) {
        emit(OrdersFromDateByStoreIDLoaded(orders: orders));
      } else {
        emit(OrderNotFound());
      }
    } catch (e) {
      emit(OrderError(error: e.toString()));
    }
  }

  Future<void> _fetchOrderById(FetchOrderByIdEvent event, Emitter<OrderState> emit) async {
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

  Future<void> _createOrder(CreateOrderEvent event, Emitter<OrderState> emit) async {
    try {
      emit(OrderCreating());
      await _orderRepository.createOrder(event.order);
      final createdOrder = await _orderRepository.getOrderById(event.order);
      final orders = await _orderRepository.getOrdersForDateByStoreId(
        event.store.id,
        event.order.orderDate,
      );
      log(createdOrder.toString());

      if (createdOrder != null) {
        emit(OrderCreated(order: createdOrder, store: event.store, user: event.user));
        emit(OrdersFromDateByStoreIDLoaded(orders: orders));
        // emit(const UpdatedOrderProducts(products: []));
      } else {
        emit(const OrderError(error: 'Failed to create Order.'));
      }
    } catch (e) {
      emit(OrderError(error: e.toString()));
    }
  }

  Future<void> _onAddProduct(AddProduct event, Emitter<OrderState> emit) async {
    final currentState = state;
    if (currentState is UpdatedOrderProducts) {
      if (currentState.products != null || currentState.products!.isNotEmpty) {
        final existingProductIndex = currentState.products!.indexWhere((product) => product.id == event.product.id);
        if (existingProductIndex != -1) {
          final updatedProducts = List<ProductModel>.from(currentState.products!);
          final existingProduct = updatedProducts[existingProductIndex];
          updatedProducts[existingProductIndex] = existingProduct.copyWith(size: existingProduct.size + 1);
          emit(UpdatedOrderProducts(products: updatedProducts));
        } else {
          final updatedProducts = List<ProductModel>.from(currentState.products!)..add(event.product);
          emit(UpdatedOrderProducts(products: updatedProducts));
        }
      } else {
        final updatedProducts = List<ProductModel>.from(currentState.products!)..add(event.product);
        emit(UpdatedOrderProducts(products: updatedProducts));
      }
    } else {
      emit(UpdatedOrderProducts(products: [event.product]));
    }
  }

  Future<void> _onRemoveProduct(RemoveProduct event, Emitter<OrderState> emit) async {
    if (state is UpdatedOrderProducts) {
      final state = this.state as UpdatedOrderProducts;
      List<ProductModel> products = state.products!.where((product) => product.id != event.productId).toList();
      log('$products');
      emit(UpdatedOrderProducts(products: List<ProductModel>.from(products)));
    }
  }

  Future<void> _onUpdateProductQuantity(UpdateOrderProductQuantity event, Emitter<OrderState> emit) async {
    log('this is a $event');

    try {
      if (state is UpdatedOrderProducts) {
        final currentState = state as UpdatedOrderProducts;
        log('this is a $state');
        final updatedProducts = currentState.products!.map(
          (product) {
            return product.id == event.product.id ? product.copyWith(size: event.size) : product;
          },
        ).toList();
        for (var product in updatedProducts) {
          log('$product');
        }
        log('$updatedProducts');
        emit(UpdatedOrderProducts(products: List<ProductModel>.from(updatedProducts)));
        log('state: $currentState');
      } else {
        emit(UpdatedOrderProducts(products: [event.product]));
        log('else state: $state');
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> _onOrderAmountDiscounting(OrderDiscountedEvent event, Emitter<OrderState> emit) async {
    final currentState = state;
    if (currentState is UpdatedOrderProducts) {
      List<ProductModel> products = currentState.products!;
      emit(
        OrderDiscountState(
          products: products,
          discount: event.discount,
          isFlat: event.isFlat,
        ),
      );
    }
  }

  Future<void> updateOrder(UpdateOrderEvent event, Emitter<OrderState> emit) async {
    try {
      emit(OrderUpdating());
      await _orderRepository.updateOrder(event.order);
      final updatedOrder = await _orderRepository.getOrderById(event.order);
      final orders = await _orderRepository.getOrdersForDateByStoreId(
        event.storeID,
        event.order.orderDate,
      );

      if (updatedOrder != null) {
        emit(OrderUpdated(order: updatedOrder));
        emit(OrdersFromDateByStoreIDLoaded(orders: orders));
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
      await _orderRepository.deleteOrder(event.order.id, event.order.orderDate);
      final List<OrderModel> orders = (await _orderRepository.getOrdersForDateByStoreId(
        event.storeID,
        event.order.orderDate,
      ))
          .cast<OrderModel>();

      emit(OrderDeleted());
      emit(OrdersFromDateByStoreIDLoaded(orders: orders));
    } catch (e) {
      emit(OrderError(error: e.toString()));
    }
  }

  Future<void> _onClearProductList(ClearProductList event, Emitter<OrderState> emit) async {
    emit(const UpdatedOrderProducts(products: []));
  }
}
