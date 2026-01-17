// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mapping_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MappingFailure {
  String get message;
  Object? get exception;
  StackTrace? get stackTrace;

  /// Create a copy of MappingFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MappingFailureCopyWith<MappingFailure> get copyWith =>
      _$MappingFailureCopyWithImpl<MappingFailure>(
          this as MappingFailure, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MappingFailure &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other.exception, exception) &&
            (identical(other.stackTrace, stackTrace) ||
                other.stackTrace == stackTrace));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message,
      const DeepCollectionEquality().hash(exception), stackTrace);

  @override
  String toString() {
    return 'MappingFailure(message: $message, exception: $exception, stackTrace: $stackTrace)';
  }
}

/// @nodoc
abstract mixin class $MappingFailureCopyWith<$Res> {
  factory $MappingFailureCopyWith(
          MappingFailure value, $Res Function(MappingFailure) _then) =
      _$MappingFailureCopyWithImpl;
  @useResult
  $Res call({String message, Object? exception, StackTrace? stackTrace});
}

/// @nodoc
class _$MappingFailureCopyWithImpl<$Res>
    implements $MappingFailureCopyWith<$Res> {
  _$MappingFailureCopyWithImpl(this._self, this._then);

  final MappingFailure _self;
  final $Res Function(MappingFailure) _then;

  /// Create a copy of MappingFailure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? exception = freezed,
    Object? stackTrace = freezed,
  }) {
    return _then(_self.copyWith(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      exception: freezed == exception ? _self.exception : exception,
      stackTrace: freezed == stackTrace
          ? _self.stackTrace
          : stackTrace // ignore: cast_nullable_to_non_nullable
              as StackTrace?,
    ));
  }
}

/// Adds pattern-matching-related methods to [MappingFailure].
extension MappingFailurePatterns on MappingFailure {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MappingFailure value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MappingFailure() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MappingFailure value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MappingFailure():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MappingFailure value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MappingFailure() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String message, Object? exception, StackTrace? stackTrace)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MappingFailure() when $default != null:
        return $default(_that.message, _that.exception, _that.stackTrace);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String message, Object? exception, StackTrace? stackTrace)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MappingFailure():
        return $default(_that.message, _that.exception, _that.stackTrace);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String message, Object? exception, StackTrace? stackTrace)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MappingFailure() when $default != null:
        return $default(_that.message, _that.exception, _that.stackTrace);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MappingFailure extends MappingFailure implements AppExceptionMixin {
  const _MappingFailure(
      {required this.message, this.exception, this.stackTrace})
      : super._();

  @override
  final String message;
  @override
  final Object? exception;
  @override
  final StackTrace? stackTrace;

  /// Create a copy of MappingFailure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MappingFailureCopyWith<_MappingFailure> get copyWith =>
      __$MappingFailureCopyWithImpl<_MappingFailure>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MappingFailure &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other.exception, exception) &&
            (identical(other.stackTrace, stackTrace) ||
                other.stackTrace == stackTrace));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message,
      const DeepCollectionEquality().hash(exception), stackTrace);

  @override
  String toString() {
    return 'MappingFailure(message: $message, exception: $exception, stackTrace: $stackTrace)';
  }
}

/// @nodoc
abstract mixin class _$MappingFailureCopyWith<$Res>
    implements $MappingFailureCopyWith<$Res> {
  factory _$MappingFailureCopyWith(
          _MappingFailure value, $Res Function(_MappingFailure) _then) =
      __$MappingFailureCopyWithImpl;
  @override
  @useResult
  $Res call({String message, Object? exception, StackTrace? stackTrace});
}

/// @nodoc
class __$MappingFailureCopyWithImpl<$Res>
    implements _$MappingFailureCopyWith<$Res> {
  __$MappingFailureCopyWithImpl(this._self, this._then);

  final _MappingFailure _self;
  final $Res Function(_MappingFailure) _then;

  /// Create a copy of MappingFailure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
    Object? exception = freezed,
    Object? stackTrace = freezed,
  }) {
    return _then(_MappingFailure(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      exception: freezed == exception ? _self.exception : exception,
      stackTrace: freezed == stackTrace
          ? _self.stackTrace
          : stackTrace // ignore: cast_nullable_to_non_nullable
              as StackTrace?,
    ));
  }
}

// dart format on
