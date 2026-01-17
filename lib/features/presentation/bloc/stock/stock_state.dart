part of 'stock_bloc.dart';

abstract class StockState extends Equatable {
  const StockState();

  @override
  List<Object> get props => [];
}

class StockInitial extends StockState {}

class StockLoading extends StockState {}

class FetchStockById extends StockState {
  final StockModel stock;

  const FetchStockById(this.stock);

  @override
  List<Object> get props => [stock];
}

class StocksLoaded extends StockState {
  final List<StockModel> stocks;

  const StocksLoaded(this.stocks);

  @override
  List<Object> get props => [stocks];
}

class StockCreating extends StockState {}

class StockCreated extends StockState {
  final StockModel stock;

  const StockCreated(this.stock);

  @override
  List<Object> get props => [stock];
}

class StockUpdating extends StockState {}

class StockUpdated extends StockState {
  final StockModel stock;

  const StockUpdated(this.stock);

  @override
  List<Object> get props => [stock];
}


class StockDeleting extends StockState {}

class StockDeleted extends StockState {}

class StockError extends StockState {
  final String error;

  const StockError(this.error);

  @override
  List<Object> get props => [error];
}
