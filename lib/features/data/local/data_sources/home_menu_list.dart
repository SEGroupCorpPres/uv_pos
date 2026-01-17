import 'package:flutter/material.dart';

import 'data_sources.dart';

List<Widget> menuList(BuildContext context, StoreModel store) => [
      HomeMenuItem(
        title: 'Sale',
        icon: Icons.shopping_bag,
        onTap: () {
          context.read<AppBloc>().add(NavigateToSaleScreen(storeID: store.id));
          context.read<ProductBloc>().add(LoadProductsEvent(storeID: store.id));
        },
      ),
      HomeMenuItem(
        title: 'Order List',
        icon: Icons.local_grocery_store,
        onTap: () {
          DateTime orderCreatedTime = DateTime.now();
          context.read<AppBloc>().add(NavigateToOrderListScreen(store));
          context.read<OrderBloc>().add(
                LoadOrdersEvent(
                  store.id,
                  orderCreatedTime,
                ),
              );
        },
      ),
      HomeMenuItem(
        title: 'Product List',
        icon: Icons.list,
        onTap: () {
          context.read<AppBloc>().add(NavigateToProductListScreen(storeID: store.id));
          context.read<ProductBloc>().add(LoadProductsEvent(storeID: store.id));
        },
      ),
      HomeMenuItem(
          title: 'Stocks',
          icon: Icons.add_shopping_cart_outlined,
          onTap: () {
            context.read<AppBloc>().add(NavigateToStocksScreen(storeID: store.id));
            context.read<StockBloc>().add(LoadStocksEvent(storeID: store.id));
          }),
      HomeMenuItem(
        title: 'Settings',
        icon: Icons.settings,
        onTap: () => context.read<AppBloc>().add(NavigateToSettingsScreen()),
      ),
      HomeMenuItem(
        title: 'Printers',
        icon: Icons.print,
        onTap: () => context.read<AppBloc>().add(NavigateToPrintersScreen()),
      ),
      HomeMenuItem(
        title: 'Report',
        icon: Icons.show_chart,
        onTap: () => context.read<AppBloc>().add(NavigateToReportsScreen()),
      ),
    ];
