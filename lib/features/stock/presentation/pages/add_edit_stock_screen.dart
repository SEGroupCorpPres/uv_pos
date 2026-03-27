// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';

// import '../../../../app/presentation/pages/pages.dart';

// class AddEditStockScreen extends StatefulWidget {
//   const AddEditStockScreen({super.key});

//   static Page page() => const MaterialPage(
//         child: AddEditStockScreen(),
//       );

//   @override
//   State<AddEditStockScreen> createState() => _AddEditStockScreenState();
// }

// class _AddEditStockScreenState extends State<AddEditStockScreen> with WidgetsBindingObserver {
//   late TextEditingController _productNameController = TextEditingController();
//   late final TextEditingController _productBarcodeController = TextEditingController();
//   late final TextEditingController _productNoteController = TextEditingController();
//   late final TextEditingController _productQtyController = TextEditingController();
//   late final TextEditingController _productNotifyQtyController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>(debugLabel: 'createStockFormKey');
//   late MobileScannerController scannerController = MobileScannerController(
//     detectionSpeed: DetectionSpeed.noDuplicates,
//     autoStart: false,
//   );
//   bool isScannerRunning = true;
//   Barcode? _barcode;
//   StreamSubscription<BarcodeCapture>? _subscription;
//   final AudioPlayer _audioPlayer = AudioPlayer();

//   bool isProcessing = false;

//   @override
//   void initState() {
//     super.initState();
//     // Start listening to lifecycle changes.
//     WidgetsBinding.instance.addObserver(this);

//     // Start listening to the barcode events.
//     _subscription = scannerController.barcodes.listen(_handleBarcode);
//     if (kDebugMode) {}
//     // Start the scanner initially.
//     if (!scannerController.value.isRunning) {
//       _startScanner();
//     }
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       // startScan();
//     });
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     // If the controller is not ready, do not try to start or stop it.
//     // Permission dialogs can trigger lifecycle changes before the controller is ready.
//     if (!scannerController.value.isInitialized) {
//       return;
//     }

//     if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
//       // Stop the scanner when the app is paused, hidden, or inactive.
//       _subscription?.cancel();
//       _subscription = null;
//       _stopScanner();
//     } else if (state == AppLifecycleState.resumed) {
//       // Restart the scanner when the app is resumed.
//       // Don't forget to resume listening to the barcode events.
//       _subscription = scannerController.barcodes.listen(_handleBarcode);
//       _startScanner();
//     }
//   }

//   Future<void> _playBeepSound() async {
//     await _audioPlayer.setAsset(Assets.soundsBeep);
//     _audioPlayer.play();
//   }

//   Future<void> _startScanner() async {
//     if (!isScannerRunning) {
//       try {
//         await scannerController.start();
//         setState(() {
//           isScannerRunning = true;
//         });
//       } catch (e) {
//         if (kDebugMode) {
//           log("Error starting scanner: $e");
//         }
//       }
//     }
//   }

//   Future<void> _stopScanner() async {
//     if (isScannerRunning) {
//       try {
//         await scannerController.stop();
//         setState(() {
//           isScannerRunning = false;
//         });
//       } catch (e) {
//         if (kDebugMode) {
//           log("Error stopping scanner: $e");
//         }
//       }
//     }
//   }

//   void _toggleScanner() {
//     if (isScannerRunning) {
//       _stopScanner();
//     } else {
//       _startScanner();
//     }
//   }

//   void _handleBarcode(BarcodeCapture barcodes) {
//     if (mounted && barcodes.barcodes.isNotEmpty && !isProcessing) {
//       setState(() {
//         isProcessing = true;
//       });

//       // Process the first detected barcode
//       String code = barcodes.barcodes.first.rawValue ?? "Unknown";
//       // Simulate some processing delay
//       Future.delayed(const Duration(seconds: 1), () {
//         if (mounted) {
//           setState(() {
//             isProcessing = false;
//           });
//         }
//       });
//     }
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     _productNameController.dispose();
//     _productBarcodeController.dispose();
//     _productNoteController.dispose();
//     _productQtyController.dispose();
//     _productNotifyQtyController.dispose();
//     // Stop listening to lifecycle changes.
//     WidgetsBinding.instance.removeObserver(this);
//     // Stop listening to the barcode events.
//     _subscription?.cancel();
//     _subscription = null;
//     // Dispose the widget itself.
//     super.dispose();
//     // Finally, dispose of the controller.
//     scannerController.dispose();
//   }

//   void _showAddNewProductDialog(
//     BuildContext context,
//     String barcode, [
//     String? productID,
//     bool? isEdit,
//     String? storeID,
//   ]) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AddProductDialog(
//           scannerController: scannerController,
//           productID: productID,
//           barcode: barcode,
//           isEdit: isEdit,
//           storeID: storeID,
//         );
//       },
//     );
//   }

//   void _productBlocListener(
//     BuildContext context,
//     ProductState productState,
//     AppState appState,
//   ) {
//     if (productState is ProductNotFound) {
//       _showAddNewProductDialog(
//         context,
//         _barcode!.rawValue!,
//         null,
//         false,
//         appState.storeID,
//       );
//     }
//     if (productState is ProductSearchByBarcodeLoaded) {
//       _productNameController = TextEditingController(text: productState.product.name);
//     } else if (productState is ProductNotFound) {
//       _showAddNewProductDialog(
//         context,
//         _barcode!.rawValue!,
//         null,
//         false,
//         appState.storeID,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.sizeOf(context);
//     return BlocBuilder<AppBloc, AppState>(
//       builder: (context, appState) {
//         return PopScope(
//           canPop: false,
//           onPopInvokedWithResult: (bool didPop, result) {
//             if (didPop) {
//               return;
//             }
//             context.read<AppBloc>().add(
//                   NavigateToStocksScreen(storeID: appState.storeID!),
//                 );
//           },
//           child: Scaffold(
//             appBar: AppBar(
//               automaticallyImplyLeading: true,
//               leading: InkWell(
//                 onTap: () {
//                   BlocProvider.of<AppBloc>(context).add(
//                     NavigateToProductListScreen(storeID: appState.storeID),
//                   );
//                   BlocProvider.of<ProductBloc>(context)
//                       .add(LoadProductsEvent(storeID: appState.storeID!));
//                 },
//                 child: Icon(Icons.adaptive.arrow_back),
//               ),
//               title: Text(!appState.isEdit ? 'Maxsulotni yaratish' : 'Maxsulotni tahrirlash'),
//               centerTitle: false,
//               actions: _buildCreateEditProductScreenAppBarActions(
//                   context: context, isEdit: appState.isEdit, storeID: appState.storeID!),
//             ),
//             body: BlocConsumer<StockBloc, StockState>(
//               listener: (context, state) {
//                 _stockBlocListener(
//                     context: context,
//                     state: state,
//                     isEdit: appState.isEdit,
//                     storeID: appState.storeID!);
//               },
//               builder: (context, state) {
//                 if (appState.isEdit) {
//                   if (state is ProductCreating || state is ProductUpdating) {
//                     return const Center(child: CircularProgressIndicator.adaptive());
//                   } else if (state is StockCreating || state is StockUpdating) {
//                     return Container(
//                       width: size.width,
//                       height: ScreenUtil.defaultSize.height,
//                       child: Center(child: CircularProgressIndicator.adaptive()),
//                     );
//                   } else if (state is StockError) {
//                     return ErrorWidget(state.error);
//                   } else if (state is FetchStockById) {
//                     return SingleChildScrollView(
//                       child: _buildCreateEditStockFormWidget(
//                           size: size, appState: appState, context: context, stock: state.stock),
//                     );
//                   }
//                 } else {
//                   return SingleChildScrollView(
//                     child: _buildCreateEditStockFormWidget(
//                         size: size, appState: appState, context: context, stock: null),
//                   );
//                 }
//                 return Container();
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }

//   List<Widget> _buildCreateEditProductScreenAppBarActions({
//     required BuildContext context,
//     required bool isEdit,
//     required String storeID,
//   }) {
//     return [
//       BlocBuilder<StockBloc, StockState>(
//         builder: (context, state) {
//           if (isEdit) {
//             if (state is StockLoading) {
//               return Container();
//             } else if (state is StockError) {
//               return ErrorWidget(state.error);
//             } else if (state is FetchStockById) {
//               return TextButton.icon(
//                 onPressed: () => _createEditStockMethod(
//                     context: context, isEdit: true, stockModel: state.stock, storeID: storeID),
//                 icon: const Icon(Icons.save),
//                 label: const Text('Taxrirlash'),
//               );
//             } else {
//               return Container();
//             }
//           } else {
//             return TextButton.icon(
//               onPressed: () => _createEditStockMethod(
//                   context: context, isEdit: false, stockModel: null, storeID: storeID),
//               icon: const Icon(Icons.save),
//               label: const Text('Qo\'shish'),
//             );
//           }
//         },
//       ),
//     ];
//   }

//   void _createEditStockMethod(
//       {required BuildContext context,
//       required bool isEdit,
//       required StockModel? stockModel,
//       required String storeID}) {
//     if (_formKey.currentState?.validate() ?? false) {
//       final createdDate = Timestamp.now();

//       String id = '';
//       if (!isEdit) {
//         id = createdDate.microsecondsSinceEpoch.toString();
//       } else {
//         id = stockModel!.id;
//       }

//       final StockModel stock = StockModel(
//         id: id,
//         storeId: storeID,
//         productId: id,
//         name: _productNameController.text,
//         branchId: '',
//         qty: double.parse(_productQtyController.text),
//         minQty: double.parse(_productNotifyQtyController.text),
//         lastRestockDate: Timestamp.now(),
//         lastOutDate: Timestamp.now(),
//         createdAt: isEdit ? stockModel!.createdAt : Timestamp.now(),
//         updatedAt: Timestamp.now(),
//       );
//       if (!isEdit) {
//         context.read<StockBloc>().add(CreateStockEvent(stock: stock, storeID: storeID));
//       } else {
//         context.read<StockBloc>().add(UpdateStockEvent(stock: stock, storeID: storeID));
//       }
//     }
//   }

//   void _stockBlocListener(
//       {required BuildContext context,
//       required StockState state,
//       required bool isEdit,
//       required String storeID}) {
//     if (state is StockCreated || state is StockUpdated) {
//       // Navigate back or show a success message when the product is created
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(!isEdit ? 'Stock bazaga qo\'shildi' : 'Stock tahrirlandi')));
//       BlocProvider.of<AppBloc>(context).add(
//         NavigateToStocksScreen(storeID: storeID),
//       );
//     } else if (state is StockError) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Xato: ${state.error}')));
//     }
//   }

//   BlocConsumer<ProductBloc, ProductState> _buildCreateEditStockFormWidget({
//     required Size size,
//     required AppState appState,
//     required BuildContext context,
//     required StockModel? stock,
//   }) {
//     return BlocConsumer<ProductBloc, ProductState>(
//       listener: (context, state) {
//         _productBlocListener(context, state, appState);
//       },
//       builder: (context, state) {
//         if (state is ProductLoading) {
//           return Center(
//             child: CircularProgressIndicator.adaptive(),
//           );
//         }
//         if (state is ProductError) {
//           return ErrorWidget(state.error);
//         }
//         return Column(
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 10.w),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     isScannerRunning
//                         ? SizedBox(
//                             width: size.width,
//                             height: size.height * .3,
//                             child: MobileScanner(
//                               controller: scannerController,
//                               onDetect: (capture) {
//                                 final List<Barcode> barCodes = capture.barcodes;
//                                 _barcode = barCodes.first;
//                                 _playBeepSound();
//                                 BlocProvider.of<ProductBloc>(context).add(
//                                   FetchProductByBarcodeEvent(barCodes.first.rawValue!),
//                                 );
//                               },
//                               errorBuilder: (context, error,) {
//                                 if (kDebugMode) {
//                                   print(error);
//                                 }
//                                 return ScannerErrorWidget(error: error);
//                               },
//                             ),
//                           )
//                         : const SizedBox(),
//                     const SizedBox(height: 5),
//                     Row(
//                       children: [
//                         Flexible(
//                           flex: 15,
//                           child: StoreTextField(
//                             hintText: 'Maxsulot nomi',
//                             textEditingController: _productBarcodeController,
//                             initialValue: appState.isEdit ? stock?.name : null,
//                             icon: Icons.qr_code_2,
//                             onTap: () {
//                               _toggleScanner();
//                             },
//                           ),
//                         ),
//                         const Flexible(
//                           flex: 2,
//                           child: Center(child: Icon(Icons.qr_code)),
//                         ),
//                       ],
//                     ),
//                     StoreTextField(
//                       hintText: 'Maxsulot miqdori',
//                       textInputType: TextInputType.number,
//                       icon: Icons.numbers,
//                       textEditingController: _productQtyController,
//                       initialValue: appState.isEdit ? stock?.qty.toString() : null,
//                     ),
//                     StoreTextField(
//                       hintText: 'Ogohlantiruvchi miqdor',
//                       textInputType: TextInputType.number,
//                       icon: Icons.numbers,
//                       textEditingController: _productNotifyQtyController,
//                       initialValue: appState.isEdit ? stock?.minQty.toString() : null,
//                     ),
//                     // Row(
//                     //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     //   children: [
//                     //     Flexible(
//                     //       child: SizedBox(),
//                     //       flex: 1,
//                     //     ),
//                     //   ],
//                     // ),
//                     SizedBox(height: 12.h),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
