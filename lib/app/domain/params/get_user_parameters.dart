import 'package:uv_pos/core/core.dart';

class GetUserParameters extends Equatable {
  const GetUserParameters({required this.uid});

  final String uid;

  @override
  List<Object?> get props => [uid];
}
