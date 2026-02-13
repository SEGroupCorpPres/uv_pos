import 'package:uv_pos/core/core.dart';

class DeleteUserParameters extends Equatable {
  const DeleteUserParameters({required this.uid});

  final String uid;

  @override
  List<Object?> get props => [uid];
}
