import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uv_pos/app/presentation/bloc/auth/app_bloc.dart';
import 'package:uv_pos/features/presentation/widgets/store/store_text_field.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  static Page page() => Platform.isIOS
      ? const CupertinoPage(
    child: SettingsScreen(),
  )
      : const MaterialPage(
    child: SettingsScreen(),
  );
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _productNameController;
  late TextEditingController _productBarcodeController;
  late TextEditingController _productDescriptionController;
  late TextEditingController _productPriceController;
  late TextEditingController _productCostController;
  late TextEditingController _productInStockController;
  late TextEditingController _productNotifyQtyController;
  late bool isSwitched = false;

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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(debugLabel: 'settingsFormKey');

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
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        context.read<AppBloc>().add(
          const NavigateToHomeScreen(),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: InkWell(
            onTap: () => BlocProvider.of<AppBloc>(context).add(
              const NavigateToHomeScreen(),
            ),
            child: Icon(Icons.adaptive.arrow_back),
          ),
          title: const Text('Settings'),
          centerTitle: false,
          actions: [
            TextButton.icon(
              onPressed: () => BlocProvider.of<AppBloc>(context).add(
        const NavigateToHomeScreen(),
      ),
              icon: const Icon(Icons.save),
              label: const Text('Save'),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(flex: 1, child: Icon(Icons.currency_bitcoin)),
                    Flexible(
                      flex: 9,
                      child: DropdownMenu(
                        width: size.width - 80,
                        hintText: 'Primary Currency',
                        inputDecorationTheme: const InputDecorationTheme(),
                        menuStyle: const MenuStyle(),
                        dropdownMenuEntries: const [],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(flex: 1, child: Icon(Icons.currency_bitcoin)),
                    Flexible(
                      flex: 9,
                      child: DropdownMenu(
                        width: size.width - 80,
                        hintText: 'Secondary Currency',
                        // label: Text('Operation'),
                        inputDecorationTheme: const InputDecorationTheme(),
                        menuStyle: const MenuStyle(),
                        dropdownMenuEntries: const [],
                      ),
                    ),
                  ],
                ),
                const StoreTextField(hintText: 'Send daily report at', icon: Icons.timer),
                Row(
                  children: [
                    Switch.adaptive(
                      value: isSwitched,
                      onChanged: (bool value) {
                        setState(() {
                          isSwitched = value;
                        });
                      },
                    ),
                    const SizedBox(width: 15),
                    const Text(
                      'Automatically Print Report',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
