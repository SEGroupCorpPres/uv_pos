// import 'package:excel/excel.dart' as excel;
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:future_pos/features/presentation/pages/order/order.dart';

// class OrderListScreen extends StatefulWidget {
//   const OrderListScreen({super.key});

//   static Page page() => const MaterialPage(
//         child: OrderListScreen(),
//       );

//   @override
//   State<OrderListScreen> createState() => _OrderListScreenState();
// }

// enum Menu { filter, report }

// class _OrderListScreenState extends State<OrderListScreen> {
//   StoreModel? store;
//   final ScrollController _scrollController = ScrollController();
//   TextEditingController _searchController = TextEditingController();
//   TextEditingController date1TextEditingController = TextEditingController();
//   TextEditingController date2TextEditingController = TextEditingController();
//   double orderTotalAmount = 0;
//   List<OrderModel> orderListForReport = [];
//   int orderLength = 0;
//   DateTime _date = DateTime.now();
//   DateTime? dateFrom;
//   DateTime? dateTo;
//   late List<int> date1 = [];
//   late List<int> date2 = [];
//   List<OrderProductModel> _productListByDateRange = [];
//   final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
//   final List<OrderModel> _searchList = [];
//   List<OrderModel> _orderList = [];
//   bool _isSearching = false;
//   bool _isSearchTap = false;

//   void _getProductList() {
//     // setState(() {
//     log(orderListForReport.length.toString());
//     for (OrderModel order in orderListForReport) {
//       DateTime orderDate = order.orderDate;
//       int orderDateMSE =
//           DateTime(orderDate.year, orderDate.month, orderDate.day)
//               .millisecondsSinceEpoch;
//       int rangeDateFromMSE =
//           DateTime(dateFrom!.year, dateFrom!.month, dateFrom!.day)
//               .millisecondsSinceEpoch;
//       int rangeDateToMSE = DateTime(dateTo!.year, dateTo!.month, dateTo!.day)
//           .millisecondsSinceEpoch;

//       // String orderProdDate = '${order.orderDate.year}/${order.orderDate.month}/${order.orderDate.day}';
//       // String rangeDateFrom = '${dateFrom!.year}/${dateFrom!.month}/${dateFrom!.day}';
//       // String rangeDateTo = '${dateTo!.year}/${dateTo!.month}/${dateFrom!.day}';
//       log(orderDateMSE.toString());
//       log(rangeDateFromMSE.toString());
//       log(rangeDateToMSE.toString());

//       if (orderDateMSE >= rangeDateFromMSE && orderDateMSE <= rangeDateToMSE) {
//         log('add product');
//         order.productList
//             .forEach((product) => _productListByDateRange.add(product));
//       }
//     }
//     // });
//     log('get length');
//     log(_productListByDateRange.length.toString());
//   }

//   NumberFormat formatAmount = NumberFormat.currency(
//     locale: 'uz_UZ',
//     symbol: 'UZS',
//   );

//   Map<String, bool> orderFilterMap = {
//     'customer_name': false,
//     'employee_name': false,
//   };

//   Future<void> _materialDatePicker({
//     required TextEditingController dateTextEditingController,
//     required List<int> dateForComparison,
//     bool? isFrom = true,
//     required BuildContext context,
//     required DateTime? dateRange,
//   }) async {
//     final date = await showDatePicker(
//       context: context,
//       // initialDate: DateTime(_date.year, _date.month, _date.day),
//       firstDate: DateTime(2017),
//       lastDate: DateTime(2040),
//       helpText: 'ВЫБЕРИТЕ ДАТУ',
//       cancelText: 'ОТМЕНА',
//       confirmText: 'ВЫБИРАТЬ',
//       fieldHintText: 'дд/мм/гггг',
//       fieldLabelText: 'Введите дату',
//       keyboardType: TextInputType.datetime,
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             // days/years gridview
//             textTheme: TextTheme(),
//             // Buttons
//             // textButtonTheme: TextButtonThemeData(
//             //   style: TextButton.styleFrom(
//             //     textStyle: GoogleFonts.montserrat(),
//             //   ),
//             // ),
//             // Input
//             inputDecorationTheme: InputDecorationTheme(
//               // labelStyle: GoogleFonts.montserrat(), // Input label
//               floatingLabelBehavior: FloatingLabelBehavior.always,
//               contentPadding: EdgeInsets.zero,
//               isDense: true,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//     // if (date != _date) {
//     setState(() {
//       dateForComparison
//         ..add(date!.year)
//         ..add(date.month)
//         ..add(date.day);
//       _date = date;
//       if (isFrom!) {
//         dateFrom = date;
//       } else {
//         dateTo = date;
//       }
//       dateRange = date;
//       log('material date');
//       log(dateRange!.toIso8601String());
//       log(dateFrom!.toIso8601String());

//       dateTextEditingController.text = _dateFormat.format(date);
//     });
//     // }
//   }

//   Future<void> _createOrderExcel() async {
//     // Assets faylini yuklash
//     ByteData data = await rootBundle.load(Assets.docSalesReport);
//     List<int> bytesList = data.buffer.asUint8List();
//     // Excel faylini o'qish (excel paketi orqali)
//     excel.Excel excelFile = excel.Excel.decodeBytes(bytesList);
//     excel.Sheet sheet = excelFile['Sheet1']; // Birinchi varaqni olish

//     excel.CellStyle cellStyle = excel.CellStyle(
//       // backgroundColorHex: excel.ExcelColor.red,
//       leftBorder: excel.Border(
//         borderStyle: excel.BorderStyle.Thin,
//         borderColorHex: excel.ExcelColor.black,
//       ),
//       rightBorder: excel.Border(
//         borderStyle: excel.BorderStyle.Medium,
//         borderColorHex: excel.ExcelColor.black,
//       ),
//       topBorder: excel.Border(
//         borderStyle: excel.BorderStyle.Thin,
//         borderColorHex: excel.ExcelColor.black,
//       ),
//       bottomBorder: excel.Border(
//         borderStyle: excel.BorderStyle.Thin,
//         borderColorHex: excel.ExcelColor.black,
//       ),
//     );
//     log('product list');
//     log(_productListByDateRange.length.toString());

//     log(_productListByDateRange.toString());
//     for (int i = 0; i < _productListByDateRange.length; i++) {
//       String title = _productListByDateRange[i].name;
//       double qty = _productListByDateRange[i].quantity;
//       String pmu = _productListByDateRange[i].productMeasurementUnit;
//       double price = _productListByDateRange[i].price;
//       double priceSumma = _productListByDateRange[i].price * qty;
//       log(title);
//       log(qty.toString());
//       log(pmu);
//       log(price.toString());
//       log(priceSumma.toString());

//       if (i != 9) {
//         sheet.insertRow(9 + i);
//         sheet.updateCell(excel.CellIndex.indexByString('A${9 + i}'),
//             excel.IntCellValue(i + 1),
//             cellStyle: cellStyle);
//         sheet.updateCell(excel.CellIndex.indexByString('B${9 + i}'),
//             excel.TextCellValue(title),
//             cellStyle: cellStyle);
//         sheet.updateCell(excel.CellIndex.indexByString('C${9 + i}'),
//             excel.DoubleCellValue(qty),
//             cellStyle: cellStyle);
//         sheet.updateCell(excel.CellIndex.indexByString('D${9 + i}'),
//             excel.TextCellValue(pmu),
//             cellStyle: cellStyle);
//         sheet.updateCell(excel.CellIndex.indexByString('E${9 + i}'),
//             excel.DoubleCellValue(price),
//             cellStyle: cellStyle);
//         sheet.updateCell(excel.CellIndex.indexByString('F${9 + i}'),
//             excel.DoubleCellValue(priceSumma),
//             cellStyle: cellStyle);
//       }
//     }
//     // Saving the file

//     //stopwatch.reset();
//     List<int>? fileBytes = excelFile.save();

//     final path = (await getApplicationSupportDirectory()).path;

//     final file =
//         '$path/Report-from-${dateFrom!.year}-${dateFrom!.month}-${dateFrom!.day}-to-${dateTo!.year}-${dateTo!.month}-${dateTo!.day}.xlsx';
//     //print('saving executed in ${stopwatch.elapsed}');
//     if (fileBytes != null) {
//       log('save excel');
//       File(join(file))
//         ..createSync(recursive: true)
//         ..writeAsBytesSync(fileBytes);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.sizeOf(context);
//     initializeDateFormatting('uz_UZ', null);

//     return BlocBuilder<AppBloc, AppState>(
//       builder: (context, appState) {
//         // if (appState.status == AppStatus.orderListScreen) {
//         return PopScope(
//           canPop: false,
//           onPopInvokedWithResult: (bool didPop, result) {
//             if (didPop) {
//               return;
//             }
//             context.read<AppBloc>().add(
//                   const NavigateToHomeScreen(),
//                 );
//           },
//           child: Scaffold(
//             appBar: AppBar(
//               automaticallyImplyLeading: true,
//               leading: InkWell(
//                 onTap: () {
//                   BlocProvider.of<AppBloc>(context).add(
//                     NavigateToHomeScreen(storeID: appState.storeID),
//                   );
//                   BlocProvider.of<UserBloc>(context)
//                       .add(FetchUserByIdEvent(appState.userID!));
//                 },
//                 child: Icon(Icons.adaptive.arrow_back),
//               ),
//               title: Text('Order List ($orderLength/$orderLength)'),
//               centerTitle: false,
//               actions: ordersScreenActions(
//                 context: context,
//                 qrCode: searchWithQrCode,
//                 filter: () => _showFilterWithDateDialog(context, Menu.filter),
//                 search: searchWithCustomerName,
//                 report: () => reportToExcel(context),
//               ),
//               bottom: orderListScreenBottom(
//                 context: context,
//                 size: size,
//                 isSearchTap: _isSearchTap,
//                 searchController: _searchController,
//                 onChanged: _searchWithCustomerName,
//                 totalAmount: formatAmount.format(orderTotalAmount),
//                 unpaidAmount: formatAmount.format(0),
//               ),
//             ),
//             body: BlocConsumer<OrderBloc, OrderState>(
//               listener: _orderBodyListener,
//               builder: (context, orderState) {
//                 List<OrderModel> orderList = [];
//                 if (orderState is OrderLoading) {
//                   return const Center(
//                     child: CircularProgressIndicator.adaptive(),
//                   );
//                 } else if (orderState is OrdersFromDateByStoreIDLoaded) {
//                   _orderList = orderState.orders!;
//                   orderListForReport = orderState.orders!;
//                   orderList = _isSearching ? _searchList : _orderList;
//                   orderList = orderList.reversed.toList();
//                   // _getProductList();
//                   // orderList.asMap().entries.map(
//                   //       (item) => orderFilterMap.putIfAbsent(
//                   //         item.value.toString() != 'orderDate' ? item.value.toString() : '',
//                   //         () => false,
//                   //       ),
//                   //     );
//                   return GroupedListView<OrderModel, DateTime>(
//                     controller: _scrollController,
//                     elements: orderList,
//                     groupBy: (OrderModel order) => DateTime(
//                       order.orderDate.year,
//                       order.orderDate.month,
//                       order.orderDate.day,
//                     ),
//                     groupHeaderBuilder: (OrderModel order) {
//                       DateTime date = order.orderDate;
//                       String formattedDate = DateFormat(
//                         'd MMMM yyyy, HH:mm',
//                       ).format(date);
//                       return GroupHeaderDate(
//                         date: formattedDate,
//                       );
//                     },
//                     itemComparator: (order1, order2) =>
//                         order1.compareTo(order2),
//                     itemBuilder: (context, OrderModel order) {
//                       DateTime date = order.orderDate;
//                       // String formattedTime = DateFormat(
//                       //   'HH:mm',
//                       // ).format(date);
//                       String formattedDate = DateFormat(
//                         'd/MM/yyyy, HH:mm',
//                       ).format(date);
//                       return CupertinoListTile(
//                         backgroundColorActivated: Colors.transparent,
//                         onTap: () {
//                           _showOrderDetailBottomSheet(context, order);
//                         },
//                         title: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               order.customerName.isEmpty
//                                   ? "No Customer name"
//                                   : order.customerName,
//                               style: TextStyle(
//                                   color: Colors.black, fontSize: 18.sp),
//                             ),
//                             Text(
//                               formatAmount.format(order.totalAmount),
//                               style: TextStyle(
//                                   color: Colors.blueAccent.withGreen(200),
//                                   fontSize: 18.sp),
//                             ),
//                           ],
//                         ),
//                         subtitle: Text(
//                           formattedDate,
//                           style:
//                               TextStyle(color: Colors.black, fontSize: 13.sp),
//                         ),
//                       );
//                     },
//                     useStickyGroupSeparators: true,
//                     floatingHeader: true,
//                     order: GroupedListOrder.DESC, // optional
//                   );
//                 } else if (orderState is OrderNotFound) {
//                   return Container(
//                     alignment: Alignment.center,
//                     child: const Text('No Record Found'),
//                   );
//                 } else if (orderState is OrderError) {
//                   return Container(
//                     alignment: Alignment.center,
//                     child: const Text('No Record Found'),
//                   );
//                 }
//                 return Container(
//                   alignment: Alignment.center,
//                   child: const Text('No Record Found'),
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _orderBodyListener(context, orderState) {
//     if (orderState is OrdersFromDateByStoreIDLoaded) {
//       _orderList = orderState.orders!;
//       List<OrderModel> orders = _isSearching ? _searchList : _orderList;
//       // double totalAmount = 0;
//       orderLength = orders.length;
//       for (var order in orders) {
//         orderTotalAmount += order.totalAmount;
//       }
//     }
//   }

//   void _searchWithCustomerName(value) {
//     _searchList.clear();
//     for (var order in _orderList) {
//       if (order.customerName.toLowerCase().contains(value.toLowerCase())
//           // || order.employeeName.toLowerCase().contains(value.toLowerCase())
//           ) {
//         _searchList.add(order);
//       }
//       setState(() {
//         _searchList;
//         _isSearching = true;
//       });
//     }
//   }

//   void searchWithCustomerName() {
//     setState(() {
//       _isSearchTap = !_isSearchTap;
//     });
//   }

//   void searchWithQrCode() {}

//   void reportToExcel(BuildContext context) async {
//     late String fileName;
//     if (dateFrom == null || dateTo == null) {
//       _showFilterWithDateDialog(context, Menu.report);
//     } else {
//       try {
//         await _createOrderExcel();
//         final path = (await getApplicationSupportDirectory()).path;
//         fileName =
//             '$path/Report-from-${dateFrom!.year}-${dateFrom!.month}-${dateFrom!.day}-to-${dateTo!.year}-${dateTo!.month}-${dateTo!.day}.xlsx';
//         log(fileName);
//         OpenFilex.open(fileName);
//       } catch (e) {
//         log(e.toString());
//       }
//       final result = await Share.shareXFiles([XFile(fileName)],
//           text:
//               '${dateFrom!.year}/${dateFrom!.month}/${dateFrom!.day} - ${dateTo!.year}/${dateTo!.month}/${dateTo!.day} orasida sotilgan maxsulotlar hisoboti');
//       log(result.toString() + '----> result error');
//       if (result.status == ShareResultStatus.success) {
//         log(fileName);
//         log('Thank you for sharing the picture!');
//       }
//     }

//     // _showReportDialog(context);
//   }

//   // void _showFilterDialog(BuildContext context, StoreModel store) {
//   //   showAdaptiveDialog(
//   //     context: context,
//   //     builder: (context) {
//   //       return _buildFilterDialogWidget(context, store);
//   //     },
//   //   );
//   // }

//   // Widget _buildFilterDialogWidget(BuildContext context, StoreModel? store) {
//   //   return Align(
//   //     alignment: Alignment.center,
//   //     child: MultiSelectionFilter(
//   //       title: 'Order filter',
//   //       textListToShow: orderFilterMap.keys.toList(),
//   //       selectedList: orderFilterMap.values.toList(),
//   //       accentColor: const Color(0xFF01b4e4),
//   //       checkboxTitleBG: Colors.black87,
//   //       checkboxCheckColor: Colors.white,
//   //       checkboxTitleTextColor: Colors.white,
//   //       doneButtonBG: const Color(0xFF01b4e4),
//   //       doneButtonTextColor: Colors.white,
//   //       onDoneButtonPressed: () => Navigator.pop(context),
//   //       onCheckboxTap: (key, index, isChecked) {
//   //         setState(() {
//   //           orderFilterMap[key] = isChecked;
//   //         });
//   //       },
//   //       child: Icon(
//   //         Icons.filter_alt,
//   //       ),
//   //     ),
//   //   );
//   // }

//   PersistentBottomSheetController _showOrderDetailBottomSheet(
//       BuildContext context, OrderModel order) {
//     return showBottomSheet(
//       enableDrag: true,
//       showDragHandle: true,
//       context: context,
//       backgroundColor: Colors.white,
//       builder: (context) {
//         return OrderDetailBottomSheet(
//           order: order,
//           onTap: () {
//             _showReceiptDialog(
//               context,
//               order,
//             );
//           },
//         );
//       },
//     );
//   }

//   void _showReceiptDialog(
//     BuildContext context,
//     OrderModel order,
//   ) {
//     showAdaptiveDialog(
//       context: context,
//       builder: (context) {
//         return _buildShowReceiptDialogWidget(
//           context,
//           order,
//         );
//       },
//     );
//   }

//   SimpleDialog _buildShowReceiptDialogWidget(
//     BuildContext context,
//     OrderModel order,
//   ) {
//     DateTime date = order.orderDate;
//     String formattedDate = DateFormat(
//       'd/MM/yyyy, HH:mm:ss',
//     ).format(date);
//     return SimpleDialog(
//       contentPadding: EdgeInsets.zero,
//       titlePadding: EdgeInsets.zero,
//       clipBehavior: Clip.hardEdge,
//       title: Container(
//         clipBehavior: Clip.none,
//         color: Colors.blueGrey.withAlpha(100),
//         width: double.infinity,
//         height: 40.h,
//         child: Stack(
//           alignment: Alignment.topRight,
//           children: [
//             Row(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Center(
//                   child: Text(
//                     'Receipt',
//                     textAlign: TextAlign.center,
//                     softWrap: true,
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 24.sp,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             IconButton(
//                 onPressed: () => Navigator.pop(context),
//                 icon: const Icon(Icons.close)),
//           ],
//         ),
//       ),
//       children: [
//         BlocBuilder<StoreBloc, StoreState>(
//           builder: (context, state) {
//             if (state is StoreLoading) {
//               return Container();
//             } else if (state is StoreError) {
//               return ErrorWidget(state.error);
//             } else if (state is StoreByIdLoaded) {
//               return OrderShowReceiptDialogStoreDataWidget(store: state.store);
//             } else {
//               return Container();
//             }
//           },
//         ),
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: 20.w),
//           width: double.infinity,
//           // height: 50,
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Customer',
//                     textAlign: TextAlign.center,
//                     softWrap: true,
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 18.sp,
//                     ),
//                   ),
//                   Text(
//                     order.customerName,
//                     textAlign: TextAlign.center,
//                     softWrap: true,
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 18.sp,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 5.h,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Employee',
//                     textAlign: TextAlign.center,
//                     softWrap: true,
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 18.sp,
//                     ),
//                   ),
//                   Text(
//                     order.employeeName,
//                     textAlign: TextAlign.center,
//                     softWrap: true,
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 18.sp,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         SizedBox(height: 10.h),
//         Divider(
//           indent: 20.w,
//           endIndent: 20.w,
//           height: 5,
//           color: Colors.black,
//         ),
//         SizedBox(height: 10.h),
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20.w),
//           child: Column(
//             children: [
//               const ReceiptDetail(
//                 name: 'Description',
//                 qty: 'Qty',
//                 price: 'Total',
//               ),
//               Column(
//                 children: order.productList
//                     .asMap()
//                     .entries
//                     .map(
//                       (entry) => ReceiptDetail(
//                         name: '${entry.key + 1}. ${entry.value.name}',
//                         qty: '${entry.value.quantity} x ${entry.value.price}',
//                         price: (entry.value.price * entry.value.quantity)
//                             .toString(),
//                       ),
//                     )
//                     .toList(),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(height: 10.h),
//         Divider(
//           indent: 20.w,
//           endIndent: 20.w,
//           height: 5,
//           color: Colors.black,
//         ),
//         Column(
//           children: [
//             SaleProductPrice(
//               title: 'Total',
//               price: formatAmount.format(order.totalAmount),
//               textAlign: TextAlign.start,
//             ),
//             SaleProductPrice(
//               fontSize: 12,
//               fontColor: Colors.grey,
//               title: 'Received Amount / Cash',
//               price: formatAmount.format(orderTotalAmount),
//               textAlign: TextAlign.start,
//             ),
//           ],
//         ),
//         Column(
//           children: [
//             const Text('Thanks for coming!'),
//             Text(formattedDate),
//             SizedBox(
//               height: 10.h,
//             ),
//             SvgPicture.string(order.barcode!),
//           ],
//         ),
//         Container(
//           clipBehavior: Clip.none,
//           color: Colors.blueGrey.withAlpha(100),
//           width: double.infinity,
//           height: 50.h,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               TextButton.icon(
//                 style: TextButton.styleFrom(
//                   backgroundColor: CupertinoColors.activeGreen,
//                   minimumSize: Size(100.w, 30.h),
//                 ),
//                 onPressed: () => Navigator.pop(context),
//                 icon: Icon(
//                   Icons.adaptive.share,
//                   color: Colors.white,
//                 ),
//                 label: const Text(
//                   'Share',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//               SizedBox(width: 10.w),
//               TextButton.icon(
//                 style: TextButton.styleFrom(
//                     backgroundColor: CupertinoColors.activeBlue,
//                     minimumSize: Size(100.w, 30.h)),
//                 onPressed: () => Navigator.pop(context),
//                 icon: const Icon(
//                   Icons.print,
//                   color: Colors.white,
//                 ),
//                 label: const Text(
//                   'Print',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   void _showFilterWithDateDialog(BuildContext context, Menu menu) {
//     showAdaptiveDialog(
//       context: context,
//       builder: (context) {
//         return _buildShowFilterWithDateDialogWidget(context, menu);
//       },
//     );
//   }

//   SimpleDialog _buildShowFilterWithDateDialogWidget(
//       BuildContext context, Menu menu) {
//     // DateTime date = order.orderDate;
//     // String formattedDate = DateFormat(
//     //   'd/MM/yyyy, HH:mm:ss',
//     // ).format(date);
//     return SimpleDialog(
//       contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
//       titlePadding: EdgeInsets.zero,
//       clipBehavior: Clip.hardEdge,
//       title: Container(
//         clipBehavior: Clip.none,
//         color: Colors.blueGrey.withAlpha(100),
//         width: double.infinity,
//         height: 40.h,
//         child: Stack(
//           alignment: Alignment.topRight,
//           children: [
//             Row(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Center(
//                   child: Text(
//                     'Select date range',
//                     textAlign: TextAlign.center,
//                     softWrap: true,
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 24.sp,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             IconButton(
//                 onPressed: () => Navigator.pop(context),
//                 icon: const Icon(Icons.close)),
//           ],
//         ),
//       ),
//       children: [
//         StoreTextField(
//           hintText: 'Start date',
//           textEditingController: date1TextEditingController,
//           icon: CupertinoIcons.calendar,
//           onTap: () => _materialDatePicker(
//             context: context,
//             dateTextEditingController: date1TextEditingController,
//             dateForComparison: date1,
//             dateRange: dateFrom,
//           ),
//         ),
//         StoreTextField(
//           hintText: 'End date',
//           icon: CupertinoIcons.calendar,
//           textEditingController: date2TextEditingController,
//           onTap: () => _materialDatePicker(
//             context: context,
//             dateTextEditingController: date2TextEditingController,
//             dateForComparison: date2,
//             dateRange: dateTo,
//             isFrom: false,
//           ),
//         ),
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 30.w),
//           child: StoreButton(
//             title: 'Create and share',
//             icon: CupertinoIcons.create,
//             onPressed: () {
//               _getProductList();
//               switch (menu) {
//                 case Menu.report:
//                   reportToExcel(context);
//                   Navigator.pop(context);

//                   break;
//                 default:
//                   Navigator.pop(context);
//               }
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   void filterByDateRange() {
//     _getProductList();
//   }
// }

// class OrderShowReceiptDialogStoreDataWidget extends StatelessWidget {
//   OrderShowReceiptDialogStoreDataWidget({
//     super.key,
//     required StoreModel? store,
//   }) : _store = store!;

//   final StoreModel _store;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(
//           _store.name ?? '',
//           textAlign: TextAlign.center,
//           softWrap: true,
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 24.sp,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//         Text(
//           _store.phone,
//           textAlign: TextAlign.center,
//           softWrap: true,
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 20.sp,
//           ),
//         ),
//         Text(
//           _store.address,
//           textAlign: TextAlign.center,
//           softWrap: true,
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 20.sp,
//           ),
//         ),
//       ],
//     );
//   }
// }
