import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uv_pos/features/presentation/pages/order/order_list_screen.dart';
import 'package:uv_pos/features/presentation/pages/printer/printers_screen.dart';
import 'package:uv_pos/features/presentation/pages/product/product_list_screen.dart';
import 'package:uv_pos/features/presentation/pages/report/reports_screen.dart';
import 'package:uv_pos/features/presentation/pages/sale/sale_screen.dart';
import 'package:uv_pos/features/presentation/pages/setting/settings_screen.dart';
import 'package:uv_pos/features/presentation/pages/stock/stocks_screen.dart';
import 'package:uv_pos/features/presentation/widgets/home_menu_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<PopupMenuEntry<Widget>> popupMenuList = [
    const PopupMenuItem(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.language_outlined,
            color: Colors.blue,
          ),
          SizedBox(width: 10),
          Text(
            'Change Language',
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
        ],
      ),
    ),
    const PopupMenuItem(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RotatedBox(
            quarterTurns: 2,
            child: Icon(
              Icons.brightness_2,
              color: Colors.blue,
            ),
          ),
          SizedBox(width: 10),
          Text(
            'Toggle Theme',
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
        ],
      ),
    ),
    const PopupMenuItem(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.person,
            color: Colors.blue,
          ),
          SizedBox(width: 10),
          Text(
            'Update Profile',
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
        ],
      ),
    ),
    const PopupMenuItem(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.password,
            color: Colors.blue,
          ),
          SizedBox(width: 10),
          Text(
            'Change Password',
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
        ],
      ),
    ),
    const PopupMenuItem(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            // radius: 20,
            minRadius: 13,
            backgroundColor: Colors.blue,
            child: Icon(
              Icons.question_mark_rounded,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 10),
          Text(
            'Contact Us',
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
        ],
      ),
    ),
    const PopupMenuItem(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.logout,
            color: Colors.blue,
          ),
          SizedBox(width: 10),
          Text(
            'Logout',
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
        ],
      ),
    ),
  ];

  List<Widget> menuList(BuildContext context) => [
        HomeMenuItem(
          title: 'Sale',
          icon: Icons.shopping_bag,
          onTap: () => Navigator.push(
            context,
            Platform.isIOS
                ? CupertinoPageRoute(
                    builder: (_) => const SaleScreen(),
                  )
                : MaterialPageRoute(
                    builder: (_) => const SaleScreen(),
                  ),
          ),
        ),
        HomeMenuItem(
          title: 'Order List',
          icon: Icons.local_grocery_store,
          onTap: () => Navigator.push(
            context,
            Platform.isIOS
                ? CupertinoPageRoute(
                    builder: (_) => const OrderListScreen(),
                  )
                : MaterialPageRoute(
                    builder: (_) => const OrderListScreen(),
                  ),
          ),
        ),
        HomeMenuItem(
          title: 'Product List',
          icon: Icons.list,
          onTap: () => Navigator.push(
            context,
            Platform.isIOS
                ? CupertinoPageRoute(
                    builder: (_) => const ProductListScreen(),
                  )
                : MaterialPageRoute(
                    builder: (_) => const ProductListScreen(),
                  ),
          ),
        ),
        HomeMenuItem(
          title: 'Stocks',
          icon: Icons.add_shopping_cart_outlined,
          onTap: () => Navigator.push(
            context,
            Platform.isIOS
                ? CupertinoPageRoute(
                    builder: (_) => const StocksScreen(),
                  )
                : MaterialPageRoute(
                    builder: (_) => const StocksScreen(),
                  ),
          ),
        ),
        HomeMenuItem(
          title: 'Settings',
          icon: Icons.settings,
          onTap: () => Navigator.push(
            context,
            Platform.isIOS
                ? CupertinoPageRoute(
                    builder: (_) => const SettingsScreen(),
                  )
                : MaterialPageRoute(
                    builder: (_) => const SettingsScreen(),
                  ),
          ),
        ),
        HomeMenuItem(
          title: 'Printers',
          icon: Icons.print,
          onTap: () => Navigator.push(
            context,
            Platform.isIOS
                ? CupertinoPageRoute(
                    builder: (_) => const PrintersScreen(),
                  )
                : MaterialPageRoute(
                    builder: (_) => const PrintersScreen(),
                  ),
          ),
        ),
        HomeMenuItem(
          title: 'Report',
          icon: Icons.show_chart,
          onTap: () => Navigator.push(
            context,
            Platform.isIOS
                ? CupertinoPageRoute(
                    builder: (_) => const ReportsScreen(),
                  )
                : MaterialPageRoute(
                    builder: (_) => const ReportsScreen(),
                  ),
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Sulaymon O\'rinov (\$0)'),
        centerTitle: false,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => popupMenuList,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 70),
          child: ListTile(
            title: const Text(
              'Store 1',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
            subtitle: Text(
              'Sliver Monthly - 0/3000 - Exp: ${DateTime.now()}',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
            trailing: ElevatedButton(
              onPressed: () {},
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.switch_right,
                    size: 20,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Switch Store',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Wrap(
            spacing: 20,
            runSpacing: 20,
            children: menuList(context),
          ),
        ),
      ),
    );
  }
}
