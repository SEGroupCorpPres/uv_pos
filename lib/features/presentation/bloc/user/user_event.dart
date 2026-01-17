part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class CreateUserEvent extends UserEvent {
  final UserModel User;
  final String storeID;

  final File? imageFile;

  const CreateUserEvent(this.imageFile, {required this.User, required this.storeID});

  @override
  List<Object?> get props => [User, storeID, imageFile];
}

class UpdateUserEvent extends UserEvent {
  final UserModel user;
  final String storeID;

  final File? imageFile;

  const UpdateUserEvent(this.imageFile, {required this.user, required this.storeID});

  @override
  List<Object?> get props => [User, storeID];
}

class DeleteUserEvent extends UserEvent {
  final String userId;
  final String storeID;

  const DeleteUserEvent({required this.userId, required this.storeID});

  @override
  List<Object?> get props => [userId, storeID];
}

class FetchUserByIdEvent extends UserEvent {
  final String id;

  const FetchUserByIdEvent(this.id);

  @override
  List<Object?> get props => [id];
}
