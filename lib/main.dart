import 'package:flutter/material.dart';
import 'package:uv_pos/app/app.dart';
import 'package:uv_pos/app/presentation/bloc/bloc.dart';
import 'package:uv_pos/core/core.dart';
import 'package:uv_pos/features/data/repositories/stock_repository_impl.dart';
import 'package:uv_pos/features/presentation/bloc/bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/config/.env');
  Bloc.observer = AppBlocObserver();
  final AuthenticationRepository authenticationRepository = AuthenticationRepository();
  final StoreRepository storeRepository = StoreRepository();
  final ProductRepository productRepository = ProductRepository();
  final OrderRepository orderRepository = OrderRepository();
  final StockRepository stockRepository = StockRepositoryImpl(firestore: firestore);
  final UserRepository userRepository = UserRepository();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AppBloc(userRepository: authenticationRepository)..add(AuthStarted()),
        ),
        BlocProvider(create: (context) => StoreBloc(storeRepository)),
        BlocProvider(create: (context) => ProductBloc(productRepository)),
        BlocProvider(
            create: (context) => OrderBloc(
                  orderRepository,
                )),
        BlocProvider(create: (context) => StockBloc(stockRepository)),
        BlocProvider(create: (context) => UserBloc(userRepository)),
      ],
      child: const App(),
    ),
  );
}
