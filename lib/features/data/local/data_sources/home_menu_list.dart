import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uv_pos/app/presentation/bloc/auth/app_bloc.dart';
import 'package:uv_pos/features/data/remote/models/store_model.dart';
import 'package:uv_pos/features/presentation/widgets/home_menu_item.dart';

List<Widget> menuList(BuildContext context, StoreModel store) => [
  HomeMenuItem(
    title: 'Sale',
    icon: Icons.shopping_bag,
    onTap: () => BlocProvider.of<AppBloc>(context).add(
      NavigateToSaleScreen(store),
    ),
  ),
  HomeMenuItem(
    title: 'Order List',
    icon: Icons.local_grocery_store,
    onTap: () => BlocProvider.of<AppBloc>(context).add(
      NavigateToOrderListScreen(store),
    ),
  ),
  HomeMenuItem(
    title: 'Product List',
    icon: Icons.list,
    onTap: () => BlocProvider.of<AppBloc>(context).add(
      NavigateToProductListScreen(store),
    ),
  ),
  HomeMenuItem(
    title: 'Stocks',
    icon: Icons.add_shopping_cart_outlined,
    onTap: () => BlocProvider.of<AppBloc>(context).add(
      NavigateToStockScreen(),
    ),
  ),
  HomeMenuItem(
    title: 'Settings',
    icon: Icons.settings,
    onTap: () => BlocProvider.of<AppBloc>(context).add(
      NavigateToSettingsScreen(),
    ),
  ),
  HomeMenuItem(
    title: 'Printers',
    icon: Icons.print,
    onTap: () => BlocProvider.of<AppBloc>(context).add(
      NavigateToPrintersScreen(),
    ),
  ),
  HomeMenuItem(
    title: 'Report',
    icon: Icons.show_chart,
    onTap: () => BlocProvider.of<AppBloc>(context).add(
      NavigateToReportsScreen(),
    ),
  ),
];
