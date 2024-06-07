import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uv_pos/app/presentation/pages/auth_flow.dart';

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
      child: const AuthFlow(),
      // child: RegistrationScreen(),
      // child: VerifyAuthScreen(verificationId: 'f'),
      // child: CheckEmailScreen(email: 'artessdu@gmail.com'),
    );
  }
}
