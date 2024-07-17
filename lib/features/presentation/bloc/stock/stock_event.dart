part of 'stock_bloc.dart';

abstract class StockEvent extends Equatable {
  const StockEvent();

  @override
  List<Object> get props => [];
}

class FetchStockByStoreId extends StockEvent {
  final String storeId;

  const FetchStockByStoreId({required this.storeId});

  @override
  // TODO: implement props
  List<Object> get props => [storeId];
}

class AddStockProduct extends StockEvent {
  final StockModel stock;

  const AddStockProduct(
    this.stock,
  );

  @override
  List<Object> get props => [
        stock,
      ];
}

class RemoveStockProduct extends StockEvent {
  final String productId;

  const RemoveStockProduct(this.productId);

  @override
  List<Object> get props => [productId];
}

class UpdateStockQuantity extends StockEvent {
  final StockModel stock;
  final String productId;
  final int quantity;

  const UpdateStockQuantity({
    required this.stock,
    required this.productId,
    required this.quantity,
  });

  @override
  List<Object> get props => [productId, quantity, stock];
}
