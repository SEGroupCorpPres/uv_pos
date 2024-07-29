import 'dart:io';

import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
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
  NumberFormat formatAmount = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
  );

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
    final Size size = MediaQuery.sizeOf(context);
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
                  onPressed: () {
                    BlocProvider.of<ProductBloc>(context).add(LoadProductsEvent(store));
                  },
                  icon: const Icon(Icons.sync_problem),
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
                  if (state.products != null) {
                    products = state.products!;
                    List<ProductModel> productList = [];
                    productList = _isSearching ? _searchList : products;
                    productList.sort((a, b) => b.name.compareTo(a.name));
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20).r,
                      itemCount: productList.length,
                      itemBuilder: (context, item) {
                        final String name = productList[item].name;
                        final double price = productList[item].price;
                        final int qty = productList[item].quantity;
                        final String? image = productList[item].image;
                        return Slidable(
                          // Specify a key if the Slidable is dismissible.
                          key: const ValueKey(0),

                          // The start action pane is the one at the left or the top side.
                          startActionPane: ActionPane(
                            // A motion is a widget used to control how the pane animates.
                            motion: const ScrollMotion(),

                            // A pane can dismiss the Slidable.
                            dismissible: DismissiblePane(onDismissed: () {}),

                            // All actions are defined in the children parameter.
                            children: [
                              // A SlidableAction can have an icon and/or a label.
                              SlidableAction(
                                onPressed: (context) => BlocProvider.of<AppBloc>(context).add(
                                  NavigateToCreateProductScreen(
                                    productList[item],
                                    productList[item].barcode,
                                    true,
                                    store,
                                  ),
                                ),
                                backgroundColor: Colors.orangeAccent,
                                foregroundColor: Colors.white,
                                icon: Icons.edit,
                                label: 'Edit',
                              ),
                            ],
                          ),

                          // The end action pane is the one at the right or the bottom side.
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                // An action can be bigger than the others.
                                flex: 2,
                                onPressed: (context) => BlocProvider.of<ProductBloc>(context).add(
                                  DeleteProductEvent(productList[item].id, store!),
                                ),
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),

                          // The child of the Slidable is what the user sees when the
                          // component is not dragged.
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              image != null
                                  ? Container(
                                      width: 120.r,
                                      height: 120.r,
                                      decoration: BoxDecoration(
                                        color: Colors.yellowAccent,
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(image: NetworkImage(image), fit: BoxFit.cover),
                                      ),
                                      margin: const EdgeInsets.only(bottom: 10).h,
                                    )
                                  : Container(
                                      width: 120.r,
                                      height: 120.r,
                                      decoration: BoxDecoration(
                                        color: Colors.yellowAccent,
                                        borderRadius: BorderRadius.circular(20).r,
                                      ),
                                      margin: const EdgeInsets.only(bottom: 10).h,
                                      alignment: Alignment.center,
                                      child: const Text('No image'),
                                    ),
                              SizedBox(width: 15.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: size.width * .5,
                                    child: Text(
                                      'Nomi: $name',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      softWrap: true,
                                    ),
                                  ),
                                  Text(
                                    'Price: ${formatAmount.format(price)}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Quantity: $qty dona',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text('No record found'),
                    );
                  }
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
                  '',
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
