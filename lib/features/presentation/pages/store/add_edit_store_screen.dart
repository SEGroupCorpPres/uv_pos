import 'package:flutter/material.dart';
import 'package:uv_pos/features/presentation/widgets/store/store_button.dart';
import 'package:uv_pos/features/presentation/widgets/store/store_text_field.dart';

class AddEditStoreScreen extends StatefulWidget {
  const AddEditStoreScreen({
    super.key,
    this.storeNameTextEditingController,
    this.storeDescriptionTextEditingController,
    this.storePhoneTextEditingController,
    this.storeAddressTextEditingController,
    this.storeImage,
  });

  final String? storeNameTextEditingController;
  final String? storeDescriptionTextEditingController;
  final String? storePhoneTextEditingController;
  final String? storeAddressTextEditingController;
  final String? storeImage;

  @override
  State<AddEditStoreScreen> createState() => _AddEditStoreScreenState();
}

class _AddEditStoreScreenState extends State<AddEditStoreScreen> {
  late TextEditingController _storeNameTextEditingController;
  late TextEditingController _storeDescriptionTextEditingController;
  late TextEditingController _storePhoneTextEditingController;
  late TextEditingController _storeAddressTextEditingController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _storeNameTextEditingController = TextEditingController(text: widget.storeNameTextEditingController ?? '');
    _storeDescriptionTextEditingController = TextEditingController(text: widget.storeDescriptionTextEditingController ?? '');
    _storePhoneTextEditingController = TextEditingController(text: widget.storePhoneTextEditingController ?? '');
    _storeAddressTextEditingController = TextEditingController(text: widget.storeAddressTextEditingController ?? '');
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _storeNameTextEditingController.dispose();
    _storeDescriptionTextEditingController.dispose();
    _storePhoneTextEditingController.dispose();
    _storeAddressTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.adaptive.arrow_back),
        ),
        title: const Text('Create Store'),
        centerTitle: false,
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.save),
            label: const Text(
              'Save',
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: const Column(
                children: [
                  StoreTextField(hintText: 'Store Name', icon: Icons.text_fields),
                  StoreTextField(hintText: 'Store Description', icon: Icons.description),
                  StoreTextField(hintText: 'Store Phone', icon: Icons.phone),
                  StoreTextField(hintText: 'Store Address', icon: Icons.location_on),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
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
                const SizedBox(width: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StoreButton(title: 'Pick an Image', icon: Icons.image, onPressed: () {}),
                    StoreButton(title: 'Take a Photo', icon: Icons.camera_alt, onPressed: () {}),
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
