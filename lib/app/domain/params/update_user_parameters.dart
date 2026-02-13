import 'package:uv_pos/core/core.dart';

class UpdateUserParameters extends Equatable {
  const UpdateUserParameters({required this.uid, this.displayName, this.photoUrl});

  final String uid;
  final String? displayName;
  final String? photoUrl;

  @override
  List<Object?> get props => [uid, displayName, photoUrl];
}
