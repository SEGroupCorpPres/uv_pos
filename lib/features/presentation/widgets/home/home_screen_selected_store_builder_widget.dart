import 'package:flutter/material.dart';
import 'home.dart';

class HomeScreenSelectedStoreBuilderWidget extends StatelessWidget {
  const HomeScreenSelectedStoreBuilderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreBloc, StoreState>(
      builder: selected_store_builder,
    );
  }

  Widget selected_store_builder(BuildContext context, StoreState state) {
    if (state is StoreLoading) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    } else if (state is StoreByIdLoaded) {
      StoreModel store = state.store;
      return SelectedStore(store: store);
    } else if (state is StoreNotFound) {
      return ErrorScreen(message: 'Store Not found');
    } else {
      return Container();
    }
  }
}
