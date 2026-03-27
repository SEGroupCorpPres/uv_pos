import 'package:future_pos/core/core.dart';
import 'package:future_pos/features/features.dart';

Page<dynamic> _defaultPageBuilder(Widget child, GoRouterState state) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      final tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      final offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}

class AppRouter {
  AppRouter() {
    router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: AppRouteConstants.login,
      // initialLocation: AppRouteConstants.register,
      // initialLocation: AppRouteConstants.home,
      // initialLocation: AppRouteConstants.paint,
      redirect: _redirect,
      // refreshListenable: GoRouterRefreshStream(authBloc.stream),
      routes: [
        // GoRoute(
        //   path: AppRouteConstants.home,
        //   pageBuilder: (context, state) => _defaultPageBuilder(const HomePage(), state),
        // ),
        // GoRoute(
        //   path: AppRouteConstants.paint,
        //   pageBuilder: (context, state) {
        //     return _defaultPageBuilder(AddEditPaintPage(), state);
        //   },
        // ),
        // GoRoute(
        //   path: AppRouteConstants.login,
        //   builder: (context, state) {
        //     return LoginPage();
        //   },
        // ),
        // GoRoute(
        //   path: AppRouteConstants.register,
        //   builder: (context, state) {
        //     return RegistrationPage();
        //   },
        // ),
      ],
    );
  }
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  // final AuthBloc authBloc;
  late final GoRouter router;

  // static GoRouter goRouter
  String? _redirect(BuildContext context, GoRouterState state) {
    // final authState = sl<AuthBloc>().state; // context.read o'rniga to'g'ridan-to'g'ri authBloc
    final currentLocation = state.matchedLocation;
    // final user = sl<FirebaseAuth>().currentUser;
    // logger.log(Level.info, authState);
    // // Auth tekshiruvi boshlang'ich holatda bo'lsa, splash da qoladi
    // if (state is AuthInitialState || state is AuthLoadingState) {
    //   return null; // splash da qolish
    // }
    // if (user != null && currentLocation == AppRouteConstants.login) {
    //   return AppRouteConstants.home;
    // }
    // if ((state is CreatePaintState || state is UpdatePaintState || state is DeletePaintState) &&
    //     currentLocation == AppRouteConstants.home) {
    //   return AppRouteConstants.home;
    // }
    // if (user == null && currentLocation == AppRouteConstants.home) {
    //   return AppRouteConstants.login;
    // }
    // //
    // if (state is AuthStatus) {
    //   if (state is AuthSignedOutState) {
    //     log('redirect to login');
    //     return AppRouteConstants.login;
    //   } else {
    //     log('redirect to home');
    //     return AppRouteConstants.home;
    //   }
    // }
    //
    // if (state is AuthErrorState || state is AuthSignedOutState || state is AuthSignedUpState) {
    //   log('redirect to login via error');
    //
    //   // Xatolik bo'lsa login sahifaga
    //   return AppRouteConstants.login;
    // }
    return null; // redirect yo'q
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription =
        stream.asBroadcastStream().listen((dynamic _) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  Future<void> dispose() async {
    await _subscription.cancel();
    super.dispose();
  }
}
