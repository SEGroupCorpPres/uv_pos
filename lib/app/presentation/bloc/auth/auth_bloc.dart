import 'package:uv_pos/core/core.dart';

// Events
part 'app_event.dart';
// States
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc(super.initialState);
}
