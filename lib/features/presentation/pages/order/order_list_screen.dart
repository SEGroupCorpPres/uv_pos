import 'dart:developer';
import 'dart:io';

import 'package:excel/excel.dart' as excel;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:multi_selection_filter/multi_selection_filter.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
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
    // Assets faylini yuklash
    ByteData data = await rootBundle.load(Assets.docSalesReport);
    List<int> bytesList = data.buffer.asUint8List();
    // Excel faylini o'qish (excel paketi orqali)
    excel.Excel excelFile = excel.Excel.decodeBytes(bytesList);
    excel.Sheet sheet = excelFile['Sheet1']; // Birinchi varaqni olish

    excel.CellStyle cellStyle = excel.CellStyle(
      // backgroundColorHex: excel.ExcelColor.red,
      leftBorder: excel.Border(
        borderStyle: excel.BorderStyle.Thin,
        borderColorHex: excel.ExcelColor.black,
      ),
      rightBorder: excel.Border(
        borderStyle: excel.BorderStyle.Medium,
        borderColorHex: excel.ExcelColor.black,
      ),
      topBorder: excel.Border(
        borderStyle: excel.BorderStyle.Thin,
        borderColorHex: excel.ExcelColor.black,
      ),
      bottomBorder: excel.Border(
        borderStyle: excel.BorderStyle.Thin,
        borderColorHex: excel.ExcelColor.black,
      ),
    );
    for (int i = 0; i < 10; i++) {
      // excel.Data cellA = sheet.cell(excel.CellIndex.indexByString('A${9 + i}'));
      // excel.Data cellB = sheet.cell(excel.CellIndex.indexByString('B${9 + i}'));
      // excel.Data cellC = sheet.cell(excel.CellIndex.indexByString('C${9 + i}'));
      // excel.Data cellD = sheet.cell(excel.CellIndex.indexByString('E${9 + i}'));
      // excel.Data cellE = sheet.cell(excel.CellIndex.indexByString('D${9 + i}'));
      // excel.Data cellF = sheet.cell(excel.CellIndex.indexByString('F${9 + i}'));

      sheet.updateCell(excel.CellIndex.indexByString('A${9 + i}'), excel.IntCellValue(i), cellStyle: cellStyle);
      sheet.updateCell(excel.CellIndex.indexByString('B${9 + i}'), excel.TextCellValue('Maxsulot Nomi $i'), cellStyle: cellStyle);
      sheet.updateCell(excel.CellIndex.indexByString('C${9 + i}'), excel.DoubleCellValue(i.toDouble()), cellStyle: cellStyle);
      sheet.updateCell(excel.CellIndex.indexByString('D${9 + i}'), excel.TextCellValue('dona'), cellStyle: cellStyle);
      sheet.updateCell(excel.CellIndex.indexByString('E${9 + i}'), excel.DoubleCellValue(i.toDouble()), cellStyle: cellStyle);
      sheet.updateCell(excel.CellIndex.indexByString('F${9 + i}'), excel.DoubleCellValue(i * 100), cellStyle: cellStyle);

      // cellA.value = excel.IntCellValue(i);
      // cellB.value = excel.TextCellValue('Maxsulot nomi $i');
      // cellC.value = excel.DoubleCellValue(i.toDouble());
      // cellD.value = excel.TextCellValue('dona');
      // cellE.value = excel.DoubleCellValue(i.toDouble());
      // cellF.value = excel.DoubleCellValue(i * 100);

      if (i != 9) {
        sheet.insertRow(9 + i);
      }
    }
    // Saving the file

    //stopwatch.reset();
    List<int>? fileBytes = excelFile.save();

    final path = (await getApplicationSupportDirectory()).path;

    final file = '$path/Report-$rentalStartDate.xlsx';
    //print('saving executed in ${stopwatch.elapsed}');
    if (fileBytes != null) {
      log('save excel');
      File(join(file))
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);
    }
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
                    await _createOrderExcel(
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
                    log(fileName);
                    // OpenFilex.open(fileName);
                    final result = await Share.shareXFiles([XFile(fileName)], text: 'Hisobot');
                    log(result.toString() + '----> result error');
                    if (result.status == ShareResultStatus.success) {
                      log(fileName);
                      print('Thank you for sharing the picture!');
                    }
                    // _showReportDialog(context);
                  },
                  icon: Image.asset(
                    Assets.imagesExcel,
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
