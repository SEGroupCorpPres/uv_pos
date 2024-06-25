import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:uv_pos/app/presentation/bloc/auth/app_bloc.dart';
import 'package:uv_pos/features/presentation/widgets/sale_button.dart';
import 'package:uv_pos/features/presentation/widgets/sale_product_price.dart';

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

class _SaleScreenState extends State<SaleScreen> {
  bool isQrCodeScanner = false;

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = const BoxConstraints().biggest;
    final double scanWindowWidth = layoutSize.width / 3;
    final double scanWindowHeight = layoutSize.height / 2;
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: InkWell(
          onTap: () => BlocProvider.of<AppBloc>(context).add(
            NavigateToHomeScreen(),
          ),
          child: Icon(Icons.adaptive.arrow_back),
        ),
        title: const Text('Sale'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.save),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit_note_outlined),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                isQrCodeScanner = true;
              });
            },
            icon: const Icon(Icons.qr_code_2),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person_add),
          ),
        ],
      ),
      body: SafeArea(
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              !isQrCodeScanner
                  ? const SizedBox()
                  : SizedBox(
                      width: size.width,
                      height: 300,
                      child: MobileScanner(
                        controller: MobileScannerController(
                          detectionSpeed: DetectionSpeed.noDuplicates,
                        ),
                        onDetect: (capture) {
                          final List<Barcode> barCodes = capture.barcodes;
                          final Uint8List? image = capture.image;
                          final value = capture.raw;
                          final value2 = capture.size;
                          print("Barcode value! $value");
                          print("Barcode value! $value2");

                          for (final barcode in barCodes) {
                            print("Barcode rawValue! ${barcode.rawValue}");
                            print("Barcode phone! ${barcode.phone}");
                            print("Barcode email! ${barcode.email}");
                            print("Barcode calendarEvent! ${barcode.calendarEvent}");
                            print("Barcode contactInfo! ${barcode.contactInfo}");
                            print("Barcode corners! ${barcode.corners}");
                            print("Barcode displayValue! ${barcode.displayValue}");
                            print("Barcode driverLicense! ${barcode.driverLicense}");
                            print("Barcode format! ${barcode.format}");
                            print("Barcode geoPoint! ${barcode.geoPoint}");
                            print("Barcode rawBytes! ${barcode.rawBytes}");
                            print("Barcode sms! ${barcode.sms}");
                            print("Barcode type! ${barcode.type}");
                            print("Barcode url! ${barcode.url}");
                            print("Barcode wifi! ${barcode.wifi}");
                          }

                          if (image != null) {
                            showAdaptiveDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog.adaptive(
                                  title: Text(barCodes.first.rawValue ?? ""),
                                  content: Image(
                                    image: MemoryImage(image),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
              Container(
                decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.black38))),
                width: double.infinity,
                child: Column(
                  children: [
                    const Column(
                      children: [
                        SaleProductPrice(title: 'Sub Total', price: '\$0'),
                        SaleProductPrice(title: 'Discount', price: '\$0', procedure: 0),
                        SaleProductPrice(title: 'Total', price: '\$0'),
                      ],
                    ),
                    SizedBox(
                      width: size.width,
                      child: Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        children: [
                          SaleButton(title: 'Save', onPressed: () {}, bgColor: Colors.orange),
                          SaleButton(title: 'Discount', onPressed: () {}, bgColor: Colors.blue),
                          SaleButton(title: 'Clear', onPressed: () {}, bgColor: Colors.red),
                          SaleButton(title: 'Play', onPressed: () {}, bgColor: Colors.green),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
