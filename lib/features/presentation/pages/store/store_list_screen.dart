import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uv_pos/app/presentation/bloc/auth/app_bloc.dart';
import 'package:uv_pos/features/data/remote/models/store_model.dart';
import 'package:uv_pos/features/domain/repositories/store_repository.dart';
import 'package:uv_pos/features/presentation/pages/store/add_edit_store_screen.dart';

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
        title: const Text('Store List'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.autorenew),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
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
          builder: (context, state) {
            return ListView.builder(
              itemCount: storeList.length,
              itemBuilder: (context, item) {
                final storeItemName = storeList[item]['name'];
                final storeItemPhone = storeList[item]['phone'];
                final storeItemImage = storeList[item]['phone'];
                final storeItemAddress = storeList[item]['address'];
                final storeItemDescription = storeList[item]['description'];
                return CupertinoListTile(
                  leadingSize: 60,
                  leading: Container(
                    width: 50,
                    height: 50,
                    color: Colors.redAccent,
                  ),
                  title: RichText(
                    text: TextSpan(
                      text: '$storeItemName',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
                      children: const [
                        TextSpan(
                          text: '(Store Owner)',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.blueAccent),
                        ),
                      ],
                    ),
                  ),
                  subtitle: Text(
                    '$storeItemPhone',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
                  ),
                  trailing: IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      Platform.isIOS
                          ? CupertinoPageRoute(
                              builder: (_) => AddEditStoreScreen(
                                storeNameTextEditingController: storeItemName,
                                storeDescriptionTextEditingController: storeItemDescription,
                                storePhoneTextEditingController: storeItemPhone,
                                storeAddressTextEditingController: storeItemAddress,
                                storeImage: storeItemImage,
                              ),
                            )
                          : MaterialPageRoute(
                              builder: (_) => AddEditStoreScreen(
                                storeNameTextEditingController: storeItemName,
                                storeDescriptionTextEditingController: storeItemDescription,
                                storePhoneTextEditingController: storeItemPhone,
                                storeAddressTextEditingController: storeItemAddress,
                                storeImage: storeItemImage,
                              ),
                            ),
                    ),
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.black,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => BlocProvider.of<AppBloc>(context).add(
          NavigateToAddEditStoreScreen(),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
