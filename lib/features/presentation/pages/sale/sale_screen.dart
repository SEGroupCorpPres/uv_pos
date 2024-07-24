import 'dart:async';
import 'dart:io';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:uv_pos/app/presentation/bloc/auth/app_bloc.dart';
import 'package:uv_pos/features/data/remote/models/order_model.dart';
import 'package:uv_pos/features/data/remote/models/product_model.dart';
import 'package:uv_pos/features/data/remote/models/stock_model.dart';
import 'package:uv_pos/features/data/remote/models/store_model.dart';
import 'package:uv_pos/features/presentation/bloc/order/order_bloc.dart';
import 'package:uv_pos/features/presentation/bloc/product/product_bloc.dart';
import 'package:uv_pos/features/presentation/bloc/stock/stock_bloc.dart';
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
  BlueThermalPrinter bluetoothPrinter = BlueThermalPrinter.instance;
  StreamSubscription<BarcodeCapture>? _subscription;
  ValueNotifier<bool> isFlat = ValueNotifier<bool>(true);
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isProcessing = false;
  bool isScannerRunning = true;
  bool isSearch = false;
  Barcode? _barcode;
  double productAmount = 0;
  double orderSubTotalAmount = 0;
  double orderTotalAmount = 0;
  double discount = 0;

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

  void initBluetooth() async {
    bool? isConnected = await bluetoothPrinter.isConnected;
    if (!isConnected!) {
      List<BluetoothDevice> devices = await bluetoothPrinter.getBondedDevices();
      if (devices.isNotEmpty) {
        BluetoothDevice targetDevice = devices.first;
        await bluetoothPrinter.connect(targetDevice);
      }
    }
  }

  Future<void> printOrder() async {
    if (await bluetoothPrinter.isConnected ?? false) {
      bluetoothPrinter.printNewLine();
      bluetoothPrinter.printCustom("Order Details", 2, 1);
      bluetoothPrinter.printNewLine();
      // for (String product in order) {
      //   bluetoothPrinter.printCustom(product, 1, 1);
      //   bluetoothPrinter.printNewLine();
      // }
      // bluetoothPrinter.printCustom("Total items: ${order.length}", 1, 1);
      bluetoothPrinter.printNewLine();
      bluetoothPrinter.printCustom("Thank you!", 1, 1);
      bluetoothPrinter.printNewLine();
      bluetoothPrinter.paperCut();
    } else {
      if (kDebugMode) {
        print("Bluetooth printer not connected");
      }
    }
  }

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

  void _showDiscountDiaolg(BuildContext context) {
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
                context.read<OrderBloc>().add(OrderDiscountedEvent(discount: discount, isFlat: isFlat.value));
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

  @override
  void deactivate() {
    // TODO: implement deactivate
    scannerController.stop();
    super.deactivate();
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
        return Scaffold(
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
                      listener: (context, productState) {
                        if (productState is ProductNotFound) {
                          _showAddNewProductDialog(
                            context,
                            _barcode!.rawValue!,
                          );
                        }
                        if (productState is ProductSearchByBarcodeLoaded) {
                          if (productState.product.quantity == 0) {
                            _showAddNewProductDialog(
                              context,
                              productState.product.barcode,
                              productState.product,
                              true,
                              appState.store,
                            );
                          }
                          BlocProvider.of<OrderBloc>(context).add(AddProduct(productState.product.copyWith(quantity: 1)));
                        }
                      },
                      child: BlocListener<OrderBloc, OrderState>(
                        listener: (context, orderState) {
                          if (orderState is ProductAddToOrder) {
                            products = orderState.products;
                            orderSubTotalAmount = orderState.products.fold(0, (sum, product) => sum + product.price * product.quantity);
                            orderTotalAmount = orderSubTotalAmount;
                          }
                          if (orderState is OrderCreating) {
                            const Center(
                              child: CircularProgressIndicator.adaptive(),
                            );
                          }
                          if (orderState is OrderDiscountState) {
                            orderTotalAmount = orderState.isFlat ? orderSubTotalAmount - orderState.discount : (1 - orderState.discount / 100) * orderSubTotalAmount;
                          }
                          if (orderState is OrderCreated) {
                            showAdaptiveDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog.adaptive(
                                  title: const Text(
                                    'Paying successfully',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                  icon: const Icon(Icons.check_circle_outline),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text(
                                        'Ok',
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Column(
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
                                  return CupertinoListTile(
                                    title: Text(product.name),
                                    subtitle: Text('${product.quantity} * ${product.price}'),
                                    trailing: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('UZS ${product.quantity * product.price}'),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                if (product.quantity > 1) {
                                                  context.read<OrderBloc>().add(
                                                        UpdateOrderProductQuantity(
                                                          productId: product.id,
                                                          quantity: -1,
                                                        ),
                                                      );
                                                } else if (product.quantity == 0) {
                                                  context.read<OrderBloc>().add(RemoveProduct(product.id));
                                                }
                                              },
                                              icon: const Icon(Icons.remove),
                                            ),
                                            Text(product.quantity.toString()),
                                            IconButton(
                                              onPressed: () {
                                                context.read<OrderBloc>().add(
                                                      UpdateOrderProductQuantity(
                                                        productId: product.id,
                                                        quantity: 1,
                                                      ),
                                                    );
                                              },
                                              icon: const Icon(Icons.add),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            buildSaleButtons(size, context, appState),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Container buildSaleButtons(Size size, BuildContext context, AppState appState) {
    return Container(
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.black38))),
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                SaleProductPrice(title: 'Sub Total', price: 'UZS $orderSubTotalAmount'),
                SaleProductPrice(
                  title: 'Discount',
                  procedure: discount,
                  discountingPrice: orderSubTotalAmount - orderTotalAmount,
                ),
                SaleProductPrice(title: 'Total', price: 'UZS $orderTotalAmount '),
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
                      _showDiscountDiaolg(context);
                    },
                    bgColor: Colors.blue,
                  ),
                  SaleButton(
                    title: 'Clear',
                    onPressed: () {
                      context.read<OrderBloc>().add(ClearProductList());
                    },
                    bgColor: Colors.red,
                  ),
                  SaleButton(
                    title: 'Pay',
                    onPressed: () {
                      _showPayingDialog(context, appState.store!);
                      if (kDebugMode) {
                        print(scannerController.value.isRunning);
                      }
                      scannerController.stop();
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

  void _showPayingDialog(BuildContext context, StoreModel store) {
    showAdaptiveDialog(
      context: context,
      builder: (context) {
        return _buildPayingDialogWidget(
          context,
          store,
        );
      },
    );
  }

  SimpleDialog _buildPayingDialogWidget(BuildContext context, StoreModel? store) {
    return SimpleDialog(
      title: Text(
        '"Gul" MCHJ',
        textAlign: TextAlign.center,
        softWrap: true,
        style: TextStyle(
          color: Colors.black,
          fontSize: 24.sp,
        ),
      ),
      children: [
        Column(
          children: [
            SaleProductPrice(
              title: 'Sub Total',
              price: 'UZS $orderSubTotalAmount',
              textAlign: TextAlign.start,
            ),
            SaleProductPrice(
              title: 'Discount',
              procedure: discount,
              discountingPrice: orderSubTotalAmount - orderTotalAmount,
              textAlign: TextAlign.start,
            ),
            SaleProductPrice(
              title: 'Total',
              price: 'UZS $orderTotalAmount ',
              textAlign: TextAlign.start,
            ),
          ],
        ),
        SizedBox(
          height: 250.sp,
          width: 300.sp,
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: products.length,
            itemBuilder: (context, item) {
              ProductModel product = products[item];
              return CupertinoListTile(
                title: Text(product.name),
                subtitle: Text('${product.quantity} * ${product.price} UZS'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      product.quantity.toString(),
                      softWrap: true,
                    ),
                    Text('UZS ${product.quantity * product.price}'),
                  ],
                ),
              );
            },
          ),
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
                  customerId: '',
                  productList: products,
                  totalAmount: orderTotalAmount,
                  orderDate: createdTime,
                  storeId: store!.id,
                );
                late StockModel stock;
                for (var product in products) {
                  stock = StockModel(id: product.id, storeId: store.id, qty: product.quantity, product: product);
                  context.read<ProductBloc>().add(UpdateProductQuantity(product: product, store: store, quantity: product.quantity));
                  context.read<StockBloc>().add(AddUpdateStockProduct(product.id, product.quantity, product, stock: stock));
                }
                Navigator.pop(context);

                context.read<OrderBloc>().add(
                      CreateOrderEvent(order, store.id),
                    );
                context.read<OrderBloc>().add(ClearProductList());
              },
              child: const Text('Confirm'),
            ),
          ],
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
          product: product,
          barcode: barcode,
          isEdit: isEdit,
          store: store,
        );
      },
    );
  }
}
