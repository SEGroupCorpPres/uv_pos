import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uv_pos/features/data/remote/models/stock_model.dart';
import 'package:uv_pos/features/domain/repositories/stock_repository.dart';

part 'stock_event.dart';
part 'stock_state.dart';

class StockBloc extends Bloc<StockEvent, StockState> {
  final StockRepository _stockRepository;

  StockBloc(this._stockRepository) : super(StockInitial()) {
    on<FetchStockByStoreId>(_onFetchStock);
    on<AddUpdateStockProduct>(_onAddUpdateStock);
    // on<RemoveStockProduct>(_onRemoveStockProduct);
    // on<UpdateStockQuantity>(_onUpdateStockQuantity);
  }

  void _onFetchStock(FetchStockByStoreId event, Emitter<StockState> emit) async {
    emit(StockLoading());
    try {
      final stocks = await _stockRepository.getStocksByStoreId(event.storeId);
      emit(StockLoaded(stocks));
    } catch (e) {
      emit(StockError(e.toString()));
    }
  }

  void _onAddUpdateStock(AddUpdateStockProduct event, Emitter<StockState> emit) async {
    StockModel? stock = await _stockRepository.getStockById(event.stock);
    if (stock == null) {
      await _stockRepository.createStock(event.stock);
    } else {
      final stockModel = StockModel(
        id: stock.id,
        storeId: stock.storeId,
        qty: stock.qty + event.quantity,
      );
      await _stockRepository.updateStock(stockModel);
    }
    if (state is StockLoaded) {
      final state = this.state as StockLoaded;
      final updatedProducts = List<StockModel>.from(state.stocks)..add(event.stock);
      try {
        emit(StockLoaded(updatedProducts));
      } catch (e) {
        emit(StockError('Error adding product: $e'));
      }
    }
  }

  //
  // void _onRemoveStockProduct(RemoveStockProduct event, Emitter<StockState> emit) async {
  //   if (state is StockLoaded) {
  //     final state = this.state as StockLoaded;
  //     final updatedProducts = state.products.where((product) => product.id != event.productId).toList();
  //     try {
  //       await _productRepository.removeProduct(event.productId);
  //       emit(StockLoaded(updatedProducts));
  //     } catch (e) {
  //       emit(StockError('Error removing product: $e'));
  //     }
  //   }
  // }

  // void _onUpdateStockQuantity(UpdateStockQuantity event, Emitter<StockState> emit) async {
  //   late StockModel stockModel;
  //   if (state is StockLoaded) {
  //     final state = this.state as StockLoaded;
  //     final updateStocks = state.stocks.map(
  //       (stock) {
  //         if (stock.id == event.productId) {
  //           return stockModel;
  //         } else {
  //           return stock;
  //         }
  //       },
  //     ).toList();
  //     try {
  //       emit(StockLoaded(updateStocks));
  //     } catch (e) {
  //       emit(StockError('Error updating product quantity: $e'));
  //     }
  //   }
  // }
}
