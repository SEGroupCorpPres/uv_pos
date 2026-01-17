import 'package:uv_pos/core/core.dart';

import 'presentation/pages/pages.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.deepPurpleAccent,
            iconTheme: const IconThemeData(
              color: Colors.deepPurple,
            ),
            primaryIconTheme: const IconThemeData(
              color: Colors.deepPurple,
            ),
            useMaterial3: true,
          ),
          home: child,
        );
      },
      // child: MyApp(),
      child: const AuthFlow(),
    );
  }
}
