import 'dart:io';

import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uv_pos/app/presentation/bloc/auth/app_bloc.dart';
import 'package:uv_pos/features/data/remote/models/product_model.dart';
import 'package:uv_pos/features/data/remote/models/store_model.dart';
import 'package:uv_pos/features/presentation/bloc/product/product_bloc.dart';

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
  final TextEditingController _searchController = TextEditingController();
  List<ProductModel> products = [];
  late StoreModel? store;
  final List<ProductModel> _searchList = [];
  bool _isSearching = false;
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
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, appState) {
        if (appState.store != null) {
          store = appState.store;
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              leading: InkWell(
                onTap: () => BlocProvider.of<AppBloc>(context).add(
                  NavigateToHomeScreen(store),
                ),
                child: Icon(Icons.adaptive.arrow_back),
              ),
              title: AnimatedSearchBar(
                label: "Product list",
                controller: _searchController,
                onChanged: (value) {
                  _searchList.clear();
                  for (var i in products) {
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
                  onPressed: () {},
                  icon: const Icon(Icons.sync_problem),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
            body: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else if (state is ProductsByStoreIdLoaded) {
                  products = state.products!;
                  List<ProductModel> productList = [];
                  productList = _isSearching ? _searchList : products;
                  productList.sort((a, b) => b.name.compareTo(a.name));
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    itemCount: productList.length,
                    itemBuilder: (context, item) {
                      final String name = productList[item].name;
                      final double price = productList[item].price;
                      final int qty = productList[item].notifyQuantity;
                      final String image = productList[item].image!;
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.yellowAccent,
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(image: NetworkImage(image), fit: BoxFit.cover),
                            ),
                            margin: const EdgeInsets.only(bottom: 10),
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Price: \$$price',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Quantity: $qty',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                } else if (state is ProductNotFound) {
                  return const Center(
                    child: Text('No record found'),
                  );
                } else if (state is ProductError) {
                  return const Center(
                    child: Text('Error'),
                  );
                } else {
                  return const Center(
                    child: Text('No record found'),
                  );
                }
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => BlocProvider.of<AppBloc>(context).add(
                NavigateToCreateProductScreen(
                  null,
                  null,
                  false,
                  store,
                ),
              ),
              child: const Icon(Icons.add),
            ),
          );
        } else {
          return const Center(
            child: Text('Error'),
          );
        }
      },
    );
  }
}
