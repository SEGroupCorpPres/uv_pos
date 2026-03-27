import 'package:future_pos/app/app.dart';
import 'package:future_pos/core/core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/config/.env');
  await PrefHelper.init();
  Bloc.observer = AppBlocObserver();

  runApp(
    MultiBlocProvider(
      providers: [],
      child: const App(),
    ),
  );
}
