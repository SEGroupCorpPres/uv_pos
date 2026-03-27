import 'package:future_pos/core/core.dart';

part 'mapping_failure.freezed.dart';

@freezed
abstract class MappingFailure with _$MappingFailure implements Exception {
  // 2. @Implements orqali mixinni ulashni davom ettiramiz
  @Implements<AppExceptionMixin>()
  const factory MappingFailure({
    required String message,
    Object? exception,
    StackTrace? stackTrace,
  }) = _MappingFailure;
  const MappingFailure._();
}
