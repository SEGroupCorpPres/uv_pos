// main.dart
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uv_pos/app/presentation/bloc/auth/auth_bloc.dart';
import 'package:uv_pos/app/presentation/pages/check_email_screen.dart';
import 'package:uv_pos/app/presentation/pages/loading_screen.dart';
import 'package:uv_pos/app/presentation/pages/login_screen.dart';
import 'package:uv_pos/features/presentation/pages/store/store_list_screen.dart';

class AuthFlow extends StatelessWidget {
  const AuthFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return FlowBuilder<AuthState>(
          state: state,
          onGeneratePages: onGenerateAuthPages,
        );
      },
    );
  }
}

List<Page> onGenerateAuthPages(AuthState state, List<Page> pages) {
  switch (state.status) {
    case AuthStatus.unauthenticated:
      return [LoginScreen.page()];
    case AuthStatus.authenticated:
      return [StoreListScreen.page()];
    case AuthStatus.loading:
      return [LoadingScreen.page()];
    case AuthStatus.emailVerification:
      return [CheckEmailScreen.page(state.email!)];
    default:
      return [LoadingScreen.page()];
  }
}

// class AuthRouter extends StatelessWidget {
//   const AuthRouter({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<AuthBloc, AuthState>(
//       listener: (context, state) {
//         if (state is AuthUnauthenticated) {
//           Navigator.of(context).pushReplacement(
//             Platform.isIOS
//                 ? CupertinoPageRoute(
//                     builder: (_) => const LoginScreen(),
//                   )
//                 : MaterialPageRoute(
//                     builder: (_) => const LoginScreen(),
//                   ),
//           );
//         } else if (state is AuthAuthenticated) {
//           Navigator.of(context).pushReplacement(
//             Platform.isIOS
//                 ? CupertinoPageRoute(
//                     builder: (_) => const StoreListScreen(),
//                   )
//                 : MaterialPageRoute(
//                     builder: (_) => const StoreListScreen(),
//                   ),
//           );
//         } else if (state is AuthLoading) {
//           Navigator.of(context).pushReplacement(
//             Platform.isIOS
//                 ? CupertinoPageRoute(
//                     builder: (_) => const LoadingScreen(),
//                   )
//                 : MaterialPageRoute(
//                     builder: (_) => const LoadingScreen(),
//                   ),
//           );
//         } else if (state is AuthCodeSent) {
//           Navigator.of(context).pushReplacement(
//             Platform.isIOS
//                 ? CupertinoPageRoute(
//                     builder: (_) => VerifyAuthScreen(verificationId: state.verificationId),
//                   )
//                 : MaterialPageRoute(
//                     builder: (_) => VerifyAuthScreen(verificationId: state.verificationId),
//                   ),
//           );
//         } else if (state is AuthEmailVerification) {
//           // Navigate to a screen that instructs the user to check their email
//           Navigator.of(context).pushReplacement(
//             Platform.isIOS
//                 ? CupertinoPageRoute(
//                     builder: (_) => CheckEmailScreen(email: state.email),
//                   )
//                 : MaterialPageRoute(
//                     builder: (_) => CheckEmailScreen(email: state.email),
//                   ),
//           );
//         }
//       },
//       child: const Scaffold(
//         body: Center(
//           child: CircularProgressIndicator.adaptive(), // Initial loading screen
//         ),
//       ),
//     );
//   }
// }
