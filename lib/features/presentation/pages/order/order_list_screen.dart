import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:multi_selection_filter/multi_selection_filter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'package:uv_pos/app/presentation/bloc/auth/app_bloc.dart';
import 'package:uv_pos/features/data/remote/models/order_model.dart';
import 'package:uv_pos/features/data/remote/models/store_model.dart';
import 'package:uv_pos/features/presentation/bloc/order/order_bloc.dart';
import 'package:uv_pos/features/presentation/pages/sale/receipt_detail.dart';
import 'package:uv_pos/features/presentation/widgets/order_detail_bottom_sheet.dart';
import 'package:uv_pos/features/presentation/widgets/order_list_group_header_date.dart';
import 'package:uv_pos/features/presentation/widgets/sale_product_price.dart';
import 'package:uv_pos/generated/assets.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  static Page page() => Platform.isIOS
      ? const CupertinoPage(
          child: OrderListScreen(),
        )
      : const MaterialPage(
          child: OrderListScreen(),
        );

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

enum Menu { filter, report }

class _OrderListScreenState extends State<OrderListScreen> {
  StoreModel? store;
  final ScrollController _scrollController = ScrollController();
  TextEditingController _searchController = TextEditingController();
  double orderTotalAmount = 0;
  int orderLength = 0;
  final List<OrderModel> _searchList = [];
  List<OrderModel> _orderList = [];
  bool _isSearching = false;
  bool _isSearchTap = false;
  String? _fileName;

  NumberFormat formatAmount = NumberFormat.currency(
    locale: 'uz_UZ',
    symbol: 'UZS',
  );

  Map<String, bool> orderFilterMap = {
    'customer_name': false,
    'employee_name': false,
  };

  Future<void> _createOrderExcel({
    required String? uid,
    required String? userImg,
    required String? fullName,
    required String? phoneNumber,
    required String? dateOfBirth,
    required double orderId,
    required double carId,
    required String carName,
    required double rentalPrice,
    required String rentalStartDate,
    required String rentalEndDate,
    required String orderCreatedTime,
    required String fillingAddress,
    required String returnAddress,
  }) async {
    final workbook = xlsio.Workbook();
    final sheet = workbook.worksheets[0];
    // Set column widths
    sheet.columns[1]?.width = 50;
    sheet.columns[2]?.width = 300;
    sheet.columns[3]?.width = 50;
    sheet.columns[4]?.width = 100;
    sheet.columns[5]?.width = 100;
    sheet.columns[6]?.width = 150;

    // Set header row style
    final xlsio.Range headerRange = sheet.getRangeByName('B3');
    headerRange.setText("№");
    headerRange.bAutofitText;

    final xlsio.Range headerRange2 = sheet.getRangeByName('C3');
    headerRange2.setText("Maxsulot nomi(ish, xizmat)");
    headerRange2.bAutofitText;
    headerRange.cellStyle.hAlign = xlsio.HAlignType.center;
    headerRange.cellStyle.vAlign = xlsio.VAlignType.center;
    headerRange.cellStyle.bold = true;
    headerRange.cellStyle.fontSize = 12;
    headerRange.cellStyle.backColorRgb  = Colors.teal;
    headerRange.cellStyle.borders.all.colorRgb = Colors.black;
    headerRange.cellStyle.borders.all.lineStyle = xlsio.LineStyle.thin;

    headerRange.cellStyle.fontColorRgb = Colors.white;
    sheet.getRangeByName('D3').setText("Miqdor");
    sheet.getRangeByName('E3').setText("O'l. bir.");
    sheet.getRangeByName('F3').setText("Baxosi");
    sheet.getRangeByName('G3').setText("Umumiy Summa");

    // Apply header row style


    // Fill data (replace with your actual data)
    final List<List<String>> data = [
      ['1', 'tGMVhWDUZINjpp18mYBNvWe7', '2', 'https://firebasestorage.googleapis', 'Sulaymon O\'rinov', '+998 (99) 966 68 86'],
      ['5', '1996-12-14 00:00:00.000', '7940636', '70', 'Mercedes AMG GT S 2021', '60000'],
      // Add more rows as needed
    ];
    //
    // for (int i = 0; i < data.length; i++) {
    //   final row = sheet.rows[i + 2];
    //   for (int j = 0; j < data[i].length; j++) {
    //     row[j].text = data[i][j];
    //   }
    // }

    // Apply data row style


    // workSheet.importList(_orderList, 3, 3, true);
    // workSheet.getRangeByName('B3').setText('№');
    // workSheet.getRangeByName('C3').setText('Maxsulot nomi(ish, xizmat');
    // workSheet.getRangeByName('D3').setText('Miqdor');
    // workSheet.getRangeByName('E3').setText('O\'lchov birligi');
    // workSheet.getRangeByName('F3').setText('Baxosi');
    // workSheet.getRangeByName('G3').setText('Umumiy summa');
    for (int i = 1; i <= 10; i++) {
      sheet.getRangeByName('B${3 + i}').setNumber(i.toDouble());
      sheet.getRangeByName('C${3 + i}').setText('maxsulot nomi $i');
      sheet.getRangeByName('D${3 + i}').setNumber(i.toDouble());
      sheet.getRangeByName('E${3 + i}').setText('dona');
      sheet.getRangeByName('F${3 + i}').setNumber(123);
      sheet.getRangeByName('G${3 + i}').setNumber(123 * i.toDouble());
    }
    final dataRange = sheet.getRangeByName('A2:F' + (data.length + 1).toString());
    dataRange.cellStyle.hAlign = xlsio.HAlignType.left;
    dataRange.cellStyle.vAlign = xlsio.VAlignType.center;
    dataRange.cellStyle.borders.all.colorRgb = Colors.black;
    dataRange.cellStyle.borders.all.lineStyle = xlsio.LineStyle.thin;
    final bytes = workbook.saveAsStream();
    workbook.dispose();
    final path = (await getApplicationSupportDirectory()).path;

     final fileName = '$path/Report-$rentalStartDate.xlsx';
    final file = File(fileName);
    final xfile = XFile(fileName);
    await file
      ..writeAsBytes(bytes, flush: true);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    initializeDateFormatting('uz_UZ', null);

    return BlocBuilder<AppBloc, AppState>(
      builder: (context, appState) {
        // if (appState.status == AppStatus.orderListScreen) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (bool didPop, result) {
            if (didPop) {
              return;
            }
            context.read<AppBloc>().add(
                  const NavigateToHomeScreen(),
                );
          },
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              leading: InkWell(
                onTap: () => BlocProvider.of<AppBloc>(context).add(
                  NavigateToHomeScreen(appState.store),
                ),
                child: Icon(Icons.adaptive.arrow_back),
              ),
              title: Text('Order List ($orderLength/$orderLength)'),
              centerTitle: false,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.qr_code_2),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.calendar_month),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearchTap = !_isSearchTap;
                    });
                  },
                  icon: const Icon(Icons.search),
                ),
                IconButton(
                  onPressed: () async {
                    String date = DateTime.now().toIso8601String();
                    _createOrderExcel(
                      uid: '1',
                      userImg: '2',
                      fullName: 's',
                      phoneNumber: '1',
                      dateOfBirth: '2',
                      orderId: 546,
                      carId: 8,
                      carName: 'carName',
                      rentalPrice: 6787,
                      rentalStartDate: date,
                      rentalEndDate: 'rentalEndDate',
                      orderCreatedTime: 'orderCreatedTime',
                      fillingAddress: 'fillingAddress',
                      returnAddress: 'returnAddress',
                    );
                    final path = (await getApplicationSupportDirectory()).path;
                    final fileName = '$path/Report-$date.xlsx';
                    final result = await Share.shareXFiles([XFile(fileName)], text: 'Hisobot');
                    log(result.toString() + '----> result error');
                    if (result.status == ShareResultStatus.success) {
                      log(_fileName!);
                      print('Thank you for sharing the picture!');
                    }
                    // _showReportDialog(context);
                  },
                  icon: Image.asset(
                    Assets.imagesExcell,
                    width: 18.r,
                  ),
                ),
                SizedBox(width: 10.w)
                // _buildFilterDialogWidget(context, store),
              ],
              bottom: PreferredSize(
                preferredSize: Size(size.width, _isSearchTap ? 60.h : 30.h),
                child: Column(
                  children: [
                    _isSearchTap
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) {
                                _searchList.clear();
                                for (var order in _orderList) {
                                  if (order.customerName.toLowerCase().contains(value.toLowerCase())
                                      // || order.employeeName.toLowerCase().contains(value.toLowerCase())
                                      ) {
                                    _searchList.add(order);
                                  }
                                  setState(() {
                                    _searchList;
                                    _isSearching = true;
                                  });
                                }
                              },
                              decoration: const InputDecoration(border: OutlineInputBorder()),
                            ),
                          )
                        : Container(),
                    Text('Orders Total: ${formatAmount.format(orderTotalAmount)} - Unpaid: ${formatAmount.format(0)}'),
                  ],
                ),
              ),
            ),
            body: BlocConsumer<OrderBloc, OrderState>(
              listener: (context, orderState) {
                if (orderState is OrdersFromDateByStoreIDLoaded) {
                  _orderList = orderState.orders!;
                  List<OrderModel> orders = _isSearching ? _searchList : _orderList;
                  // double totalAmount = 0;
                  orderLength = orders.length;
                  for (var order in orders) {
                    orderTotalAmount += order.totalAmount;
                  }
                }
              },
              builder: (context, orderState) {
                List<OrderModel> orderList = [];
                if (orderState is OrderLoading) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else if (orderState is OrdersFromDateByStoreIDLoaded) {
                  _orderList = orderState.orders!;
                  orderList = _isSearching ? _searchList : _orderList;
                  orderList = orderList.reversed.toList();
                  orderList.asMap().entries.map(
                        (item) => orderFilterMap.putIfAbsent(
                          item.value.toString() != 'orderDate' ? item.value.toString() : '',
                          () => false,
                        ),
                      );
                  return GroupedListView<OrderModel, DateTime>(
                    controller: _scrollController,
                    elements: orderList,
                    groupBy: (OrderModel order) => DateTime(
                      order.orderDate.year,
                      order.orderDate.month,
                      order.orderDate.day,
                    ),
                    groupHeaderBuilder: (OrderModel order) {
                      DateTime date = order.orderDate;
                      String formattedDate = DateFormat(
                        'd MMMM yyyy, HH:mm',
                      ).format(date);
                      return GroupHeaderDate(
                        date: formattedDate,
                      );
                    },
                    itemComparator: (order1, order2) => order1.compareTo(order2),
                    itemBuilder: (context, OrderModel order) {
                      DateTime date = order.orderDate;
                      String formattedTime = DateFormat(
                        'HH:mm',
                      ).format(date);
                      String formattedDate = DateFormat(
                        'd/MM/yyyy, HH:mm',
                      ).format(date);
                      return CupertinoListTile(
                        backgroundColorActivated: Colors.transparent,
                        onTap: () {
                          _showOrderDetailBottomSheet(context, appState.store!, order);
                        },
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              order.customerName,
                              style: TextStyle(color: Colors.black, fontSize: 18.sp),
                            ),
                            Text(
                              formatAmount.format(order.totalAmount),
                              style: TextStyle(color: Colors.blueAccent.withGreen(200), fontSize: 18.sp),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          formattedDate,
                          style: TextStyle(color: Colors.black, fontSize: 13.sp),
                        ),
                      );
                    },
                    useStickyGroupSeparators: true,
                    floatingHeader: true,
                    order: GroupedListOrder.DESC, // optional
                  );
                } else if (orderState is OrderNotFound) {
                  return Container(
                    alignment: Alignment.center,
                    child: const Text('No Record Found'),
                  );
                } else if (orderState is OrderError) {
                  return Container(
                    alignment: Alignment.center,
                    child: const Text('No Record Found'),
                  );
                }
                return Container(
                  alignment: Alignment.center,
                  child: const Text('No Record Found'),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showFilterDialog(BuildContext context, StoreModel store) {
    showAdaptiveDialog(
      context: context,
      builder: (context) {
        return _buildFilterDialogWidget(context, store);
      },
    );
  }

  Widget _buildFilterDialogWidget(BuildContext context, StoreModel? store) {
    return Align(
      alignment: Alignment.center,
      child: MultiSelectionFilter(
        title: 'Order filter',
        textListToShow: orderFilterMap.keys.toList(),
        selectedList: orderFilterMap.values.toList(),
        accentColor: const Color(0xFF01b4e4),
        checkboxTitleBG: Colors.black87,
        checkboxCheckColor: Colors.white,
        checkboxTitleTextColor: Colors.white,
        doneButtonBG: const Color(0xFF01b4e4),
        doneButtonTextColor: Colors.white,
        onDoneButtonPressed: () => Navigator.pop(context),
        onCheckboxTap: (key, index, isChecked) {
          setState(() {
            orderFilterMap[key] = isChecked;
          });
        },
        child: Icon(
          Icons.filter_alt,
        ),
      ),
    );
  }

  PersistentBottomSheetController _showOrderDetailBottomSheet(BuildContext context, StoreModel store, OrderModel order) {
    return showBottomSheet(
      enableDrag: true,
      showDragHandle: true,
      context: context,
      backgroundColor: Colors.white,
      builder: (context) {
        return OrderDetailBottomSheet(
          order: order,
          onTap: () {
            _showReceiptDialog(context, order, store);
          },
        );
      },
    );
  }

  void _showReceiptDialog(BuildContext context, OrderModel order, StoreModel store) {
    showAdaptiveDialog(
      context: context,
      builder: (context) {
        return _buildShowReceiptDialogWidget(context, order, store);
      },
    );
  }

  SimpleDialog _buildShowReceiptDialogWidget(BuildContext context, OrderModel order, StoreModel? store) {
    DateTime date = order.orderDate;
    String formattedDate = DateFormat(
      'd/MM/yyyy, HH:mm:ss',
    ).format(date);
    return SimpleDialog(
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
      title: Container(
        clipBehavior: Clip.none,
        color: Colors.blueGrey.withAlpha(100),
        width: double.infinity,
        height: 40.h,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'Receipt',
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24.sp,
                    ),
                  ),
                ),
              ],
            ),
            IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
          ],
        ),
      ),
      children: [
        Column(
          children: [
            Text(
              store!.name ?? '',
              textAlign: TextAlign.center,
              softWrap: true,
              style: TextStyle(
                color: Colors.black,
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              store.phone,
              textAlign: TextAlign.center,
              softWrap: true,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.sp,
              ),
            ),
            Text(
              store.address,
              textAlign: TextAlign.center,
              softWrap: true,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.sp,
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          width: double.infinity,
          // height: 50,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Customer',
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.sp,
                    ),
                  ),
                  Text(
                    order.customerName,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Employee',
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.sp,
                    ),
                  ),
                  Text(
                    order.employeeName,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        Divider(
          indent: 20.w,
          endIndent: 20.w,
          height: 5,
          color: Colors.black,
        ),
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              const ReceiptDetail(
                name: 'Description',
                qty: 'Qty',
                price: 'Total',
              ),
              Column(
                children: order.productList
                    .asMap()
                    .entries
                    .map(
                      (entry) => ReceiptDetail(
                        name: '${entry.key + 1}. ${entry.value.name}',
                        qty: '${entry.value.size} x ${entry.value.price}',
                        price: (entry.value.price * entry.value.size).toString(),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        Divider(
          indent: 20.w,
          endIndent: 20.w,
          height: 5,
          color: Colors.black,
        ),
        Column(
          children: [
            SaleProductPrice(
              title: 'Total',
              price: formatAmount.format(order.totalAmount),
              textAlign: TextAlign.start,
            ),
            SaleProductPrice(
              fontSize: 12,
              fontColor: Colors.grey,
              title: 'Received Amount / Cash',
              price: formatAmount.format(orderTotalAmount),
              textAlign: TextAlign.start,
            ),
          ],
        ),
        Column(
          children: [
            const Text('Thanks for coming!'),
            Text(formattedDate),
            SizedBox(
              height: 10.h,
            ),
            SvgPicture.string(order.barcode!),
          ],
        ),
        Container(
          clipBehavior: Clip.none,
          color: Colors.blueGrey.withAlpha(100),
          width: double.infinity,
          height: 50.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                style: TextButton.styleFrom(
                  backgroundColor: CupertinoColors.activeGreen,
                  minimumSize: Size(100.w, 30.h),
                ),
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.adaptive.share,
                  color: Colors.white,
                ),
                label: const Text(
                  'Share',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 10.w),
              TextButton.icon(
                style: TextButton.styleFrom(backgroundColor: CupertinoColors.activeBlue, minimumSize: Size(100.w, 30.h)),
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.print,
                  color: Colors.white,
                ),
                label: const Text(
                  'Print',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showReportDialog(BuildContext context) {
    showAdaptiveDialog(
      context: context,
      builder: (context) {
        return _buildShowReportDialogWidget(context);
      },
    );
  }

  SimpleDialog _buildShowReportDialogWidget(BuildContext context) {
    // DateTime date = order.orderDate;
    // String formattedDate = DateFormat(
    //   'd/MM/yyyy, HH:mm:ss',
    // ).format(date);
    return SimpleDialog(
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
      title: Container(
        clipBehavior: Clip.none,
        color: Colors.blueGrey.withAlpha(100),
        width: double.infinity,
        height: 40.h,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'Select date range',
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24.sp,
                    ),
                  ),
                ),
              ],
            ),
            IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
          ],
        ),
      ),
      children: [],
    );
  }
}
