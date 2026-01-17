import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/domain/repositories/repository.dart';
import '../../../domain/repositories/stock_repository.dart';

part 'stock_event.dart';
part 'stock_state.dart';

class StockBloc extends Bloc<StockEvent, StockState> {
  final StockRepository repository;
  StreamSubscription<List<StockModel>>? _stockSubscription;

  StockBloc(this.repository) : super(StockInitial()) {
    on<FetchStockByStoreId>(_onFetchStock);
    on<LoadStocksEvent>(_onFetchStocks);
    on<CreateStockEvent>(_onCreateStock);
    on<UpdateStockEvent>(_onUpdateStock);
    on<DeleteStockEvent>(_onDeleteStock);
    on<_StockUpdatedEvent>(_updatedStocks);
    // on<UpdateProductQuantity>(updateProductQuantity);

    // on<RemoveStockProduct>(_onRemoveStockProduct);
    // on<UpdateStockQuantity>(_onUpdateStockQuantity);
  }

  Future<void> _onFetchStock(FetchStockByStoreId event, Emitter<StockState> emit) async {
    emit(StockLoading());
    try {
      final stock = await repository.getStockById(event.storeId);
      emit(FetchStockById(stock!));
    } catch (e) {
      emit(StockError(e.toString()));
    }
  }

  Future<void> _onFetchStocks(LoadStocksEvent event, Emitter<StockState> emit) async {
    emit(StockLoading());
    await _stockSubscription?.cancel(); // eski streamni to‘xtatish
    try {
      _stockSubscription = repository
          .fetchStocks() // Firestore stream
          .listen(
        (stocks) {
          add(_StockUpdatedEvent(stocks)); // ichki event
        },
        onError: (error) {
          emit(StockError(error.toString()));
        },
      );
    } catch (e) {
      emit(StockError(e.toString()));
    }
  }

  Future<void> _updatedStocks(_StockUpdatedEvent event, Emitter<StockState> emit) async {
    emit(StocksLoaded(event.stocks));
  }

  Future<void> _onCreateStock(CreateStockEvent event, Emitter<StockState> emit) async {
    try {
      await repository.createStock(event.stock);
    } catch (e) {
      emit(StockError(e.toString()));
    }
  }

  Future<void> _onUpdateStock(UpdateStockEvent event, Emitter<StockState> emit) async {
    try {
      await repository.updateStock(event.stock);
    } catch (e) {
      emit(StockError(e.toString()));
    }
  }

  Future<void> _onDeleteStock(DeleteStockEvent event, Emitter<StockState> emit) async {
    try {
      await repository.deleteStock(event.stockID);
    } catch (e) {
      emit(StockError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _stockSubscription?.cancel();
    return super.close();
  }
}

// private ichki event
class _StockUpdatedEvent extends StockEvent {
  final List<StockModel> stocks;

  _StockUpdatedEvent(this.stocks);
}
