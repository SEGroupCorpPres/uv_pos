import 'package:uv_pos/core/core.dart';


class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    if (kDebugMode) {
      logger.i('🟢 Event | Bloc: $bloc\n➡️ Event: $event');
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    if (kDebugMode) {
      logger.d('🔄 Transition | Bloc: $bloc\n➡️ $transition');
    }
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (kDebugMode) {
      logger.i('📝 Change | Bloc: $bloc\n➡️ $change');
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    if (kDebugMode) {
      logger.e('❌ Error in Bloc: $bloc\nError: $error', error: error, stackTrace: stackTrace);
    }
  }

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    if (kDebugMode) {
      logger.i('✨ Created Bloc: $bloc');
    }
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    if (kDebugMode) {
      logger.w('🛑 Closed Bloc: $bloc');
    }
  }
}
