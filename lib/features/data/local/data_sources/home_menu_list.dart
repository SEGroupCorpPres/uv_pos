import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uv_pos/app/presentation/bloc/auth/app_bloc.dart';
import 'package:uv_pos/features/data/remote/models/store_model.dart';
import 'package:uv_pos/features/presentation/bloc/order/order_bloc.dart';
import 'package:uv_pos/features/presentation/bloc/product/product_bloc.dart';
import 'package:uv_pos/features/presentation/bloc/stock/stock_bloc.dart';
import 'package:uv_pos/features/presentation/widgets/home_menu_item.dart';

List<Widget> menuList(BuildContext context, StoreModel store) => [
      HomeMenuItem(
        title: 'Sale',
        icon: Icons.shopping_bag,
        onTap: () => context.read<AppBloc>().add(
              NavigateToSaleScreen(store),
            ),
      ),
      HomeMenuItem(
        title: 'Order List',
        icon: Icons.local_grocery_store,
        onTap: () {
          DateTime orderCreatedTime = DateTime.now();
          context.read<AppBloc>().add(
                NavigateToOrderListScreen(store),
              );
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
          context.read<AppBloc>().add(
                NavigateToProductListScreen(store),
              );
          context.read<ProductBloc>().add(LoadProductsEvent(store));
        },
      ),
      HomeMenuItem(
          title: 'Stocks',
          icon: Icons.add_shopping_cart_outlined,
          onTap: () {
            context.read<AppBloc>().add(NavigateToStockScreen());
            context.read<StockBloc>().add(FetchStockByStoreId(storeId: store.id));
          }),
      HomeMenuItem(
        title: 'Settings',
        icon: Icons.settings,
        onTap: () => context.read<AppBloc>().add(
              NavigateToSettingsScreen(),
            ),
      ),
      HomeMenuItem(
        title: 'Printers',
        icon: Icons.print,
        onTap: () => context.read<AppBloc>().add(
              NavigateToPrintersScreen(),
            ),
      ),
      HomeMenuItem(
        title: 'Report',
        icon: Icons.show_chart,
        onTap: () => context.read<AppBloc>().add(
              NavigateToReportsScreen(),
            ),
      ),
    ];
