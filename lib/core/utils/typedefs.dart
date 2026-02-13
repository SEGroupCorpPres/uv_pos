import 'package:dartz/dartz.dart';
import 'package:uv_pos/core/errors/failures.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;
typedef DataMap = Map<String, dynamic>;
typedef DataList = List<DataMap>;
typedef ResultVoid = ResultFuture<void>;
