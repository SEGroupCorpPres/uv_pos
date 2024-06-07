import 'package:flutter/material.dart';
import 'package:uv_pos/features/presentation/widgets/store/store_button.dart';
import 'package:uv_pos/features/presentation/widgets/store/store_text_field.dart';

class CreateProductScreen extends StatefulWidget {
  const CreateProductScreen({super.key});

  @override
  State<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(debugLabel: 'createProductFormKey');

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
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.adaptive.arrow_back),
        ),
        title: const Text('Create Product'),
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
      body: Column(
        children: [
          SizedBox(
            width: size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    // image: DecorationImage(image: AssetImage)
                  ),
                  child: const Icon(
                    Icons.image,
                    size: 150,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      StoreButton(title: 'Pick an Image', icon: Icons.image, onPressed: () {}),
                      StoreButton(title: 'Take a Photo', icon: Icons.camera_alt, onPressed: () {}),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Form(
              key: _formKey,
              child: const Column(
                children: [
                  StoreTextField(hintText: 'Product Name', icon: Icons.text_fields),
                  Row(
                    children: [
                      Flexible(
                        flex: 15,
                        child: StoreTextField(hintText: 'Product Barcode', icon: Icons.qr_code_2),
                      ),
                      Flexible(
                        flex: 2,

                        child: Center(child: Icon(Icons.qr_code)),
                      ),
                    ],
                  ),
                  StoreTextField(hintText: 'Product Description', icon: Icons.description),
                  StoreTextField(hintText: 'Price', icon: Icons.price_check),
                  StoreTextField(hintText: 'Cost', icon: Icons.price_check),
                  StoreTextField(hintText: 'In Stock', icon: Icons.add_shopping_cart_outlined),
                  StoreTextField(hintText: 'Notify Quantity', icon: Icons.notifications),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
