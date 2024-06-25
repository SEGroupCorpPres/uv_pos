import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uv_pos/app/presentation/bloc/auth/app_bloc.dart';
import 'package:uv_pos/features/data/remote/models/product_model.dart';
import 'package:uv_pos/features/presentation/pages/product/create_product_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});
  static Page page() => Platform.isIOS
      ? const CupertinoPage(
    child: ProductListScreen(),
  )
      : const MaterialPage(
    child: ProductListScreen(),
  );

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late ProductModel? productModel;
  List<Map<String, dynamic>> productList = [
    {
      'name': 'Product 1',
      'price': 1.1,
      'quantity': 1,
      'image': 'Image 1',
    },
    {
      'name': 'Product 2',
      'price': 2.2,
      'quantity': 2,
      'image': 'Image 2',
    },
    {
      'name': 'Product 3',
      'price': 3.3,
      'quantity': 3,
      'image': 'Image 3',
    },
    {
      'name': 'Product 4',
      'price': 4.4,
      'quantity': 4,
      'image': 'Image 4',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: InkWell(
          onTap: () => BlocProvider.of<AppBloc>(context).add(
            NavigateToHomeScreen(),
          ),
          child: Icon(Icons.adaptive.arrow_back),
        ),
        title: const Text('Product List (0/0)'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.sync_problem),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        itemCount: productList.length,
        itemBuilder: (context, item) {
          final String name = productList[item]['name'];
          final double price = productList[item]['price'];
          final int qty = productList[item]['quantity'];
          final String image = productList[item]['image'];
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(color: Colors.yellowAccent, borderRadius: BorderRadius.circular(20)),
                margin: const EdgeInsets.only(bottom: 10),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Price: \$$price',
                    style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Quantity: $qty',
                    style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ],
              )
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>BlocProvider.of<AppBloc>(context).add(
          const NavigateToCreateProductScreen(),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
