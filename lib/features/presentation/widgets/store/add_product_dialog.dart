import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uv_pos/app/presentation/bloc/auth/app_bloc.dart';

class AddProductDialog extends StatelessWidget {
  final String barcode;
  const AddProductDialog({super.key, required this.barcode});

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: const Text('Add New Product'),
      content: const Text('Do\'konda bunday maxsulot mavjud emas! Maxsulotni Do\'konga qo\'shmoqchimisiz'),
      actions: [
        TextButton(
          onPressed: () {
            BlocProvider.of<AppBloc>(context).add(NavigateToCreateProductScreen(null, barcode));
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
