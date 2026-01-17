import 'package:barcode/barcode.dart' as barcode;
// import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart' hide Barcode;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart' hide Barcode;
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'sale.dart';

class SaleScreen extends StatefulWidget {
  const SaleScreen({super.key});

  static Page page() => const MaterialPage(
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

  // List<ProductModel> _notifyProductList = [];
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

  List<OrderProductModel> products = [];

  // List<int> productQuantities = [];
  late OrderModel? order;
  DateTime dateTime = DateTime.now();
  final _flutterThermalPrinterPlugin = FlutterThermalPrinter.instance;
  StreamSubscription<List<Printer>>? _devicesStreamSubscription;
  List<Printer> printers = [];

  // Get Printer List
  void startScan() async {
    _devicesStreamSubscription?.cancel();
    await _flutterThermalPrinterPlugin.getPrinters(connectionTypes: [
      ConnectionType.USB,
      ConnectionType.BLE,
    ]);
    _devicesStreamSubscription =
        _flutterThermalPrinterPlugin.devicesStream.listen((List<Printer> event) {
      log(event.map((e) => e.name).toList().toString());
      setState(() {
        printers = event;
        printers.removeWhere((element) => element.name == null || element.name == '');
      });
    });
  }

  stopScan() {
    _flutterThermalPrinterPlugin.stopScan();
  }

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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      startScan();
    });
  }

  // Function to generate Barcode or QR Code
  String generateBarcode(String value, String type) {
    final barcodeType = type == 'barcode' ? barcode.Barcode.code128() : barcode.Barcode.qrCode();
    final svg = barcodeType.toSvg(value,
        width: type == 'barcode' ? 200 : 100, height: 100, fontHeight: 12.sp);
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
          log("Error starting scanner: $e");
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
          log("Error stopping scanner: $e");
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
  Future<Uint8List> generateFiscalReceiptPdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                  child: pw.Text('GOLD MARKET',
                      style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold))),
              pw.Text('STIR: 305123456'),
              pw.Text('Manzil: Toshkent, Chilonzor-5, 25-uy'),
              pw.Text('Tel: +998 90 123-45-67'),
              pw.SizedBox(height: 10),
              pw.Divider(),
              pw.Text('FISKAL CHEK', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text('Sana: 2025-05-08    Vaqt: 14:32:20'),
              pw.Text('Chek №: 0000456    Operator: Azimov O.'),
              pw.Divider(),
              pw.Text('Pepsi 1.5L gazli ichimlik'),
              pw.Text('2.00 litr x 6,000 UZS                     12,000'),
              pw.Text('Farmfresh Tuxum 10 dona'),
              pw.Text('2.00 dona x 1,500 UZS                     3,000'),
              pw.Text('➤ Chegirma: -500 UZS', style: pw.TextStyle(color: PdfColors.red)),
              pw.Text('Shakar Oq Kristall 1kg'),
              pw.Text('1.50 kg x 9,000 UZS                      13,500'),
              pw.Divider(),
              pw.Text('Ara-summa:                            28,500 UZS'),
              pw.Text('Umumiy chegirma:                        -500 UZS'),
              pw.Text('QQS (12%):                              3,360 UZS'),
              pw.Text('To‘lov turi: Naqd'),
              pw.Text('Umumiy to‘lov:                        28,000 UZS'),
              pw.Divider(),
              pw.Text('Fiskal belgi: 7AB3-C4D1-EF89'),
              pw.Text('[QR KOD: joy ajratilgan]'),
              pw.Divider(),
              pw.Center(child: pw.Text('RAHMAT! YANA KELING!')),
            ],
          );
        },
      ),
    );

    return pdf.save();
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

  void _showChangeProductQtyDialog(BuildContext context, OrderProductModel orderProduct) {
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
                  style:
                      ElevatedButton.styleFrom(backgroundColor: value ? Colors.blue : Colors.white),
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
                  style: ElevatedButton.styleFrom(
                      backgroundColor: !value ? Colors.blue : Colors.white),
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
                BlocProvider.of<OrderBloc>(context)
                    .add(OrderDiscountedEvent(discount: discount, isFlat: isFlat.value));
                if (kDebugMode) {
                  log(isFlat.value.toString());
                  log(discount.toString());
                }
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

  void _showAddCustomerDialog(BuildContext context) {
    showAdaptiveDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AddCustomerDialog(
          customerController: _customerController,
          onPressed: () {
            setState(() {
              customerName = _customerController.text;
            });
            Navigator.pop(context);
          },
        );
      },
      useSafeArea: false,
      traversalEdgeBehavior: TraversalEdgeBehavior.leaveFlutterView,
    );
  }

  Widget _changeProductQtyDialog(BuildContext context, OrderProductModel orderProduct) {
    _productQtyController.text = orderProduct.quantity.toString();
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
                  if (1 > 0) {
                    return IconButton(
                      onPressed: () {
                        if (int.tryParse(_productQtyController.text)! >= 1) {
                          setState(() {
                            _productQtyController.text =
                                (int.tryParse(_productQtyController.text)! - 1).toString();
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
                if (kDebugMode) {
                  log('change qty dialog: prodState: $productState');
                }
                if (productState is ProductByIdLoaded) {
                  if (kDebugMode) {
                    log('prodState prod: $productState');
                    log('product: $orderProduct');
                  }
                  if (14 > orderProduct.quantity) {
                    return IconButton(
                      onPressed: () {
                        setState(() {
                          _productQtyController.text =
                              (int.tryParse(_productQtyController.text)! + 1).toString();
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
                      stock: double.tryParse(_productQtyController.text)!,
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
    List<OrderProductModel> products,
    AppState appState,
  ) {
    if (productState is ProductNotFound) {
      // _showAddNewProductDialog(
      //   context,
      //   _barcode!.rawValue!,
      //   null,
      //   false,
      //   appState.storeID,
      // );
    }
    if (productState is ProductsLoaded) {
      _productList = productState.products ?? [];
    }
    if (productState is ProductSearchByBarcodeLoaded) {
      OrderProductModel orderProduct = OrderProductModel(
        id: productState.product.id,
        name: productState.product.name,
        price: productState.product.sellingPrice,
        thumbnail: productState.product.thumbnail,
        quantity: 1,
        totalProductPrice: productState.product.sellingPrice,
        discountedTotalPrice: productState.product.sellingPrice,
        discountPercentage: 0,
        productMeasurementUnit: productState.product.unit!,
      );

      // if (productState.product.stock > 0) {
      //   if (!containsProduct(products, productState.product)) {
      //     BlocProvider.of<OrderBloc>(context).add(
      //       AddProduct(orderProduct),
      //     );
      //   } else {
      //     double qty = 0;
      //     for (var product in products) {
      //       if (product.id == productState.product.id &&
      //           product.quantity < productState.product.stock) {
      //         qty = product.quantity;
      //         BlocProvider.of<OrderBloc>(context).add(
      //           UpdateOrderProductQuantity(
      //             product: orderProduct,
      //             stock: qty + 1,
      //           ),
      //         );
      //         break;
      //       }
      //     }
      //   }
      // } else {
      //   _showAddNewProductDialog(
      //     context,
      //     productState.product.meta.barcode,
      //     productState.product,
      //     true,
      //     appState.store,
      //   );
      // }
    }
  }

  void _orderBlocListener(
    BuildContext context,
    OrderState orderState,
    List<OrderProductModel> products,
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
                sum + product.price * product.quantity);
        orderTotalAmount = orderSubTotalAmount;
      }
    }
    if (orderState is OrderCreating) {
      const Center(child: CircularProgressIndicator.adaptive());
    }
    if (orderState is OrderCreated) {
      // _showSuccessFullDialog(
      //   context,
      //   orderState.uid!,
      //   orderState.storeID,
      //   orderState.order,
      // );
    }
    if (orderState is OrderDiscountState) {
      orderTotalAmount = orderState.isFlat
          ? orderSubTotalAmount - orderState.discount
          : (1 - orderState.discount / 100) * orderSubTotalAmount;
    }
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    // scannerController.stop();
    super.deactivate();
  }

  bool containsProduct(List<OrderProductModel> products, ProductModel product) {
    OrderProductModel orderProduct = OrderProductModel(
      id: product.id,
      name: product.name,
      price: product.sellingPrice,
      thumbnail: product.thumbnail,
      quantity: 1,
      totalProductPrice: product.sellingPrice,
      discountedTotalPrice: product.sellingPrice,
      discountPercentage: 0,
      productMeasurementUnit: product.unit!,
    );

    return products.contains(orderProduct);
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
                    BlocProvider.of<ProductBloc>(context)
                        .add(FilterProductList(storeID: appState.storeID!, filter: ''));
                    _buildShowModalBottomSheet(context, appState.storeID!);
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
                                errorBuilder: (context, error, ) {
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
                            log(orderState.toString());
                            if (orderState is OrderCreating) {
                              return const Center(
                                child: CircularProgressIndicator.adaptive(),
                              );
                            } else if (orderState is OrderError) {
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
                            } else if (orderState is UpdatedOrderProducts ||
                                orderState is OrderDiscountState) {
                              List<OrderProductModel> products = orderState is UpdatedOrderProducts
                                  ? orderState.products ?? []
                                  : orderState is OrderDiscountState
                                      ? orderState.products ?? []
                                      : [];
                              if (kDebugMode) {
                                log('Builder: $orderState builder and products: $products');
                              }
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
                                    height:
                                        isScannerRunning ? size.height * .34 : size.height * .64,
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: products.length,
                                      itemBuilder: (context, item) {
                                        OrderProductModel product = products[item];
                                        String pmt = product.productMeasurementUnit;
                                        return CupertinoListTile(
                                          onTap: () {
                                            BlocProvider.of<ProductBloc>(context)
                                                .add(FetchProductByIdEvent(product.id));
                                            _showChangeProductQtyDialog(
                                              context,
                                              product,
                                            );
                                          },
                                          leadingSize: 40.r,
                                          leading: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.grey,
                                              image: DecorationImage(
                                                image: product.thumbnail != null
                                                    ? NetworkImage(product.thumbnail!)
                                                    : const AssetImage(Assets.imagesImageBg),
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            product.name,
                                            softWrap: true,
                                          ),
                                          subtitle: Text(
                                            '${pmt == 'dona' ? product.quantity.toInt() : product.quantity} x ${formatAmount.format(product.price.toInt())}',
                                            style: TextStyle(fontSize: 14.sp),
                                          ),
                                          trailing: SizedBox(
                                            height: 32.sp,
                                            child: Text(
                                              formatAmount
                                                  .format((product.quantity * product.price)),
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
                          if (orderState is OrderDiscountState ||
                              orderState is UpdatedOrderProducts) {
                            List<OrderProductModel> products = orderState is UpdatedOrderProducts
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

  Future<dynamic> _buildShowModalBottomSheet(BuildContext context, String storeID) {
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
        return _buildSearchBottomSheet(context, storeID);
      },
    );
  }

  Container _buildSearchBottomSheet(BuildContext context, String storeID) {
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
                OrderProductModel orderProduct = OrderProductModel(
                  id: searchedProduct.id,
                  name: searchedProduct.name,
                  price: searchedProduct.sellingPrice,
                  thumbnail: searchedProduct.thumbnail,
                  quantity: 1,
                  totalProductPrice: searchedProduct.sellingPrice,
                  discountedTotalPrice: searchedProduct.sellingPrice,
                  discountPercentage: 0,
                  productMeasurementUnit: 'son',
                );

                BlocProvider.of<OrderBloc>(context).add(
                  AddProduct(orderProduct.copyWith(quantity: 1)),
                );
              });
              searchProductList.clear();
              Navigator.pop(context);
            },
            bgColor: Colors.blue,
          ),
          SizedBox(height: 10),
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
              BlocProvider.of<ProductBloc>(context)
                  .add(FilterProductList(filter: value, storeID: storeID));
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
                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height * .6.h,
                  child: SingleChildScrollView(
                    controller: _searchScrollController,
                    child: Wrap(
                      runAlignment: WrapAlignment.start,
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
                                            image: entry.value.thumbnail != null
                                                ? NetworkImage(entry.value.thumbnail!)
                                                : const AssetImage(
                                                    Assets.imagesImageBg,
                                                  ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      // Align(
                                      //   alignment: Alignment.bottomCenter,
                                      //   child: Container(
                                      //     color: Colors.black45.withValues(alpha: .5),
                                      //     width: double.infinity,
                                      //     height: 55.h,
                                      //     child: Text(
                                      //       '${entry.value.name}  \n${formatAmount.format(entry.value.sellingPrice)} \n ${entry.value.unit == ProductMeasurementUnit.dona.name ? entry.value.stock.toInt().toString() + ' dona' : entry.value.productMeasurementUnit == ProductMeasurementUnit.kg.name ? entry.value.stock.toString() + 'kg' : entry.value.productMeasurementUnit == ProductMeasurementUnit.l.name ? entry.value.stock.toString() + 'l' : entry.value.stock.toString() + 'm'}',
                                      //       style: TextStyle(color: Colors.white, fontSize: 12.sp),
                                      //       textAlign: TextAlign.center,
                                      //     ),
                                      //   ),
                                      // ),
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
                return Text('Product Not found');
              }
            },
          ),
        ],
      ),
    );
  }

  Container buildSaleButtons(
      Size size, BuildContext context, AppState appState, List<OrderProductModel> products) {
    return Container(
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.black38))),
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                SaleProductPrice(
                    title: 'Sub Total', price: formatAmount.format(orderSubTotalAmount)),
                SaleProductPrice(
                  title: 'Discount',
                  procedure: !isFlat.value
                      ? discount
                      : orderSubTotalAmount != 0
                          ? double.tryParse(
                              ((orderTotalAmount - orderSubTotalAmount) * 100 / orderSubTotalAmount)
                                  .toStringAsFixed(3))
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
                        _showPayingDialog(context, appState.userID!, appState.storeID!, products);
                      }
                      if (kDebugMode) {
                        log(scannerController.value.isRunning.toString());
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

  void  _showPayingDialog(BuildContext context, String uid, String storeID,
      List<OrderProductModel> products) {
    showAdaptiveDialog(
      context: context,
      builder: (context) {
        return _buildPayingDialogWidget(context, uid, storeID, products);
      },
    );
  }

  SimpleDialog _buildPayingDialogWidget(BuildContext context, String? uid,
      String? storeID, List<OrderProductModel> products) {
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
              storeID!,
              textAlign: TextAlign.center,
              softWrap: true,
              style: TextStyle(
                color: Colors.black,
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              storeID,
              textAlign: TextAlign.center,
              softWrap: true,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.sp,
              ),
            ),
            Text(
              storeID,
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
              SizedBox(height: 5.h),
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
                    uid!,
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
                        qty: '${entry.value.quantity} x ${entry.value.price}',
                        price: (entry.value.price * entry.value.quantity).toString(),
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
                  employeeName: uid,
                  productList: products,
                  totalAmount: orderTotalAmount,
                  orderDate: createdTime,
                  discountPrice: orderSubTotalAmount - orderTotalAmount,
                  storeId: storeID,
                );
                orderBarcode = generateBarcode(
                    'INV${createdTime.microsecondsSinceEpoch.toString()}', 'barcode');
                orderQrcode = generateBarcode(order.toString(), 'qrcode');
                order = order.copyWith(barcode: orderBarcode, qrcode: orderQrcode);
                if (kDebugMode) {
                  log('order is $order');
                }
                late StockModel stock;
                for (OrderProductModel product in products) {
                  stock = StockModel(
                    id: product.id,
                    storeId: storeID,
                    productId: product.id,
                    qty: product.quantity,
                    name: product.name,
                    createdAt: Timestamp.now(),
                    updatedAt: Timestamp.now(),
                    branchId: storeID,
                    minQty: 0,
                    lastOutDate: Timestamp.now(),
                    lastRestockDate: Timestamp.now(),
                  );

                  BlocProvider.of<StockBloc>(context).add(UpdateStockEvent(
                      stock: stock, storeID: storeID));
                }
                Navigator.pop(context);
                BlocProvider.of<OrderBloc>(context).add(
                  CreateOrderEvent(order, storeID, uid),
                );
                BlocProvider.of<OrderBloc>(context).add(ClearProductList());
                orderSubTotalAmount = 0;
                orderTotalAmount = 0;
                isFlat.value = false;
                discount = 0;
                setState(() {});
                // _showSuccessFullDialog(context, employee, store, order);
              },
              child: const Text('Confirm'),
            ),
          ],
        ),
      ],
    );
  }

  void _showSuccessFullDialog(
      BuildContext context, UserModel employee, StoreModel store, OrderModel order) {
    showAdaptiveDialog(
      context: context,
      builder: (context) {
        return _buildSuccessFullDialogWidget(context, employee, store, order);
      },
    );
  }

  SimpleDialog _buildSuccessFullDialogWidget(
      BuildContext context, UserModel? employee, StoreModel? store, OrderModel order) {
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
              SizedBox(height: 5.h),
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
                        qty: '${entry.value.quantity} x ${entry.value.price}',
                        price: (entry.value.price * entry.value.quantity).toString(),
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
                style: TextButton.styleFrom(
                  backgroundColor: CupertinoColors.activeBlue,
                  minimumSize: Size(
                    100.w,
                    30.h,
                  ),
                ),
                onPressed: () async {
                  // final printer = PrinterService();
                  // await printer.printReceipt();
                  Navigator.pop(context);
                },
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
          productID: product!.id,
          barcode: barcode,
          isEdit: isEdit,
          storeID: store!.id,
        );
      },
    );
  }

  Future<List<int>> _generateReceipt() async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];
    bytes += generator.text(
      "Teste Network print",
      styles: const PosStyles(
        bold: true,
        height: PosTextSize.size3,
        width: PosTextSize.size3,
      ),
    );
    bytes += generator.cut();
    return bytes;
  }

  Widget receiptWidget(String printerType) {
    return SizedBox(
      width: 550,
      child: Material(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'FLUTTER THERMAL PRINTER',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(thickness: 2),
              const SizedBox(height: 10),
              _buildReceiptRow('Item', 'Price'),
              const Divider(),
              _buildReceiptRow('Apple', '\$1.00'),
              _buildReceiptRow('Banana', '\$0.50'),
              _buildReceiptRow('Orange', '\$0.75'),
              const Divider(thickness: 2),
              _buildReceiptRow('Total', '\$2.25', isBold: true),
              const SizedBox(height: 20),
              _buildReceiptRow('Printer Type', printerType),
              const SizedBox(height: 50),
              const Center(
                child: Text(
                  'Thank you for your purchase!',
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildReceiptRow(String leftText, String rightText, {bool isBold = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          leftText,
          style: TextStyle(fontSize: 16, fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        ),
        Text(
          rightText,
          style: TextStyle(fontSize: 16, fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        ),
      ],
    ),
  );
}
