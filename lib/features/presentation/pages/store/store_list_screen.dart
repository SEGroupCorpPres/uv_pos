import 'dart:io';

import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uv_pos/app/presentation/bloc/auth/app_bloc.dart';
import 'package:uv_pos/core/helpers/session_ending.dart';
import 'package:uv_pos/features/data/remote/models/store_model.dart';
import 'package:uv_pos/features/domain/repositories/store_repository.dart';
import 'package:uv_pos/features/presentation/bloc/store/store_bloc.dart';

class StoreListScreen extends StatefulWidget {
  const StoreListScreen({super.key});

  static Page page() => Platform.isIOS
      ? const CupertinoPage(
          child: StoreListScreen(),
        )
      : const MaterialPage(
          child: StoreListScreen(),
        );

  @override
  State<StoreListScreen> createState() => _StoreListScreenState();
}

class _StoreListScreenState extends State<StoreListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final StoreRepository storeRepository = StoreRepository();

  //
  final List<StoreModel> _searchList = [];
  List<StoreModel> _list = [];
  bool _isSearching = false;
  String uid = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUID();
  }

  Future<void> getUID() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    uid = sharedPreferences.getString('uid')!;
  }

  SessionEnding sessionEnding = SessionEnding();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, result) {
        if (didPop) {
          return;
        }
        sessionEnding.onWillPop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: AnimatedSearchBar(
            label: "Store list",
            controller: _searchController,
            onChanged: (value) {
              _searchList.clear();
              for (var i in _list) {
                if (i.name.toLowerCase().contains(value.toLowerCase())) {
                  _searchList.add(i);
                }
                setState(() {
                  _searchList;
                  _isSearching = true;
                });
              }
            },
            labelStyle: TextStyle(fontSize: 16.sp),
            cursorColor: Colors.black,
            textInputAction: TextInputAction.done,
            searchDecoration: const InputDecoration(
              hintText: 'Search',
              alignLabelWithHint: true,
              fillColor: Colors.white,
              focusColor: Colors.white,
              hintStyle: TextStyle(color: Colors.black),
              border: InputBorder.none,
            ),
          ),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () => BlocProvider.of<StoreBloc>(context).add(LoadStoresEvent()),
              icon: const Icon(Icons.autorenew),
            ),
            IconButton(
              onPressed: () {
                showAdaptiveDialog(
                  context: context,
                  builder: (contex) {
                    return buildAlertDialog(contex);
                  },
                );
                // BlocProvider.of<AppBloc>(context).add(AuthLoggedOut());
              },
              icon: const Icon(Icons.power_settings_new),
            ),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<AppBloc, AppState>(
            buildWhen: (appPrev, appCurrent) => appPrev.user == appCurrent.user,
            builder: (context, appState) {
              return BlocBuilder<StoreBloc, StoreState>(
                buildWhen: (prev, current) => prev != current,
                builder: (context, state) {
                  List<StoreModel> storeList = [];
                  if (state is StoresByUIDLoaded) {
                    _list = state.stores!;
                    storeList = _isSearching ? _searchList : _list;
                    storeList.sort((a, b) => b.name.compareTo(a.name));
                    return ListView.builder(
                      itemCount: storeList.length,
                      itemBuilder: (context, item) {
                        final storeItemName = storeList[item].name;
                        final storeItemPhone = storeList[item].phone;
                        final storeItemImage = storeList[item].imageUrl;
                        return CupertinoListTile(
                          onTap: () async {
                            BlocProvider.of<AppBloc>(context).add(NavigateToHomeScreen(storeList[item]));
                            BlocProvider.of<StoreBloc>(context).add(FetchStoreByIdEvent(storeList[item]));
                            SharedPreferences preferences = await SharedPreferences.getInstance();
                            await preferences.setString('store_id', storeList[item].id);
                          },
                          leadingSize: 60,
                          leading: Container(
                            width: 45.r,
                            height: 45.r,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10).r,
                              image: DecorationImage(
                                image: NetworkImage(storeItemImage!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: RichText(
                            text: TextSpan(
                              text: storeItemName,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text: '  (Store Owner)',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          subtitle: Text(
                            storeItemPhone,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () => BlocProvider.of<AppBloc>(context).add(
                              NavigateToAddEditStoreScreen(_list[item], true),
                            ),
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.black,
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is StoreNotFound) {
                    return const Center(
                      child: Text('No record found'),
                    );
                  } else if (state is StoreLoading) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  } else if (state is StoreError) {
                    if (kDebugMode) {
                      print('no state');
                    }
                    return const Center(
                      child: Text('Error'),
                    );
                  } else {
                    BlocProvider.of<StoreBloc>(context).add(LoadStoresEvent());
                    return const Center(
                      child: Text('Nothing'),
                    );
                  }
                },
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => BlocProvider.of<AppBloc>(context).add(
            const NavigateToAddEditStoreScreen(),
          ),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  AlertDialog buildAlertDialog(BuildContext context) {
    return AlertDialog.adaptive(
      icon: Icon(
        Icons.logout,
        size: 30.sp,
      ),
      content: Text(
        'Accountdan chiqishni hohlaysizmi ?',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20.sp),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey, minimumSize: Size(100.w, 40.h)),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<AppBloc>(context).add(AuthLoggedOut());
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, minimumSize: Size(100.w, 40.h)),
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
