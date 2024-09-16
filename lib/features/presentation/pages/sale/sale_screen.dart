import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:barcode/barcode.dart' as barcode;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:uv_pos/app/presentation/bloc/auth/app_bloc.dart';
import 'package:uv_pos/features/data/remote/models/order_model.dart';
import 'package:uv_pos/features/data/remote/models/product_measurement_type.dart';
import 'package:uv_pos/features/data/remote/models/product_model.dart';
import 'package:uv_pos/features/data/remote/models/stock_model.dart';
import 'package:uv_pos/features/data/remote/models/store_model.dart';
import 'package:uv_pos/features/data/remote/models/user_model.dart';
import 'package:uv_pos/features/presentation/bloc/order/order_bloc.dart';
import 'package:uv_pos/features/presentation/bloc/product/product_bloc.dart';
import 'package:uv_pos/features/presentation/bloc/stock/stock_bloc.dart';
import 'package:uv_pos/features/presentation/pages/sale/receipt_detail.dart';
import 'package:uv_pos/features/presentation/widgets/sale_button.dart';
import 'package:uv_pos/features/presentation/widgets/sale_product_price.dart';
import 'package:uv_pos/features/presentation/widgets/scanner_error.dart';
import 'package:uv_pos/features/presentation/widgets/store/add_product_dialog.dart';
import 'package:uv_pos/generated/assets.dart';

class SaleScreen extends StatefulWidget {
  const SaleScreen({super.key});

  static Page page() => Platform.isIOS
      ? const CupertinoPage(
          child: SaleScreen(),
        )
      : const MaterialPage(
          child: SaleScreen(),
        );

  @override
  State<SaleScreen> createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> with WidgetsBindingObserver {
  bool isQrCodeScanner = false;
  late MobileScannerController scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    autoStart: true,
  );
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _productQtyController = TextEditingController(text: 1.toString());
  final TextEditingController _customerController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _searchScrollController = ScrollController();

  // BlueThermalPrinter bluetoothPrinter = BlueThermalPrinter.instance;
  StreamSubscription<BarcodeCapture>? _subscription;
  ValueNotifier<bool> isFlat = ValueNotifier<bool>(true);
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isProcessing = false;
  bool isScannerRunning = true;
  bool isSearch = false;
  List<ProductModel> searchProductList = [];
  final List<ProductModel> _searchList = [];
  List<ProductModel> _productList = [];
  List<ProductModel> _notifyProductList = [];
  Barcode? _barcode;
  double productAmount = 0;
  double orderSubTotalAmount = 0;
  double orderTotalAmount = 0;
  double discount = 0;
  String customerName = '';
  String? orderBarcode = '';
  String? orderQrcode = '';

  NumberFormat formatAmount = NumberFormat.currency(
    locale: 'uz_UZ',
    symbol: 'UZS',
  );
  final FocusNode _qtyFocusNode = FocusNode();

  // bool isFlat = true;
  int productQty = 1;

  List<ProductModel> products = [];

  // List<int> productQuantities = [];
  late OrderModel? order;
  DateTime dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Start listening to lifecycle changes.
    WidgetsBinding.instance.addObserver(this);

    // Start listening to the barcode events.
    _subscription = scannerController.barcodes.listen(_handleBarcode);
    if (kDebugMode) {}

    // Start the scanner initially.
    if (!scannerController.value.isRunning) {
      _startScanner();
    }
  }

  // Function to generate Barcode or QR Code
  String generateBarcode(String value, String type) {
    final barcodeType = type == 'barcode' ? barcode.Barcode.code128() : barcode.Barcode.qrCode();
    final svg = barcodeType.toSvg(value, width: type == 'barcode' ? 200 : 100, height: 100, fontHeight: 12.sp);
    return svg;
  }

  Future<void> _playBeepSound() async {
    await _audioPlayer.setAsset(Assets.soundsBeep);
    _audioPlayer.play();
  }

  Future<void> _startScanner() async {
    if (!isScannerRunning) {
      try {
        await scannerController.start();
        setState(() {
          isScannerRunning = true;
        });
      } catch (e) {
        if (kDebugMode) {
          print("Error starting scanner: $e");
        }
      }
    }
  }

  Future<void> _stopScanner() async {
    if (isScannerRunning) {
      try {
        await scannerController.stop();
        log('scanner is ${scannerController.value.isRunning}');
        setState(() {
          isScannerRunning = false;
        });
      } catch (e) {
        if (kDebugMode) {
          print("Error stopping scanner: $e");
        }
      }
    }
  }

  void _toggleScanner() {
    if (isScannerRunning) {
      _stopScanner();
    } else {
      _startScanner();
    }
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted && barcodes.barcodes.isNotEmpty && !isProcessing) {
      setState(() {
        isProcessing = true;
      });

      // Process the first detected barcode
      String code = barcodes.barcodes.first.rawValue ?? "Unknown";
      if (kDebugMode) {
        print("Scanned Code: $code");
      }

      // Simulate some processing delay
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            isProcessing = false;
          });
        }
      });
    }
  }

  // void initBluetooth() async {
  //   bool? isConnected = await bluetoothPrinter.isConnected;
  //   if (!isConnected!) {
  //     List<BluetoothDevice> devices = await bluetoothPrinter.getBondedDevices();
  //     if (devices.isNotEmpty) {
  //       BluetoothDevice targetDevice = devices.first;
  //       await bluetoothPrinter.connect(targetDevice);
  //     }
  //   }
  // }
  //
  // Future<void> printOrder() async {
  //   if (await bluetoothPrinter.isConnected ?? false) {
  //     bluetoothPrinter.printNewLine();
  //     bluetoothPrinter.printCustom("Order Details", 2, 1);
  //     bluetoothPrinter.printNewLine();
  //     // for (String product in order) {
  //     //   bluetoothPrinter.printCustom(product, 1, 1);
  //     //   bluetoothPrinter.printNewLine();
  //     // }
  //     // bluetoothPrinter.printCustom("Total items: ${order.length}", 1, 1);
  //     bluetoothPrinter.printNewLine();
  //     bluetoothPrinter.printCustom("Thank you!", 1, 1);
  //     bluetoothPrinter.printNewLine();
  //     bluetoothPrinter.paperCut();
  //   } else {
  //     if (kDebugMode) {
  //       print("Bluetooth printer not connected");
  //     }
  //   }
  // }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // If the controller is not ready, do not try to start or stop it.
    // Permission dialogs can trigger lifecycle changes before the controller is ready.
    if (!scannerController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      // Stop the scanner when the app is paused, hidden, or inactive.
      _subscription?.cancel();
      _subscription = null;
      _stopScanner();
    } else if (state == AppLifecycleState.resumed) {
      // Restart the scanner when the app is resumed.
      // Don't forget to resume listening to the barcode events.
      _subscription = scannerController.barcodes.listen(_handleBarcode);
      _startScanner();
    }
  }

  void _showDiscountDialog(BuildContext context) {
    showAdaptiveDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return _enterDiscountDialog(context);
      },
      useSafeArea: false,
      traversalEdgeBehavior: TraversalEdgeBehavior.leaveFlutterView,
    );
  }

  void _showChangeProductQtyDialog(BuildContext context, ProductModel orderProduct) {
    _qtyFocusNode.requestFocus();
    showAdaptiveDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return _changeProductQtyDialog(context, orderProduct);
      },
      useSafeArea: false,
      traversalEdgeBehavior: TraversalEdgeBehavior.leaveFlutterView,
    );
  }

  void _showAddCustomerDialog(BuildContext context) {
    showAdaptiveDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return _addCustomerDialog(context);
      },
      useSafeArea: false,
      traversalEdgeBehavior: TraversalEdgeBehavior.leaveFlutterView,
    );
  }

  Widget _enterDiscountDialog(BuildContext context) {
    return SimpleDialog(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder(
              valueListenable: isFlat,
              builder: (context, value, child) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: value ? Colors.blue : Colors.white),
                  onPressed: () {
                    isFlat.value = true;
                  },
                  child: SizedBox(
                    width: 60.w,
                    child: Text(
                      'Flat',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: value ? Colors.white : Colors.deepPurple),
                    ),
                  ),
                );
              },
            ),
            SizedBox(width: 10.w),
            ValueListenableBuilder(
              valueListenable: isFlat,
              builder: (context, value, child) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: !value ? Colors.blue : Colors.white),
                  onPressed: () {
                    isFlat.value = false;
                  },
                  child: SizedBox(
                    width: 60.w,
                    child: Text(
                      'Percentage',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: !value ? Colors.white : Colors.deepPurple),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(10.0).r,
          child: TextField(
            controller: _discountController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Discount',
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                discount = double.tryParse(_discountController.text)!;
                BlocProvider.of<OrderBloc>(context).add(OrderDiscountedEvent(discount: discount, isFlat: isFlat.value));
                log(isFlat.value.toString());
                log(discount.toString());
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text(
                'Ok',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _addCustomerDialog(BuildContext context) {
    return SimpleDialog(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0).r,
          child: TextField(
            controller: _customerController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Customer name',
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  customerName = _customerController.text;
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text(
                'Ok',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _changeProductQtyDialog(BuildContext context, ProductModel orderProduct) {
    _productQtyController.text = orderProduct.size.toString();
    return SimpleDialog(
      title: const Text(
        'Change Quantity',
        textAlign: TextAlign.center,
      ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, prodState) {
                if (prodState is ProductByIdLoaded) {
                  if (prodState.product.size > 0) {
                    return IconButton(
                      onPressed: () {
                        if (int.tryParse(_productQtyController.text)! >= 1) {
                          setState(() {
                            _productQtyController.text = (int.tryParse(_productQtyController.text)! - 1).toString();
                          });
                        }
                      },
                      icon: const Icon(Icons.remove),
                    );
                  } else {
                    return Container();
                  }
                } else {
                  return Container();
                }
              },
            ),
            Container(
              width: 100.w,
              padding: const EdgeInsets.all(10.0).r,
              child: TextField(
                focusNode: _qtyFocusNode,
                controller: _productQtyController,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, productState) {
                log('change qty dialog: prodState: $productState');
                if (productState is ProductByIdLoaded) {
                  log('prodState prod: $productState');
                  log('product: $orderProduct');
                  if (productState.product.size > orderProduct.size) {
                    return IconButton(
                      onPressed: () {
                        setState(() {
                          _productQtyController.text = (int.tryParse(_productQtyController.text)! + 1).toString();
                        });
                      },
                      icon: const Icon(Icons.add),
                    );
                  } else {
                    return Container();
                  }
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                if (int.tryParse(_productQtyController.text)! > 1) {
                  BlocProvider.of<OrderBloc>(context).add(
                    UpdateOrderProductQuantity(
                      product: orderProduct,
                      size: double.tryParse(_productQtyController.text)!,
                    ),
                  );
                } else if (int.tryParse(_productQtyController.text)! == 0) {
                  BlocProvider.of<OrderBloc>(context).add(RemoveProduct(orderProduct.id));
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text(
                'Confirm',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _productBlocListener(
    BuildContext context,
    ProductState productState,
    List<ProductModel> products,
    AppState appState,
  ) {
    if (productState is ProductNotFound) {
      _showAddNewProductDialog(
        context,
        _barcode!.rawValue!,
        null,
        false,
        appState.store,
      );
    }
    if (productState is ProductsByStoreIdLoaded) {
      _productList = productState.products ?? [];
    }
    if (productState is ProductSearchByBarcodeLoaded) {
      if (productState.product.size > 0) {
        if (!containsProduct(products, productState.product)) {
          BlocProvider.of<OrderBloc>(context).add(
            AddProduct(productState.product.copyWith(size: 1)),
          );
        } else {
          double qty = 0;
          for (var product in products) {
            if (product.id == productState.product.id && product.size < productState.product.size) {
              qty = product.size;
              BlocProvider.of<OrderBloc>(context).add(
                UpdateOrderProductQuantity(
                  product: productState.product,
                  size: qty + 1,
                ),
              );
              break;
            }
          }
        }
      } else {
        _showAddNewProductDialog(
          context,
          productState.product.barcode!,
          productState.product,
          true,
          appState.store,
        );
      }
    }
  }

  void _orderBlocListener(
    BuildContext context,
    OrderState orderState,
    List<ProductModel> products,
    AppState appState,
  ) {
    if (orderState is UpdatedOrderProducts) {
      if (orderState.products != null || orderState.products!.isNotEmpty) {
        products = orderState.products!;
        orderSubTotalAmount = orderState.products!.fold(
            0,
            (
              sum,
              product,
            ) =>
                sum + product.price * product.size);
        orderTotalAmount = orderSubTotalAmount;
      }
    }
    if (orderState is OrderCreating) {
      const Center(child: CircularProgressIndicator.adaptive());
    }
    if (orderState is OrderCreated) {
      _showSuccessfullDialog(
        context,
        orderState.user!,
        orderState.store,
        orderState.order,
      );
    }
    if (orderState is OrderDiscountState) {
      orderTotalAmount = orderState.isFlat ? orderSubTotalAmount - orderState.discount : (1 - orderState.discount / 100) * orderSubTotalAmount;
    }
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    // scannerController.stop();
    super.deactivate();
  }

  bool containsProduct(List<ProductModel> products, ProductModel product) {
    return products.contains(product);
  }

  @override
  void dispose() {
    // Stop listening to lifecycle changes.
    WidgetsBinding.instance.removeObserver(this);
    // Stop listening to the barcode events.
    _subscription?.cancel();
    _subscription = null;
    // Dispose the widget itself.
    super.dispose();
    // Finally, dispose of the controller.
    scannerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, appState) {
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
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              automaticallyImplyLeading: true,
              leading: InkWell(
                onTap: () {
                  BlocProvider.of<AppBloc>(context).add(const NavigateToHomeScreen());
                  scannerController.stop();
                },
                child: Icon(Icons.adaptive.arrow_back),
              ),
              title: const Text('Sale'),
              centerTitle: false,
              actions: [
                IconButton(
                  onPressed: () {
                    BlocProvider.of<ProductBloc>(context).add(FilterProductList(store: appState.store!, filter: ''));
                    _buildShowModalBottomSheet(context, appState.store!);
                  },
                  icon: const Icon(Icons.search),
                ),
                IconButton(
                  onPressed: () {
                    _showAddCustomerDialog(context);
                  },
                  icon: const Icon(Icons.person_add),
                ),
                IconButton(
                  onPressed: () {
                    scannerController.stop();
                  },
                  icon: const Icon(Icons.save),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.edit_note_outlined),
                ),
                IconButton(
                  onPressed: () {
                    _toggleScanner();
                  },
                  icon: const Icon(Icons.qr_code_2),
                ),
              ],
            ),
            body: SafeArea(
              child: Card(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      isScannerRunning
                          ? SizedBox(
                              width: size.width,
                              height: size.height * .3,
                              child: MobileScanner(
                                controller: scannerController,
                                onDetect: (capture) {
                                  final List<Barcode> barCodes = capture.barcodes;
                                  _barcode = barCodes.first;
                                  _playBeepSound();

                                  BlocProvider.of<ProductBloc>(context).add(
                                    FetchProductByBarcodeEvent(barCodes.first.rawValue!),
                                  );
                                },
                                errorBuilder: (context, error, child) {
                                  if (kDebugMode) {
                                    print(error);
                                  }
                                  return ScannerErrorWidget(error: error);
                                },
                              ),
                            )
                          : const SizedBox(),
                      const SizedBox(height: 5),
                      BlocListener<ProductBloc, ProductState>(
                        // listenWhen: (prev, current) => prev == current,
                        listener: (context, productState) {
                          _productBlocListener(context, productState, products, appState);
                        },

                        child: BlocConsumer<OrderBloc, OrderState>(
                          listener: (context, orderState) {
                            _orderBlocListener(context, orderState, products, appState);
                          },
                          builder: (context, orderState) {
                            if (orderState is OrderCreating) {
                              return const Center(
                                child: CircularProgressIndicator.adaptive(),
                              );
                            } else if (orderState is OrderError) {
                              return ErrorWidget(orderState.error);
                            } else if (orderState is UpdatedOrderProducts || orderState is OrderDiscountState) {
                              List<ProductModel> products = orderState is UpdatedOrderProducts
                                  ? orderState.products ?? []
                                  : orderState is OrderDiscountState
                                      ? orderState.products ?? []
                                      : [];
                              log('Builder: $orderState builder and producs: $products');
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey,
                                          offset: Offset(0, 0),
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                          blurStyle: BlurStyle.inner,
                                        ),
                                      ],
                                    ),
                                    height: isScannerRunning ? size.height * .34 : size.height * .64,
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: products.length,
                                      itemBuilder: (context, item) {
                                        ProductModel product = products[item];
                                        String pmt = product.productMeasurementType!;
                                        return CupertinoListTile(
                                          onTap: () {
                                            BlocProvider.of<ProductBloc>(context).add(FetchProductByIdEvent(product.id));
                                            _showChangeProductQtyDialog(
                                              context,
                                              product,
                                            );
                                          },
                                          leadingSize: 40.r,
                                          leading: DecoratedBox(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.grey,
                                              image: DecorationImage(
                                                image: product.image != null ? NetworkImage(product.image!) : const AssetImage(Assets.imagesImageBg),
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            product.name,
                                            softWrap: true,
                                          ),
                                          subtitle: Text(
                                            '${pmt == 'dona' ? product.size.toInt() : product.size} x ${formatAmount.format(product.price.toInt())}',
                                            style: TextStyle(fontSize: 14.sp),
                                          ),
                                          trailing: SizedBox(
                                            height: 32.sp,
                                            child: Text(
                                              formatAmount.format((product.size * product.price)),
                                              style: TextStyle(fontSize: 15.sp),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0, 0),
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      blurStyle: BlurStyle.inner,
                                    ),
                                  ],
                                ),
                                height: isScannerRunning ? size.height * .34 : size.height * .64,
                              );
                            }
                          },
                        ),
                      ),
                      BlocBuilder<OrderBloc, OrderState>(
                        builder: (context, orderState) {
                          if (orderState is OrderDiscountState || orderState is UpdatedOrderProducts) {
                            List<ProductModel> products = orderState is UpdatedOrderProducts
                                ? orderState.products!
                                : orderState is OrderDiscountState
                                    ? orderState.products!
                                    : [];
                            return buildSaleButtons(size, context, appState, products);
                          } else {
                            return buildSaleButtons(size, context, appState, products);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> _buildShowModalBottomSheet(BuildContext context, StoreModel store) {
    return showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      enableDrag: true,
      scrollControlDisabledMaxHeightRatio: MediaQuery.sizeOf(context).height * .9,
      anchorPoint: const Offset(0, .8),
      useSafeArea: true,
      builder: (context) {
        return _buildSearchBottomSheet(context, store);
      },
    );
  }

  Container _buildSearchBottomSheet(BuildContext context, StoreModel store) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height * .9,
      child: Column(
        children: [
          SaleButton(
            minWidth: MediaQuery.sizeOf(context).width,
            title: 'Add to order',
            onPressed: () {
              searchProductList.forEach((searchedProduct) {
                BlocProvider.of<OrderBloc>(context).add(
                  AddProduct(searchedProduct.copyWith(size: 1)),
                );
              });
              Navigator.pop(context);
            },
            bgColor: Colors.blue,
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search',
              alignLabelWithHint: true,
              fillColor: Colors.white,
              focusColor: Colors.white,
              hintStyle: const TextStyle(color: Colors.black),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: () {
                  _searchController.clear();
                },
                icon: const Icon(Icons.close),
              ),
            ),
            onChanged: (value) {
              _searchList.clear();
              BlocProvider.of<ProductBloc>(context).add(FilterProductList(filter: value, store: store));
            },
          ),
          SizedBox(height: 10.h),
          BlocBuilder<ProductBloc, ProductState>(
            builder: (context, productState) {
              if (productState is ProductLoading) {
                return SizedBox(
                  height: MediaQuery.sizeOf(context).height * .61.h,
                  child: const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                );
              } else if (productState is FilteredProductList) {
                var state = productState;
                _productList = state.filteredProducts;
                return SizedBox(
                  height: MediaQuery.sizeOf(context).height * .6.h,
                  child: SingleChildScrollView(
                    controller: _searchScrollController,
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      children: _productList
                          .asMap()
                          .entries
                          .map(
                            (entry) => InkWell(
                              onTap: () {
                                searchProductList.add(entry.value);
                              },
                              child: SizedBox(
                                width: 105.w,
                                height: 160.h,
                                child: Card(
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: 105.w,
                                        height: 105.w,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: entry.value.image != null
                                                ? NetworkImage(entry.value.image!)
                                                : const AssetImage(
                                                    Assets.imagesImageBg,
                                                  ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          color: Colors.black45.withOpacity(.5),
                                          width: double.infinity,
                                          height: 55.h,
                                          child: Text(
                                            '${entry.value.name}  \n${formatAmount.format(entry.value.price)} \n ${entry.value.productMeasurementType == ProductMeasurementType.dona.name ? entry.value.size.toInt().toString() + ' dona' : entry.value.productMeasurementType == ProductMeasurementType.kg.name ? entry.value.size.toString() + 'kg' : entry.value.productMeasurementType == ProductMeasurementType.l.name ? entry.value.size.toString() + 'l' : entry.value.size.toString() + 'm'}',
                                            style: TextStyle(color: Colors.white, fontSize: 12.sp),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                );
              } else {
                return ErrorWidget('Product Not found');
              }
            },
          ),
        ],
      ),
    );
  }

  Container buildSaleButtons(Size size, BuildContext context, AppState appState, List<ProductModel> products) {
    return Container(
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.black38))),
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                SaleProductPrice(title: 'Sub Total', price: formatAmount.format(orderSubTotalAmount)),
                SaleProductPrice(
                  title: 'Discount',
                  procedure: !isFlat.value
                      ? discount
                      : orderSubTotalAmount != 0
                          ? double.tryParse(((orderTotalAmount - orderSubTotalAmount) * 100 / orderSubTotalAmount).toStringAsFixed(3))
                          : 0,
                  discountingPrice: formatAmount.format(orderSubTotalAmount - orderTotalAmount),
                ),
                SaleProductPrice(title: 'Total', price: formatAmount.format(orderTotalAmount)),
              ],
            ),
            SizedBox(
              width: size.width,
              child: Wrap(
                alignment: WrapAlignment.spaceEvenly,
                children: [
                  SaleButton(
                    title: 'Save',
                    onPressed: () {
                      scannerController.stop();
                    },
                    bgColor: Colors.orange,
                  ),
                  SaleButton(
                    title: 'Discount',
                    onPressed: () {
                      _showDiscountDialog(context);
                    },
                    bgColor: Colors.blue,
                  ),
                  SaleButton(
                    title: 'Clear',
                    onPressed: () {
                      orderSubTotalAmount = 0;
                      orderTotalAmount = 0;
                      isFlat.value = false;
                      discount = 0;
                      setState(() {});
                      BlocProvider.of<OrderBloc>(context).add(ClearProductList());
                    },
                    bgColor: Colors.red,
                  ),
                  SaleButton(
                    title: 'Pay',
                    onPressed: () {
                      if (products.isNotEmpty) {
                        _showPayingDialog(context, appState.user!, appState.store!, products);
                      }
                      if (kDebugMode) {
                        print(scannerController.value.isRunning);
                      }
                    },
                    bgColor: Colors.green,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPayingDialog(BuildContext context, UserModel employee, StoreModel store, List<ProductModel> products) {
    showAdaptiveDialog(
      context: context,
      builder: (context) {
        return _buildPayingDialogWidget(context, employee, store, products);
      },
    );
  }

  SimpleDialog _buildPayingDialogWidget(BuildContext context, UserModel? employee, StoreModel? store, List<ProductModel> products) {
    log(_customerController.text);
    return SimpleDialog(
      titlePadding: EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
      title: Container(
        clipBehavior: Clip.none,
        color: Colors.blueGrey.withAlpha(100),
        height: 40.h,
        child: Center(
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
      ),
      children: [
        Column(
          children: [
            Text(
              store!.name,
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
                    customerName,
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
                    employee!.displayName ?? '',
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
                children: products
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
              title: 'Sub Total',
              price: formatAmount.format(orderSubTotalAmount),
              textAlign: TextAlign.start,
            ),
            SaleProductPrice(
              fontSize: 12,
              fontColor: Colors.grey,
              title: 'Discount',
              price: formatAmount.format(orderSubTotalAmount - orderTotalAmount),
              textAlign: TextAlign.start,
            ),
            SaleProductPrice(
              title: 'Total',
              price: formatAmount.format(orderTotalAmount),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                DateTime createdTime = DateTime.now();
                OrderModel order = OrderModel(
                  id: createdTime.microsecondsSinceEpoch.toString(),
                  customerName: customerName,
                  employeeName: employee.displayName ?? '',
                  productList: products,
                  totalAmount: orderTotalAmount,
                  orderDate: createdTime,
                  discountPrice: orderSubTotalAmount - orderTotalAmount,
                  storeId: store.id,
                );
                orderBarcode = generateBarcode('INV${createdTime.microsecondsSinceEpoch.toString()}', 'barcode');
                orderQrcode = generateBarcode(order.toString(), 'qrcode');
                order = order.copyWith(barcode: orderBarcode, qrcode: orderQrcode);
                log('order is $order');
                late StockModel stock;
                for (var product in products) {
                  stock = StockModel(id: product.id, storeId: store.id, size: product.size, mesurementType: product.productMeasurementType ?? ProductMeasurementType.dona.toString(), product: product);
                  BlocProvider.of<StockBloc>(context)
                      .add(AddUpdateStockProduct(product.id, product.size, product.productMeasurementType ?? ProductMeasurementType.dona.toString(), product, stock: stock));
                  BlocProvider.of<ProductBloc>(context).add(UpdateProductQuantity(product: product, store: store, size: product.size));
                }
                Navigator.pop(context);
                BlocProvider.of<OrderBloc>(context).add(
                  CreateOrderEvent(order, store, employee),
                );
                BlocProvider.of<OrderBloc>(context).add(ClearProductList());
                orderSubTotalAmount = 0;
                orderTotalAmount = 0;
                isFlat.value = false;
                discount = 0;
                setState(() {});
                // _showSuccessfullDialog(context, employee, store, order);
              },
              child: const Text('Confirm'),
            ),
          ],
        ),
      ],
    );
  }

  void _showSuccessfullDialog(BuildContext context, UserModel employee, StoreModel store, OrderModel order) {
    showAdaptiveDialog(
      context: context,
      builder: (context) {
        return _buildSuccessfullDialogWidget(context, employee, store, order);
      },
    );
  }

  SimpleDialog _buildSuccessfullDialogWidget(BuildContext context, UserModel? employee, StoreModel? store, OrderModel order) {
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
              store!.name,
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
                    customerName,
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
                    employee!.displayName ?? '',
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

  void _showAddNewProductDialog(
    BuildContext context,
    String barcode, [
    ProductModel? product,
    bool? isEdit,
    StoreModel? store,
  ]) {
    showDialog(
      context: context,
      builder: (context) {
        return AddProductDialog(
          scannerController: scannerController,
          product: product,
          barcode: barcode,
          isEdit: isEdit,
          store: store,
        );
      },
    );
  }
}
