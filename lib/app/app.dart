import 'package:future_pos/app/app_barrel.dart';
import 'package:future_pos/core/core.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  AppRouter appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(
        AppSizesConstants.defaultScreenWidth,
        AppSizesConstants.defaultScreenHeight,
      ),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return child!;
      },
      child: BlocBuilder<LocalizationCubit, LocalizationState>(
        builder: (context, state) {
          return MaterialApp.router(
            builder: (context, child) => ToastificationConfigProvider(
              config: const ToastificationConfig(
                alignment: Alignment.topCenter,
                itemWidth: 440,
                animationDuration: Duration(milliseconds: 500),
                blockBackgroundInteraction: false,
              ),
              child: child!,
            ),
            // debugShowCheckedModeBanner: true,
            // scaffoldMessengerKey: rootScaffoldMessengerKey,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            title: 'Future Pos',
            theme: AppThemes.dark(),
            routerConfig: appRouter.router,
          );
        },
      ),
    );
  }
}
