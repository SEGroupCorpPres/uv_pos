import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uv_pos/features/presentation/pages/store/add_edit_store_screen.dart';

class StoreListScreen extends StatefulWidget {
  const StoreListScreen({super.key});

  @override
  State<StoreListScreen> createState() => _StoreListScreenState();
}

class _StoreListScreenState extends State<StoreListScreen> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // leading: InkWell(
        //   onTap: () => Navigator.pop(context),
        //   child: Icon(Icons.adaptive.arrow_back),
        // ),
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
            onPressed: () {},
            icon: const Icon(Icons.power_settings_new),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          Platform.isIOS
              ? CupertinoPageRoute(
                  builder: (_) => const AddEditStoreScreen(),
                )
              : MaterialPageRoute(
                  builder: (_) => const AddEditStoreScreen(),
                ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
