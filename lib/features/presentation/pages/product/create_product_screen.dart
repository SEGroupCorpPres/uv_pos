import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uv_pos/app/presentation/bloc/auth/app_bloc.dart';
import 'package:uv_pos/core/helpers/image_helper.dart';
import 'package:uv_pos/features/data/remote/models/product_model.dart';
import 'package:uv_pos/features/presentation/widgets/store/store_button.dart';
import 'package:uv_pos/features/presentation/widgets/store/store_text_field.dart';
import 'package:uv_pos/generated/assets.dart';

class CreateProductScreen extends StatefulWidget {
  const CreateProductScreen({super.key});

  static Page page() => Platform.isIOS
      ? const CupertinoPage(
          child: CreateProductScreen(),
        )
      : const MaterialPage(
          child: CreateProductScreen(),
        );

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
  File? _image;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(debugLabel: 'createProductFormKey');
  final ImageHelper imageHelper = ImageHelper();

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

  Future<void> _cupertinoStyleCameraCapture() async {
    final List<XFile> files = await imageHelper.pickImage(source: ImageSource.camera);
    if (files.isNotEmpty) {
      final croppedFile = await imageHelper.crop(file: files.first, cropStyle: CropStyle.rectangle);
      if (croppedFile != null) {
        setState(() => _image = File(croppedFile.path));
      }
    }
  }

  Future<void> _cupertinoStyleGalleryImageUpload() async {
    final List<XFile> files = await imageHelper.pickImage();
    if (files.isNotEmpty) {
      if (files.length == 1) {
        final croppedFile = await imageHelper.crop(file: files.first, cropStyle: CropStyle.rectangle);
        if (croppedFile != null) {
          setState(() => _image = File(croppedFile.path));
        }
      } else {}
    }
  }

  Future<void> _takingAPictureWithACameraInMaterialStyle() async {
    final List<XFile> files = await imageHelper.pickImage(source: ImageSource.camera);
    if (files.isNotEmpty) {
      final croppedFile = await imageHelper.crop(file: files.single, cropStyle: CropStyle.rectangle);
      if (croppedFile != null) {
        setState(() => _image = File(croppedFile.path));
      }
    }
  }

  Future<void> _uploadingAPictureFromTheGalleryInMaterialStyle() async {
    final List<XFile> files = await imageHelper.pickImage();
    if (files.isNotEmpty) {
      if (files.length == 1) {
        final croppedFile = await imageHelper.crop(file: files.first, cropStyle: CropStyle.rectangle);
        if (croppedFile != null) {
          setState(() => _image = File(croppedFile.path));
        }
      } else {}
    }
  }

  Future<void> createEditProduct() async {}

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
            NavigateToProductListScreen(),
          ),
          child: Icon(Icons.adaptive.arrow_back),
        ),
        title: const Text('Create Product'),
        centerTitle: false,
        actions: [
          TextButton.icon(
            onPressed: () => BlocProvider.of<AppBloc>(context).add(
              NavigateToProductListScreen(),
            ),
            icon: const Icon(Icons.save),
            label: const Text('Save'),
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          ProductModel? product;
          if (state.isEdit) {
            if (state.barcode != null) {
              _productBarcodeController.text = state.barcode!;
            }
            if (state.product != null) {
              product = state.product;
              _productBarcodeController.text = product?.barCode ?? '';
            }
          }

          _productNameController.text = product?.name ?? '';
          _productDescriptionController.text = product?.description ?? '';
          _productPriceController.text = product?.price.toString() ?? '';
          _productCostController.text = product?.cost.toString() ?? '';
          _productInStockController.text = product?.inStock ?? '';
          _productNotifyQtyController.text = product?.notifyQuantity.toString() ?? '';
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      !state.isEdit
                          ? Center(
                              child: Container(
                                width: 150.r,
                                height: 150.r,
                                margin: EdgeInsets.symmetric(vertical: 30.r),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: _image == null
                                      ? Image.asset(Assets.imagesImageBg)
                                      : Image.file(
                                          _image!,
                                          fit: BoxFit.cover,
                                          width: 100.r,
                                        ),
                                ),
                              ),
                            )
                          : Container(
                              width: 150.r,
                              height: 150.r,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(product!.image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            StoreButton(
                              title: 'Pick an Image',
                              icon: Icons.image,
                              onPressed: () {
                                Platform.isIOS ? _cupertinoStyleGalleryImageUpload() : _uploadingAPictureFromTheGalleryInMaterialStyle();
                              },
                            ),
                            StoreButton(
                              title: 'Take a Photo',
                              icon: Icons.camera_alt,
                              onPressed: () {
                                Platform.isIOS ? _cupertinoStyleCameraCapture() : _takingAPictureWithACameraInMaterialStyle();
                              },
                            ),
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
                    child: Column(
                      children: [
                        StoreTextField(
                          hintText: 'Product Name',
                          icon: Icons.text_fields,
                          textEditingController: _productNameController,
                        ),
                        Row(
                          children: [
                            Flexible(
                              flex: 15,
                              child: StoreTextField(
                                hintText: 'Product Barcode',
                                textEditingController: _productBarcodeController,
                                icon: Icons.qr_code_2,
                                onTap: () => BlocProvider.of<AppBloc>(context).add(
                                  NavigateToBarcodeScannerScreen(),
                                ),
                              ),
                            ),
                            const Flexible(
                              flex: 2,
                              child: Center(child: Icon(Icons.qr_code)),
                            ),
                          ],
                        ),
                        StoreTextField(
                          hintText: 'Product Description',
                          icon: Icons.description,
                          textEditingController: _productDescriptionController,
                        ),
                        StoreTextField(
                          hintText: 'Price',
                          icon: Icons.price_check,
                          textEditingController: _productPriceController,
                        ),
                        StoreTextField(
                          hintText: 'Cost',
                          icon: Icons.price_check,
                          textEditingController: _productCostController,
                        ),
                        StoreTextField(
                          hintText: 'In Stock',
                          icon: Icons.add_shopping_cart_outlined,
                          textEditingController: _productInStockController,
                        ),
                        StoreTextField(
                          hintText: 'Notify Quantity',
                          icon: Icons.notifications,
                          textEditingController: _productNotifyQtyController,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
