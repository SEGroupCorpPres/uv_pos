import 'dart:io';

import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uv_pos/app/presentation/bloc/auth/app_bloc.dart';
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
  List<Map<String, dynamic>> storeList = [
    {
      'name': 'Store 1',
      'phone': 'Phone 1',
      'image': 'Image 1',
      'address': 'Address 1',
      'description': 'Description 1',
    },
    {
      'name': 'Store 2',
      'phone': 'Phone 2',
      'image': 'Image 2',
      'address': 'Address 2',
      'description': 'Description 2',
    },
    {
      'name': 'Store 3',
      'phone': 'Phone 3',
      'image': 'Image 3',
      'address': 'Address 3',
      'description': 'Description 3',
    },
    {
      'name': 'Store 4',
      'phone': 'Phone 4',
      'image': 'Image 4',
      'address': 'Address 4',
      'description': 'Description 4',
    },
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          labelStyle: const TextStyle(fontSize: 16),
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
              BlocProvider.of<AppBloc>(context).add(AuthLoggedOut());
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
                      final storeItemId = storeList[item].id;
                      final storeItemName = storeList[item].name;
                      final storeItemPhone = storeList[item].phone;
                      final storeItemImage = storeList[item].imageUrl;
                      final storeItemAddress = storeList[item].address;
                      final storeItemDescription = storeList[item].description;
                      return CupertinoListTile(
                        onTap: () => BlocProvider.of<AppBloc>(context)..add(NavigateToHomeScreen(storeList[item])),
                        leadingSize: 60,
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(storeItemImage!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: RichText(
                          text: TextSpan(
                            text: storeItemName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            children: const [
                              TextSpan(
                                text: '  (Store Owner)',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                        subtitle: Text(
                          storeItemPhone,
                          style: const TextStyle(
                            fontSize: 16,
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
                  print('no state');
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
    );
  }
}
