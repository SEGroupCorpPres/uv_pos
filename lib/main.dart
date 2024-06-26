import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uv_pos/app/app.dart';
import 'package:uv_pos/app/domain/repositories/auth_repository.dart';
import 'package:uv_pos/app/presentation/bloc/auth/app_bloc.dart';
import 'package:uv_pos/core/observer/bloc_observer.dart';
import 'package:uv_pos/features/domain/repositories/store_repository.dart';
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
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppBloc(userRepository: authenticationRepository)
            ..add(
              AuthStarted(),
            ),
        ),
        BlocProvider(
          create: (context) => StoreBloc(storeRepository)..add(LoadStoresEvent()),
        ),
      ],
      child: const App(),
    ),
  );
}
