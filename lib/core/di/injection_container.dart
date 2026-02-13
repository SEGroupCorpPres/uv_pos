// lib/core/di/injection_container.dart
import 'package:uv_pos/core/core.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // ============ External Dependencies ============

  // Secure Storage
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
    ),
  );

  // Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl
    ..registerLazySingleton<SharedPreferences>(() => sharedPreferences)

    // Google Sign In
    ..registerLazySingleton<GoogleSignIn>(() => GoogleSignIn.instance)

    // Dio (if you want to register it separately)
    ..registerLazySingleton<Dio>(Dio.new)

    // ============ Core ============

    // API Client
    ..registerLazySingleton<ApiClient>(
      () => ApiClient(
        secureStorage: sl(),
        dio: sl(), // Optional: use registered Dio
      ),
    );

  // ============ Data Sources ============
  // Register your data sources here

  // ============ Repositories ============
  // Register your repositories here

  // ============ Use Cases ============
  // Register your use cases here

  // ============ BLoCs / Cubits ============
  // Register your BLoCs here
}
