import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:uv_pos/app/presentation/bloc/auth/app_bloc.dart';
import 'package:uv_pos/features/presentation/bloc/product/product_bloc.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  static Page page() => Platform.isIOS
      ? const CupertinoPage(
          child: BarcodeScannerScreen(),
        )
      : const MaterialPage(
          child: BarcodeScannerScreen(),
        );

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  late MobileScannerController scannerController;
  String? barcode = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scannerController = MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates, autoStart: true);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, result) {
        context.read<AppBloc>().add(
              const NavigateToCreateProductScreen(),
            );
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: InkWell(
            onTap: () => BlocProvider.of<AppBloc>(context).add(
               NavigateToCreateProductScreen(
                 null,
                 '',

               ),
            ),
            child: Icon(Icons.adaptive.arrow_back),
          ),
          title: const Text('Barcode Scanner'),
          centerTitle: false,
        ),
        body: BlocListener<ProductBloc, ProductState>(
          listener: (context, productState) {
            if (productState is ProductSearchByBarcodeLoaded) {
              BlocProvider.of<AppBloc>(context).add(
                NavigateToCreateProductScreen(
                  productState.product,
                  productState.product.meta.barcode,
                  true,
                ),
              );
            }
            if (productState is ProductNotFound) {
              BlocProvider.of<AppBloc>(context).add(
                NavigateToCreateProductScreen(
                  null,
                  barcode,
                  false,
                ),
              );
            }
          },
          child: MobileScanner(
            controller: scannerController,
            onDetect: (capture) {
              final List<Barcode> barCodes = capture.barcodes;
              if (kDebugMode) {
                print('${barCodes.first.rawValue}  rawValue');
              }
              barcode = barCodes.first.rawValue;
              context.read<ProductBloc>().add(FetchProductByBarcodeEvent(barcode!));
              scannerController.stop();
            },
          ),
        ),
      ),
    );
  }
}
