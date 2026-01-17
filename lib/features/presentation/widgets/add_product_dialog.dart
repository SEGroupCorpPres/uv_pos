import 'package:flutter/material.dart';

import 'widgets.dart';

class AddProductDialog extends StatelessWidget {
  final String? productID;
  final String? barcode;
  final bool? isEdit;
  final String? storeID;
  final MobileScannerController scannerController;

  // final bool isProductLeft;

  const AddProductDialog({
    super.key,
    required this.barcode,
    this.productID,
    this.isEdit,
    this.storeID,
    required this.scannerController,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: isEdit!
          ? const Text('Bu maxsulot do\'konda qolmagan')
          : const Text('Yangi maxsulot qo\'shish'),
      content: isEdit!
          ? const Text('Maxsulotni do\'konga qaytadan qo\'shmoqchimisiz ?')
          : const Text(
              'Do\'konda bunday maxsulot mavjud emas! Maxsulotni Do\'konga qo\'shmoqchimisiz ?'),
      actions: [
        TextButton(
          onPressed: () {
            BlocProvider.of<AppBloc>(context)
                .add(NavigateToCreateEditProductScreen(productID, barcode, isEdit, storeID));
            scannerController.stop();
            Navigator.pop(context);
          },
          child: const Text('Qo\'shish'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Yopish'),
        ),
      ],
    );
  }
}
