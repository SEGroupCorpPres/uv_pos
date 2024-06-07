import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uv_pos/app/app.dart';
import 'package:uv_pos/app/presentation/bloc/auth/auth_bloc.dart';
import 'package:uv_pos/core/observer/bloc_observer.dart';
import 'package:uv_pos/app/domain/repositories/auth_repository.dart';
import 'package:uv_pos/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = AppBlocObserver();

  final authenticationRepository = AuthenticationRepository();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(userRepository: authenticationRepository)
            ..add(
              AuthStarted(),
            ),
        ),
      ],
      child: const App(),
    ),
  );
}
