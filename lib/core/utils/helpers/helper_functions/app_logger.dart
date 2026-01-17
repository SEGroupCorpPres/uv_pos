import 'package:uv_pos/core/core.dart';

sealed class AppLogger {
  static final logger = Talker(
    settings: TalkerSettings(
      enabled: kDebugMode,
      titles: {
        TalkerKey.info: 'INFO',
        TalkerKey.warning: 'WARNING',
        TalkerKey.error: 'ERROR',
        TalkerKey.critical: 'CRITICAL',
        TalkerKey.exception: 'EXCEPTION',
        TalkerKey.verbose: 'VERBOSE',
      },
    ),
  );

  static void info(String message, {Object? exception, StackTrace? stackTrace}) {
    return logger.info(message, exception, stackTrace);
  }

  static void warning(String message, {Object? exception, StackTrace? stackTrace}) {
    return logger.warning(message, exception, stackTrace);
  }

  static void error(Failure failure, {StackTrace? stacktrace}) {
    return logger.error(failure.message, failure, stacktrace);
  }

  static void critical(String message, {Object? exception, StackTrace? stackTrace}) {
    return logger.critical(message, exception, stackTrace);
  }

  static void log(
    String message, {
    LogLevel logLevel = LogLevel.debug,
    Object? exception,
    StackTrace? stackTrace,
    AnsiPen? pen,
  }) {
    return logger.log(
      message,
      logLevel: logLevel,
      exception: exception,
      stackTrace: stackTrace,
      pen: pen,
    );
  }
}
