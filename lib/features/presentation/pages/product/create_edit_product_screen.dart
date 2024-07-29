import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uv_pos/app/presentation/bloc/auth/app_bloc.dart';
import 'package:uv_pos/core/helpers/image_helper.dart';
import 'package:uv_pos/features/data/remote/models/product_model.dart';
import 'package:uv_pos/features/data/remote/models/store_model.dart';
import 'package:uv_pos/features/presentation/bloc/product/product_bloc.dart';
import 'package:uv_pos/features/presentation/widgets/store/store_button.dart';
import 'package:uv_pos/features/presentation/widgets/store/store_text_field.dart';
import 'package:uv_pos/generated/assets.dart';

class CreateProductScreen extends StatefulWidget {
  const CreateProductScreen({super.key});

  static Page page() =>
      Platform.isIOS
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
  late TextEditingController _productQtyController;
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
    _productQtyController = TextEditingController();
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
    // _productNameController.dispose();
    // _productBarcodeController.dispose();
    // _productDescriptionController.dispose();
    // _productPriceController.dispose();
    // _productCostController.dispose();
    // _productQtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, appState) {
        StoreModel? store = appState.store;
        ProductModel? product;
        if (appState.isEdit) {
          if (appState.barcode != null) {
            _productBarcodeController.text = appState.barcode!;
          }
          if (appState.product != null) {
            product = appState.product;
            _productBarcodeController.text = product?.barcode ?? '';
          }
        } else {
          log('product barcode is: ${appState.barcode}');
          _productBarcodeController.text = appState.barcode ?? '';
        }
        _productNameController.text = product?.name ?? '';
        _productDescriptionController.text = product?.description ?? '';
        _productPriceController.text = product?.price.toString() ?? '';
        _productCostController.text = product?.cost.toString() ?? '';
        _productQtyController.text = product?.quantity.toString() ?? '';
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            leading: InkWell(
              onTap: () {
                BlocProvider.of<AppBloc>(context).add(
                  NavigateToProductListScreen(store),
                );
                BlocProvider.of<ProductBloc>(context).add(LoadProductsEvent(store));
              },
              child: Icon(Icons.adaptive.arrow_back),
            ),
            title: Text(!appState.isEdit ? 'Create Product' : 'Edit Product'),
            centerTitle: false,
            actions: [
              TextButton.icon(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    String id = '';
                    if (!appState.isEdit) {
                      final createdDate = Timestamp.now();

                      id = createdDate.microsecondsSinceEpoch.toString();
                    } else {
                      id = appState.product!.id;
                    }
                    final product = ProductModel(
                      id: id,
                      name: _productNameController.text,
                      barcode: _productBarcodeController.text,
                      description: _productDescriptionController.text,
                      price: double.parse(_productPriceController.text),
                      cost: double.parse(_productCostController.text),
                      quantity: int.parse(_productQtyController.text),
                      storeId: store!.id,
                    );
                    if (!appState.isEdit) {
                      context.read<ProductBloc>().add(CreateProductEvent(product, _image, store));
                    } else {
                      context.read<ProductBloc>().add(UpdateProductEvent(product, _image, store));
                    }
                  }
                },
                icon: const Icon(Icons.save),
                label: const Text('Save'),
              ),
            ],
          ),
          resizeToAvoidBottomInset: true,
          body: BlocConsumer<ProductBloc, ProductState>(
            listener: (context, state) {
              if (state is ProductCreated || state is ProductUpdated) {
                // Navigate back or show a success message when the product is created
                ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(!appState.isEdit ? 'Product created successfully' : 'Product updated successfully')));
                BlocProvider.of<AppBloc>(context).add(
                  NavigateToProductListScreen(store),
                );
              } else if (state is ProductError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${state.error}')));
              }
            },
            builder: (context, state) {
              if (state is ProductCreating || state is ProductUpdating) {
                return const Center(child: CircularProgressIndicator.adaptive());
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          !appState.isEdit
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
                              : product!.image != null
                              ? Container(
                            width: 150.r,
                            height: 150.r,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              image: DecorationImage(
                                image: NetworkImage(product!.image!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                              : Container(
                            width: 150.r,
                            height: 150.r,
                            margin: EdgeInsets.symmetric(vertical: 30.r),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: Image.asset(Assets.imagesImageBg),
                            ),
                          ),
                          SizedBox(height: 20.h),
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
                      padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 10.w),
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
                                    onTap: () =>
                                        BlocProvider.of<AppBloc>(context).add(
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
                              hintText: 'Quantity',
                              icon: Icons.notifications,
                              textEditingController: _productQtyController,
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
      },
    );
  }
}
