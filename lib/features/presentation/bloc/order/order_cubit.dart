

import 'package:flutter_bloc/flutter_bloc.dart';

part 'order_state.dart';
class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrderState().init());
}
