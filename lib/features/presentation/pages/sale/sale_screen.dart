import 'dart:async';
import 'dart:io';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:uv_pos/app/presentation/bloc/auth/app_bloc.dart';
import 'package:uv_pos/features/data/remote/models/order_model.dart';
import 'package:uv_pos/features/data/remote/models/product_model.dart';
import 'package:uv_pos/features/presentation/bloc/order/order_bloc.dart';
import 'package:uv_pos/features/presentation/bloc/product/product_bloc.dart';
import 'package:uv_pos/features/presentation/widgets/sale_button.dart';
import 'package:uv_pos/features/presentation/widgets/sale_product_price.dart';
import 'package:uv_pos/features/presentation/widgets/scanner_error.dart';
import 'package:uv_pos/features/presentation/widgets/store/add_product_dialog.dart';

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
  bool isProcessing = false;
  bool isScannerRunning = true;
  bool isSearch = false;
  Barcode? _barcode;
  double productAmount = 0;
  double orderSubTotalAmount = 0;
  double orderTotalAmount = 0;
  double discount = 0;
  bool isFlat = true;
  int productQty = 1;

  // List<ProductModel> products = [];
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

      // setState(() {
      //   order.add(code);
      // });

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

  // Mahsulotlarni qo'shish uchun usul
  // void addProduct(ProductModel product) {
  //   setState(() {
  //     products.add(product);
  //     productQuantities.add(1);
  //     calculateAmounts(); // Har bir yangi mahsulot uchun boshlang'ich miqdor 1
  //   });
  // }

  // // Jami summani hisoblash
  // void calculateAmounts() {
  //   orderSubTotalAmount = 0.0;
  //   for (int i = 0; i < products.length; i++) {
  //     orderSubTotalAmount += productQuantities[i] * products[i].price;
  //   }
  //   orderTotalAmount = (orderSubTotalAmount * 100) / (int.parse(_discountController.text) + 100);
  //   if (kDebugMode) {
  //     print("Subtotal: $orderSubTotalAmount, Total: $orderTotalAmount");
  //   }
  //   setState(() {});
  // }

  void _showDiscountDiaolg(BuildContext context) {
    showAdaptiveDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return _enterDiscountDialog(context);
      },
    );
  }

  Widget _enterDiscountDialog(BuildContext context) {
    return SimpleDialog(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isFlat = true;
                });
              },
              child: SizedBox(
                width: 60.w,
                child: const Text('Flat', textAlign: TextAlign.center),
              ),
            ),
            SizedBox(width: 10.w),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isFlat = false;
                });
              },
              child: SizedBox(
                width: 60.w,
                child: const Text('Percentage', textAlign: TextAlign.center),
              ),
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
                setState(() {
                  discount = double.tryParse(_discountController.text)!;
                });
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
                  BlocConsumer<OrderBloc, OrderState>(
                    listener: (context, orderState) {
                      // TODO: implement listener
                    },
                    builder: (context, orderState) {
                      print(orderState);
                      if (orderState is OrderInitial) {
                        return Container();
                      }  
                      if (orderState is ProductAddToOrder) {
                        List<ProductModel> products = [];
                        double totalPrice = 0;
                        double discountedPrice = 0;
                        if (orderState.products.isNotEmpty) {
                          products = orderState.products;
                          totalPrice = orderState.products.fold(0, (sum, product) => sum + product.price * product.quantity);
                          discountedPrice = isFlat ? totalPrice * (1 - discount) : (totalPrice * 100) / (discount + 100);
                        }
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BlocConsumer<ProductBloc, ProductState>(
                              listener: (context, productState) {
                                if (productState is ProductNotFound) {
                                  _showAddNewProductDialog(context, _barcode!.rawValue!);
                                }
                                if (productState is ProductSearchByBarcodeLoaded) {
                                  BlocProvider.of<OrderBloc>(context).add(AddProduct(productState.product.copyWith(quantity: 1)));
                                }
                              },
                              builder: (context, productState) {
                                print(productState);

                                if (productState is ProductSearchByBarcodeLoaded) {
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
                                              Text((product.quantity * product.price).toString()),
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
                                  );
                                } else if (productState is ProductNotFound) {
                                  return Container();
                                }  else{
                                  return Container();
                                }
                              },
                            ),
                            Container(
                              decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.black38))),
                              width: double.infinity,
                              height: size.height * .23,
                              child: Column(
                                children: [
                                  Column(
                                    children: [
                                      SaleProductPrice(title: 'Sub Total', price: '\$ $totalPrice'),
                                      SaleProductPrice(title: 'Discount', price: '\$ $discount', procedure: 0),
                                      SaleProductPrice(title: 'Total', price: '\$ $discountedPrice '),
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
                                            OrderModel orderMOdel = OrderModel(
                                              id: dateTime.microsecondsSinceEpoch.toString(),
                                              customerId: dateTime.millisecondsSinceEpoch.toString(),
                                              productList: products,
                                              totalAmount: orderTotalAmount,
                                              orderDate: dateTime,
                                              storeId: appState.store!.id,
                                            );
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
                          ],
                        );
                      } else if (orderState is OrderError) {
                        return Container();
                      } else {
                        return Container();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAddNewProductDialog(BuildContext context, String barcode) {
    showDialog(
      context: context,
      builder: (context) {
        return AddProductDialog(barcode: barcode);
      },
    );
  }
}
