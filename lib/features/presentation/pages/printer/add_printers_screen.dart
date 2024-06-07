import 'package:flutter/material.dart';
import 'package:uv_pos/features/presentation/widgets/store/store_text_field.dart';

class AddPrintersScreen extends StatefulWidget {
  const AddPrintersScreen({super.key});

  @override
  State<AddPrintersScreen> createState() => _AddPrintersScreenState();
}

class _AddPrintersScreenState extends State<AddPrintersScreen> {
  late TextEditingController _productNameController;
  late TextEditingController _productBarcodeController;

  @override
  void initState() {
    // TODO: implement initState
    _productNameController = TextEditingController();
    _productBarcodeController = TextEditingController();
    _productNameController = TextEditingController();
    super.initState();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    _productNameController.dispose();
    _productBarcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.adaptive.arrow_back),
        ),
        title: const Text('Add Printer'),
        centerTitle: false,
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.save),
            label: const Text('Save'),
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          children: [
            Column(
              children: [
                const StoreTextField(hintText: 'Name', icon: Icons.text_fields),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(flex: 1, child: Icon(Icons.print)),
                    Flexible(
                      flex: 9,
                      child: DropdownMenu(
                        width: size.width - 80,
                        hintText: 'Secondary Currency',
                        inputDecorationTheme: const InputDecorationTheme(
                          border: OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                        menuStyle: const MenuStyle(),
                        dropdownMenuEntries: const [],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
