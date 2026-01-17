import 'package:bloc/bloc.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  CustomerBloc() : super(CustomerState().init()) {
    on<InitEvent>(_init);
  }

  void _init(InitEvent event, Emitter<CustomerState> emit) async {
    emit(state.clone());
  }
}
