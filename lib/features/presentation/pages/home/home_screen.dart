import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uv_pos/app/presentation/bloc/auth/app_bloc.dart';
import 'package:uv_pos/core/helpers/session_ending.dart';
import 'package:uv_pos/features/data/local/data_sources/home_menu_list.dart';
import 'package:uv_pos/features/data/local/data_sources/popup_menu_list.dart';
import 'package:uv_pos/features/data/remote/models/store_model.dart';
import 'package:uv_pos/features/presentation/bloc/store/store_bloc.dart';

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
  SessionEnding sessionEnding = SessionEnding();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, appState) {
        return BlocConsumer<StoreBloc, StoreState>(
          listener: (context, storeState) {},
          builder: (context, state) {
            if (state is StoreLoading) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else if (state is StoreByIdLoaded) {
              StoreModel store = state.store;
              return PopScope(
                canPop: false,
                onPopInvoked: (bool didPop) {
                  sessionEnding.onWillPop(context);
                },
                child: Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    title: Text('${appState.user!.displayName} (\$0)'),
                    centerTitle: false,
                    actions: [
                      PopupMenuButton(
                        itemBuilder: (context) => popupMenuList,
                      ),
                    ],
                    bottom: PreferredSize(
                      preferredSize: Size(double.infinity, 60.h),
                      child: ListTile(
                        title: Text(
                          store.name,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 15.sp,
                          ),
                        ),
                        subtitle: Text(
                          'Sliver Monthly - 0/3000 - Exp: ${DateTime.now()}',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                          ),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () => BlocProvider.of<AppBloc>(context).add(
                            NavigateToStoreListScreen(),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.switch_right,
                                size: 20.sp,
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                'Switch Store',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0).w,
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 10.w,
                        runSpacing: 10.h,
                        children: menuList(context, store),
                      ),
                    ),
                  ),
                ),
              );
            } else if (state is StoreNotFound) {
              return const Center(
                child: Text('No record found'),
              );
            } else {
              return Container();
            }
          },
        );
      },
    );
  }
}
