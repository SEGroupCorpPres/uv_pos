import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uv_pos/app/presentation/bloc/auth/app_bloc.dart';
import 'package:uv_pos/features/data/local/data_sources/home_menu_list.dart';
import 'package:uv_pos/features/data/local/data_sources/popup_menu_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static Page page() => Platform.isIOS
      ? const CupertinoPage(
          child: HomeScreen(),
        )
      : const MaterialPage(
          child: HomeScreen(),
        );

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
              onPressed: () => BlocProvider.of<AppBloc>(context).add(
                NavigateToStoreListScreen(),
              ),
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
