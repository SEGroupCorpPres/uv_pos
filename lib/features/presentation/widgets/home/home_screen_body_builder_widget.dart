import 'package:flutter/material.dart';
import 'home.dart';

class HomeScreenBodyBuilderWidget extends StatelessWidget {
  const HomeScreenBodyBuilderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreBloc, StoreState>(
      builder: body_builder,
    );
  }

  Widget body_builder(BuildContext context, StoreState state) {
    if (state is StoreLoading) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    } else if (state is StoreByIdLoaded) {
      StoreModel store = state.store;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0).w,
        child: SingleChildScrollView(
          child: Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: menuList(context, store),
          ),
        ),
      );
    } else if (state is StoreNotFound) {
      return ErrorWidget('Store Not found');
    } else {
      return Container();
    }
  }
}
