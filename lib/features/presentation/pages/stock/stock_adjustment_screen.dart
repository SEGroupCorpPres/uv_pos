import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uv_pos/app/presentation/bloc/auth/app_bloc.dart';
import 'package:uv_pos/features/presentation/widgets/store/store_text_field.dart';

class StockAdjustmentScreen extends StatefulWidget {
  const StockAdjustmentScreen({super.key});
  static Page page() => Platform.isIOS
      ? const CupertinoPage(
    child: StockAdjustmentScreen(),
  )
      : const MaterialPage(
    child: StockAdjustmentScreen(),
  );
  @override
  State<StockAdjustmentScreen> createState() => _StockAdjustmentScreenState();
}

class _StockAdjustmentScreenState extends State<StockAdjustmentScreen> {
  late TextEditingController _productNameController;
  late TextEditingController _productBarcodeController;
  late TextEditingController _productDescriptionController;
  late TextEditingController _productPriceController;
  late TextEditingController _productCostController;
  late TextEditingController _productInStockController;
  late TextEditingController _productNotifyQtyController;

  @override
  void initState() {
    // TODO: implement initState
    _productNameController = TextEditingController();
    _productBarcodeController = TextEditingController();
    _productDescriptionController = TextEditingController();
    _productPriceController = TextEditingController();
    _productCostController = TextEditingController();
    _productInStockController = TextEditingController();
    _productNotifyQtyController = TextEditingController();
    _productNameController = TextEditingController();
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(debugLabel: 'stockAdjustmentFormKey');

  @override
  void dispose() {
    // TODO: implement dispose
    _productNameController.dispose();
    _productBarcodeController.dispose();
    _productDescriptionController.dispose();
    _productPriceController.dispose();
    _productCostController.dispose();
    _productInStockController.dispose();
    _productNotifyQtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: InkWell(
          onTap: () => BlocProvider.of<AppBloc>(context).add(
            NavigateToStockScreen(),
          ),
          child: Icon(Icons.adaptive.arrow_back),
        ),
        title: const Text('Stock Adjustment'),
        centerTitle: false,
        actions: [
          TextButton.icon(
            onPressed: () => BlocProvider.of<AppBloc>(context).add(
      NavigateToStockScreen(),
    ),
            icon: const Icon(Icons.save),
            label: const Text('Submit'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Row(
                children: [
                  Flexible(
                    flex: 15,
                    child: StoreTextField(hintText: 'Product Name', icon: Icons.label),
                  ),
                  Flexible(
                    flex: 2,
                    child: Center(child: Icon(Icons.qr_code)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(flex: 1, child: Icon(Icons.gif_box_rounded)),
                  Flexible(
                    flex: 9,
                    child: DropdownMenu(
                      width: size.width - 80,
                      hintText: 'Variant',
                      inputDecorationTheme: const InputDecorationTheme(),
                      menuStyle: const MenuStyle(),
                      dropdownMenuEntries: const [],
                    ),
                  ),
                ],
              ),
              const StoreTextField(
                hintText: 'Stock In',
                icon: CupertinoIcons.grid,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(flex: 1, child: Icon(Icons.add_shopping_cart_outlined)),
                  Flexible(
                    flex: 9,
                    child: DropdownMenu(
                      width: size.width - 80,
                      hintText: 'Add',
                      // label: Text('Operation'),
                      inputDecorationTheme: const InputDecorationTheme(),
                      menuStyle: const MenuStyle(),
                      dropdownMenuEntries: const [],
                    ),
                  ),
                ],
              ),
              const StoreTextField(hintText: 'Note', icon: Icons.note),
            ],
          ),
        ),
      ),
    );
  }
}
