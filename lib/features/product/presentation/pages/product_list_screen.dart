// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// import 'product.dart';

// class ProductListScreen extends StatefulWidget {
//   const ProductListScreen({super.key});

//   static Page page() => const MaterialPage(
//         child: ProductListScreen(),
//       );

//   @override
//   State<ProductListScreen> createState() => _ProductListScreenState();
// }

// class _ProductListScreenState extends State<ProductListScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   List<ProductModel> products = [];
//   late StoreModel? store;
//   final List<ProductModel> _searchList = [];
//   bool _isSearching = false;
//   NumberFormat formatAmount = NumberFormat.currency(
//     locale: 'uz_UZ',
//   );

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.sizeOf(context);
//     return PopScope(
//       canPop: false,
//       onPopInvokedWithResult: (bool didPop, result) {
//         if (didPop) {
//           return;
//         }
//         context.read<AppBloc>().add(
//               const NavigateToHomeScreen(),
//             );
//       },
//       child: Scaffold(
//           appBar: AppBar(
//             automaticallyImplyLeading: true,
//             leading: BlocBuilder<AppBloc, AppState>(
//               builder: (context, state) {
//                 return InkWell(
//                   onTap: () {
//                     BlocProvider.of<AppBloc>(context).add(
//                       NavigateToHomeScreen(storeID: state.storeID),
//                     );
//                     BlocProvider.of<UserBloc>(context).add(FetchUserByIdEvent(state.userID!));
//                   },
//                   child: Icon(Icons.adaptive.arrow_back),
//                 );
//               },
//             ),
//             title: AnimatedSearchBar(
//               label: "Maxsulotlar ro\'yxati",
//               controller: _searchController,
//               onChanged: (value) {
//                 _searchList.clear();
//                 for (var i in products) {
//                   if (i.name.toLowerCase().contains(value.toLowerCase())) {
//                     _searchList.add(i);
//                   }
//                   setState(() {
//                     _searchList;
//                     _isSearching = true;
//                   });
//                 }
//               },
//               labelStyle: TextStyle(fontSize: 16.sp),
//               cursorColor: Colors.black,
//               textInputAction: TextInputAction.done,
//               searchDecoration: const InputDecoration(
//                 hintText: 'Qidiruv',
//                 alignLabelWithHint: true,
//                 fillColor: Colors.white,
//                 focusColor: Colors.white,
//                 hintStyle: TextStyle(color: Colors.black),
//                 border: InputBorder.none,
//               ),
//             ),
//             centerTitle: false,
//             actions: _buildProductListScreenAppBarActions(context),
//           ),
//           body: BlocBuilder<AppBloc, AppState>(
//             builder: (context, appState) {
//               return BlocBuilder<ProductBloc, ProductState>(
//                 builder: (context, state) {
//                   if (state is ProductLoading) {
//                     return const Center(
//                       child: CircularProgressIndicator.adaptive(),
//                     );
//                   } else if (state is ProductsLoaded) {
//                     if (state.products != null) {
//                       products = state.products!;
//                       List<ProductModel> productList = [];
//                       productList = _isSearching ? _searchList : products;
//                       productList.sort((a, b) => b.name.compareTo(a.name));
//                       return ListView.builder(
//                         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20).r,
//                         itemCount: productList.length,
//                         itemBuilder: (context, item) {
//                           final String unit = productList[item].unit!;
//                           final String name = productList[item].name;
//                           final double sellingPrice = productList[item].sellingPrice;
//                           final double purchasingPrice = productList[item].purchasePrice;
//                           final String? thumbnail = productList[item].thumbnail;
//                           final String barcode = productList[item].meta.barcode;
//                           final String desc = productList[item].description ?? '';
//                           final String status = productList[item].status;
//                           return Slidable(
//                             // Specify a key if the Slidable is dismissible.
//                             key: const ValueKey(0),

//                             // The start action pane is the one at the left or the top side.
//                             startActionPane: ActionPane(
//                               // A motion is a widget used to control how the pane animates.
//                               motion: const ScrollMotion(),

//                               // A pane can dismiss the Slidable.
//                               dismissible: DismissiblePane(onDismissed: () {}),

//                               // All actions are defined in the children parameter.
//                               children: [
//                                 // A SlidableAction can have an icon and/or a label.
//                                 SlidableAction(
//                                   onPressed: (context) => BlocProvider.of<AppBloc>(context).add(
//                                     NavigateToCreateEditProductScreen(
//                                       productList[item].id,
//                                       productList[item].meta.barcode,
//                                       true,
//                                       store!.id,
//                                     ),
//                                   ),
//                                   backgroundColor: Colors.orangeAccent,
//                                   foregroundColor: Colors.white,
//                                   icon: Icons.edit,
//                                   label: 'Taxrirlash',
//                                 ),
//                               ],
//                             ),

//                             // The end action pane is the one at the right or the bottom side.
//                             endActionPane: ActionPane(
//                               motion: const ScrollMotion(),
//                               children: [
//                                 SlidableAction(
//                                   // An action can be bigger than the others.
//                                   flex: 2,
//                                   onPressed: (context) => BlocProvider.of<ProductBloc>(context).add(
//                                     DeleteProductEvent(
//                                         productId: productList[item].id, storeID: store!.id),
//                                   ),
//                                   backgroundColor: Colors.red,
//                                   foregroundColor: Colors.white,
//                                   icon: Icons.delete,
//                                   label: 'O\'chirish',
//                                 ),
//                               ],
//                             ),

//                             // The child of the Slidable is what the user sees when the
//                             // component is not dragged.
//                             child: Container(
//                               margin: EdgeInsets.only(bottom: 10),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(20).r,
//                                 color: status == 'inactive'
//                                     ? CupertinoColors.systemGreen
//                                     : CupertinoColors.systemGreen,
//                               ),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   thumbnail != null
//                                       ? Container(
//                                           width: 120.r,
//                                           height: 120.r,
//                                           decoration: BoxDecoration(
//                                             color: Colors.yellowAccent,
//                                             borderRadius: BorderRadius.circular(20).r,
//                                             image: DecorationImage(
//                                                 image: NetworkImage(thumbnail), fit: BoxFit.cover),
//                                           ),
//                                           // margin: const EdgeInsets.only(bottom: 10).h,
//                                         )
//                                       : Container(
//                                           width: 120.r,
//                                           height: 120.r,
//                                           decoration: BoxDecoration(
//                                             color: Colors.yellowAccent,
//                                             borderRadius: BorderRadius.circular(20).r,
//                                           ),
//                                           // margin: const EdgeInsets.only(bottom: 10).h,
//                                           alignment: Alignment.center,
//                                           child: const Text('Rasm yo\'q'),
//                                         ),
//                                   SizedBox(width: 15.w),
//                                   Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       SizedBox(
//                                         width: size.width * .5,
//                                         child: Text(
//                                           'Nomi: $name',
//                                           style: TextStyle(
//                                             color: Colors.black,
//                                             fontSize: 18.sp,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                           softWrap: true,
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: size.width * .5,
//                                         child: Text(
//                                           'Barcode: $barcode',
//                                           style: TextStyle(
//                                             color: Colors.black,
//                                             fontSize: 18.sp,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                           softWrap: true,
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: size.width * .5,
//                                         child: Text(
//                                           'Tavsif: $desc',
//                                           style: TextStyle(
//                                             color: Colors.black,
//                                             fontSize: 18.sp,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                           softWrap: true,
//                                         ),
//                                       ),
//                                       Text(
//                                         'Sotish narxi: ${formatAmount.format(sellingPrice)}',
//                                         style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: 15.sp,
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                       ),
//                                       Text(
//                                         'Sotib olish narxi: ${formatAmount.format(purchasingPrice)}',
//                                         style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: 15.sp,
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                       ),
//                                       Text(
//                                         'O\'lchov birligi: $unit',
//                                         style: const TextStyle(
//                                           color: Colors.black,
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     } else {
//                       return const ErrorScreen(message: 'Maxsulot topilmadi');
//                     }
//                   } else if (state is ProductNotFound) {
//                     return const ErrorScreen(message: 'Maxsulot topilmadi', isEmpty: true);
//                   } else if (state is ProductError) {
//                     return const ErrorScreen(message: 'Error');
//                   } else {
//                     return const ErrorScreen(message: 'Maxsulot topilmadi');
//                   }
//                 },
//               );
//             },
//           ),
//           floatingActionButton: BlocBuilder<AppBloc, AppState>(builder: (context, appState) {
//             return FloatingActionButton(
//               onPressed: () => BlocProvider.of<AppBloc>(context).add(
//                 NavigateToCreateEditProductScreen(
//                   null,
//                   '',
//                   false,
//                   appState.storeID,
//                 ),
//               ),
//               child: const Icon(Icons.add),
//             );
//           })),
//     );
//   }

//   List<Widget> _buildProductListScreenAppBarActions(BuildContext context) {
//     return [
//       BlocBuilder<AppBloc, AppState>(builder: (context, appState) {
//         return IconButton(
//           onPressed: () {
//             BlocProvider.of<ProductBloc>(context)
//                 .add(LoadProductsEvent(storeID: appState.storeID!));
//           },
//           icon: const Icon(Icons.sync_problem),
//         );
//       })
//     ];
//   }
// }
