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

class AddUpdateStockProduct extends StockEvent {
  final StockModel stock;
  final ProductModel product;
  final String productId;
  final double size;
  final String mesurementType;

  const AddUpdateStockProduct(this.productId, this.size, this.mesurementType, this.product, {required this.stock});

  @override
  List<Object> get props => [stock, product, productId, size];
}

class RemoveStockProduct extends StockEvent {
  final String productId;

  const RemoveStockProduct(this.productId);

  @override
  List<Object> get props => [productId];
}
