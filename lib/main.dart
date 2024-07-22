import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uv_pos/app/app.dart';
import 'package:uv_pos/app/domain/repositories/auth_repository.dart';
import 'package:uv_pos/app/presentation/bloc/auth/app_bloc.dart';
import 'package:uv_pos/core/observer/bloc_observer.dart';
import 'package:uv_pos/features/domain/repositories/order_repository.dart';
import 'package:uv_pos/features/domain/repositories/product_repository.dart';
import 'package:uv_pos/features/domain/repositories/stock_repository.dart';
import 'package:uv_pos/features/domain/repositories/store_repository.dart';
import 'package:uv_pos/features/presentation/bloc/order/order_bloc.dart';
import 'package:uv_pos/features/presentation/bloc/product/product_bloc.dart';
import 'package:uv_pos/features/presentation/bloc/stock/stock_bloc.dart';
import 'package:uv_pos/firebase_options.dart';

import 'features/presentation/bloc/store/store_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = AppBlocObserver();

  final AuthenticationRepository authenticationRepository = AuthenticationRepository();
  final StoreRepository storeRepository = StoreRepository();
  final ProductRepository productRepository = ProductRepository();
  final OrderRepository orderRepository = OrderRepository();
  final StockRepository stockRepository = StockRepository();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppBloc(userRepository: authenticationRepository)..add(AuthStarted() ),
        ),
        BlocProvider(create: (context) => StoreBloc(storeRepository)),
        BlocProvider(create: (context) => ProductBloc(productRepository)),
        BlocProvider(create: (context) => OrderBloc(orderRepository, productRepository)),
        BlocProvider(create: (context) => StockBloc(stockRepository)),
      ],
      child: const App(),
    ),
  );
}
