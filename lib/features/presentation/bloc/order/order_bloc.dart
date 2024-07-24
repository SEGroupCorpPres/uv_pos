import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uv_pos/features/data/remote/models/order_model.dart';
import 'package:uv_pos/features/data/remote/models/product_model.dart';
import 'package:uv_pos/features/data/remote/models/store_model.dart';
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
        event.storeID,
        event.order.orderDate,
      );

      if (createdOrder != null) {
        emit(OrderCreated(order: createdOrder));
        emit(OrdersFromDateByStoreIDLoaded(orders: orders));
      } else {
        emit(const OrderError(error: 'Failed to create Order.'));
      }
    } catch (e) {
      emit(OrderError(error: e.toString()));
    }
  }

  Future<void> _onAddProduct(AddProduct event, Emitter<OrderState> emit) async {
    if (state is ProductAddToOrder) {
      final state = this.state as ProductAddToOrder;
      emit(ProductAddToOrder(List.from(state.products)..add(event.product)));
    } else {
      emit(ProductAddToOrder([event.product]));
    }
  }

  Future<void> _onRemoveProduct(RemoveProduct event, Emitter<OrderState> emit) async {
    if (state is ProductAddToOrder) {
      final state = this.state as ProductAddToOrder;
      emit(ProductAddToOrder(state.products.where((product) => product.id != event.productId).toList()));
    }
  }

  Future<void> _onUpdateProductQuantity(UpdateOrderProductQuantity event, Emitter<OrderState> emit) async {
    if (state is ProductAddToOrder) {
      final state = this.state as ProductAddToOrder;
      final updatedProducts = state.products.map(
        (product) {
          return product.id == event.productId
              ? ProductModel(
                  id: product.id,
                  name: product.name,
                  quantity: product.quantity + event.quantity,
                  price: product.price,
                  barcode: product.barcode,
                  description: product.description,
                  cost: product.cost,
                  storeId: product.storeId,
                )
              : product;
        },
      ).toList();

      emit(ProductAddToOrder(updatedProducts));
    }
  }

  Future<void> _onOrderAmountDiscounting(OrderDiscountedEvent event, Emitter<OrderState> emit) async {
    emit(
      OrderDiscountState(
        discount: event.discount,
        isFlat: event.isFlat,
      ),
    );
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
    emit(const ProductAddToOrder([]));
  }
}
