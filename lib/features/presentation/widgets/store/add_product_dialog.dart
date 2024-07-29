import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:uv_pos/app/presentation/bloc/auth/app_bloc.dart';
import 'package:uv_pos/features/data/remote/models/product_model.dart';
import 'package:uv_pos/features/data/remote/models/store_model.dart';

class AddProductDialog extends StatelessWidget {
  final ProductModel? product;
  final String? barcode;
  final bool? isEdit;
  final StoreModel? store;
  final MobileScannerController scannerController;

  // final bool isProductLeft;

  const AddProductDialog({
    super.key,
    required this.barcode,
    this.product,
    this.isEdit,
    this.store,
    required this.scannerController,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: isEdit! ? const Text('Bu maxsulot do\'konda qolmagan') : const Text('Add New Product'),
      content: isEdit! ? const Text('Maxsulotni do\'konga qaytadan qo\'shmoqchimisiz ?') : const Text('Do\'konda bunday maxsulot mavjud emas! Maxsulotni Do\'konga qo\'shmoqchimisiz ?'),
      actions: [
        TextButton(
          onPressed: () {
            BlocProvider.of<AppBloc>(context).add(NavigateToCreateProductScreen(product, barcode, isEdit, store));
            scannerController.stop();
            Navigator.pop(context);
          },
          child: const Text('Add'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
