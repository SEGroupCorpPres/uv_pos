import 'package:flutter/material.dart';

import 'package:future_pos/core/core.dart';
import 'package:future_pos/app/presentation/widgets/home_menu_item.dart';

List<Widget> menuList(BuildContext context) => [
      HomeMenuItem(
        title: 'Sale',
        icon: Icons.shopping_bag,
        onTap: () {},
      ),
      HomeMenuItem(
        title: 'Order List',
        icon: Icons.local_grocery_store,
        onTap: () {
          DateTime orderCreatedTime = DateTime.now();
        },
      ),
      HomeMenuItem(
        title: 'Product List',
        icon: Icons.list,
        onTap: () {},
      ),
      HomeMenuItem(
          title: 'Stocks',
          icon: Icons.add_shopping_cart_outlined,
          onTap: () {}),
      HomeMenuItem(
        title: 'Settings',
        icon: Icons.settings,
        onTap: () {},
      ),
      HomeMenuItem(
        title: 'Printers',
        icon: Icons.print,
        onTap: () {},
      ),
      HomeMenuItem(
        title: 'Report',
        icon: Icons.show_chart,
        onTap: () {},
      ),
    ];
