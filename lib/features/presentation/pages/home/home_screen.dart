import 'package:flutter/material.dart';
import 'package:uv_pos/features/presentation/pages/home/home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static Page page() => const MaterialPage(
        child: HomeScreen(),
      );

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SessionEnding sessionEnding = SessionEnding();

  void sessionEnd(bool didPop, result) {
    if (didPop) {
      return;
    }
    sessionEnding.onWillPop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (BuildContext context, AppState appState) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: sessionEnd,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  log(state.toString());
                  if (state is UserLoadingState) {
                    return const CircularProgressIndicator();
                  }
                  if (state is UserErrorState) {
                    return Text(state.error);
                  }
                  if (state is UserLoadedState) {
                    return Text('${state.user.displayName} (\$0)');
                  }
                  return const Text('Home');
                },
              ),
              centerTitle: false,
              actions: homeActions(context),
              bottom: PreferredSize(
                preferredSize: Size(double.infinity, 60.h),
                child: HomeScreenSelectedStoreBuilderWidget(),
              ),
            ),
            body: HomeScreenBodyBuilderWidget(),
          ),
        );
      },
    );
  }
}
