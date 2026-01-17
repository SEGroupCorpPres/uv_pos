import '../bloc.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc(this._userRepository) : super(UserInitialState()) {
    on<FetchUserByIdEvent>(_fetchUserDataByID);
  }

  final UserRepository _userRepository;

//   fetch user data by id
  Future<void> _fetchUserDataByID(FetchUserByIdEvent event, Emitter<UserState> emit) async {
    emit(UserLoadingState());
    try {
      final user = await _userRepository.getUser();
      emit(UserLoadedState(user!));
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }

//   update user data

  Future<void> _updateUser(UpdateUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoadingState());
    try {
      final user = event.user;
      await _userRepository.updateUser(user);
      emit(UserUpdateState(user));
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }
}
