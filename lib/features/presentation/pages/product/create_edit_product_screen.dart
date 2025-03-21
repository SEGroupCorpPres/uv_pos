import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image/image.dart' as img;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uv_pos/app/presentation/bloc/auth/app_bloc.dart';
import 'package:uv_pos/core/helpers/image_helper.dart';
import 'package:uv_pos/core/helpers/image_resizer.dart';
import 'package:uv_pos/features/data/remote/models/dimensions_model.dart';
import 'package:uv_pos/features/data/remote/models/meta_model.dart';
import 'package:uv_pos/features/data/remote/models/product_measurement_unit.dart';
import 'package:uv_pos/features/data/remote/models/product_model.dart';
import 'package:uv_pos/features/data/remote/models/store_model.dart';
import 'package:uv_pos/features/presentation/bloc/product/product_bloc.dart';
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
  late final TextEditingController _productNameController = TextEditingController();
  late final TextEditingController _productBarcodeController = TextEditingController();
  late final TextEditingController _productDescriptionController = TextEditingController();
  late final TextEditingController _productVendorController = TextEditingController();
  late final TextEditingController _productMeasurementUnitController = TextEditingController();
  late final TextEditingController _productPriceController = TextEditingController();
  late final TextEditingController _productDiscountController = TextEditingController();
  late final TextEditingController _productCostController = TextEditingController();
  late final TextEditingController _productStockController = TextEditingController();
  late final TextEditingController _productNotifySizeController = TextEditingController();

  File? _image;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(debugLabel: 'createProductFormKey');
  final ImageHelper imageHelper = ImageHelper();

  // late MobileScannerController scannerController;
  String? image = '';
  String? barcode = '';
  String? _selectedValue = ProductMeasurementUnit.dona.name;
  String? _productName;
  String? _productBarcode;
  String? _productDescription;
  String? _productVendor;
  double? _productPrice;
  double? _productDiscount;
  double? _productCost;
  double? _productSize;
  double? _productNotifySize;

  @override
  void initState() {
    // TODO: implement initState
    // scannerController = MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates, autoStart: true);
    super.initState();
  }

  Future<void> _cupertinoStyleCameraCapture() async {
    final List<XFile> files = await imageHelper.pickImage(source: ImageSource.camera, maxResolution: 600);
    if (files.isNotEmpty) {
      final croppedFile = await imageHelper.crop(file: files.first, cropStyle: CropStyle.rectangle);
      if (croppedFile != null) {
        setState(() {
          _productName = _productNameController.text;
          _productBarcode = _productBarcodeController.text;
          _productDescription = _productDescriptionController.text;
          _productVendor = _productVendorController.text;

          _productPrice = double.tryParse(_productPriceController.text);
          _productCost = double.tryParse(_productCostController.text);
          _productDiscount = double.tryParse(_productDiscountController.text);

          _productSize = double.tryParse(_productStockController.text);
          _productNotifySize = double.tryParse(_productNotifySizeController.text);
          _image = resizeImage(File(croppedFile.path), 600, 600);
        });
      }
    }
  }

  Future<void> _cupertinoStyleGalleryImageUpload() async {
    final List<XFile> files = await imageHelper.pickImage(maxResolution: 600);
    if (files.isNotEmpty) {
      if (files.length == 1) {
        final croppedFile = await imageHelper.crop(file: files.first, cropStyle: CropStyle.rectangle);
        if (croppedFile != null) {
          setState(() {
            _productName = _productNameController.text;
            _productBarcode = _productBarcodeController.text;
            _productDescription = _productDescriptionController.text;
            _productVendor = _productVendorController.text;
            _productPrice = double.tryParse(_productPriceController.text);
            _productCost = double.tryParse(_productCostController.text);
            _productDiscount = double.tryParse(_productDiscountController.text);
            _productSize = double.tryParse(_productStockController.text);
            _productNotifySize = double.tryParse(_productNotifySizeController.text);
            _image = resizeImage(File(croppedFile.path), 600, 600);
          });
        }
      } else {}
    }
  }

  Future<void> _takingPictureWithACameraInMaterialStyle() async {
    final List<XFile> files = await imageHelper.pickImage(source: ImageSource.camera, maxResolution: 600);
    if (files.isNotEmpty) {
      final croppedFile = await imageHelper.crop(file: files.single, cropStyle: CropStyle.rectangle);
      if (croppedFile != null) {
        setState(() {
          _productName = _productNameController.text;
          _productBarcode = _productBarcodeController.text;
          _productDescription = _productDescriptionController.text;
          _productVendor = _productVendorController.text;
          _productPrice = double.tryParse(_productPriceController.text);
          _productCost = double.tryParse(_productCostController.text);
          _productDiscount = double.tryParse(_productDiscountController.text);
          _productSize = double.tryParse(_productStockController.text);
          _productNotifySize = double.tryParse(_productNotifySizeController.text);
          _image = resizeImage(File(croppedFile.path), 600, 600);
        });
      }
    }
  }

  Future<void> _uploadingPictureFromTheGalleryInMaterialStyle() async {
    final List<XFile> files = await imageHelper.pickImage(maxResolution: 600);
    if (files.isNotEmpty) {
      if (files.length == 1) {
        final croppedFile = await imageHelper.crop(file: files.first, cropStyle: CropStyle.rectangle);
        if (croppedFile != null) {
          setState(() {
            _productName = _productNameController.text;
            _productBarcode = _productBarcodeController.text;
            _productDescription = _productDescriptionController.text;
            _productVendor = _productVendorController.text;

            _productPrice = double.tryParse(_productPriceController.text);
            _productCost = double.tryParse(_productCostController.text);
            _productDiscount = double.tryParse(_productDiscountController.text);

            _productSize = double.tryParse(_productStockController.text);
            _productNotifySize = double.tryParse(_productNotifySizeController.text);
            _image = resizeImage(File(croppedFile.path), 600, 600);
          });
        }
      } else {}
    }
  }



  Future<void> createEditProduct() async {}

  @override
  void dispose() {
    // TODO: implement dispose
    // scannerController.dispose();

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
            _productBarcodeController.text = product?.meta.barcode ?? '';
          }
        } else {
          log('product barcode is: ${appState.barcode}');
          _productBarcodeController.text = appState.barcode ?? _productBarcode ?? '';
        }
        _productNameController.text = product?.name ?? _productName ?? '';
        _productDescriptionController.text = product?.description ?? _productDescription ?? '';
        _productVendorController.text = product?.vendor ?? _productVendor ?? '';
        _productPriceController.text = product?.price.toString() ?? (_productPrice != null ? _productPrice.toString() : '');
        _productCostController.text = product?.cost.toString() ?? (_productCost != null ? _productCost.toString() : '');
        _productDiscountController.text = product?.discountPercentage.toString() ?? (_productDiscount != null ? _productDiscount.toString() : '');
        _productStockController.text = product?.stock.toString() ?? (_productSize != null ? _productSize.toString() : '');
        _productNotifySizeController.text = product?.notifySize.toString() ?? (_productNotifySize != null ? _productNotifySize.toString() : '');
        _selectedValue = product?.productMeasurementUnit ?? ProductMeasurementUnit.dona.name;
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (bool didPop, result) {
            if (didPop) {
              return;
            }
            context.read<AppBloc>().add(
                  NavigateToProductListScreen(appState.store),
                );
          },
          child: Scaffold(
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
                      final createdDate = Timestamp.now();

                      String id = '';
                      if (!appState.isEdit) {
                        id = createdDate.microsecondsSinceEpoch.toString();
                      } else {
                        image = appState.product!.thumbnail;
                        id = appState.product!.id;
                      }
                      final Meta meta = Meta(
                        createdAt: createdDate.toString(),
                        updatedAt: Timestamp.now().toString(),
                        qrCode: '',
                        barcode: _productBarcodeController.text,
                      );
                      final Dimensions dimensions = Dimensions(
                        width: 0,
                        height: 0,
                        depth: 0,
                      );
                      final product = ProductModel(
                        id: id,
                        name: _productNameController.text,
                        meta: meta,
                        description: _productDescriptionController.text,
                        vendor: _productVendorController.text,
                        price: double.parse(_productPriceController.text),
                        cost: double.parse(_productCostController.text),
                        discountPercentage: double.parse(_productDiscountController.text),
                        stock: double.parse(_productStockController.text),
                        notifySize: double.parse(_productNotifySizeController.text),
                        productMeasurementUnit: _selectedValue!,
                        storeId: store!.id,
                        createdAt: '',
                        updatedAt: '',
                        tags: [],
                        brand: '',
                        sku: '',
                        weight: 0,
                        dimensions: dimensions,
                        warrantyInformation: '',
                        shippingInformation: '',
                        availabilityStatus: '',
                        reviews: [],
                        returnPolicy: '',
                        minimumOrderQuantity: 0,
                        images: [],
                        thumbnail: '',
                        startDiscountDate: '',
                        endDiscountDate: '',
                        category: '',
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
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(!appState.isEdit ? 'Product created successfully' : 'Product updated successfully')));
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
                                : image != null
                                    ? Container(
                                        width: 150.r,
                                        height: 150.r,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.r),
                                          image: DecorationImage(
                                            image: NetworkImage(image!),
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
                                      Platform.isIOS ? _cupertinoStyleGalleryImageUpload() : _uploadingPictureFromTheGalleryInMaterialStyle();
                                    },
                                  ),
                                  StoreButton(
                                    title: 'Take a Photo',
                                    icon: Icons.camera_alt,
                                    onPressed: () {
                                      Platform.isIOS ? _cupertinoStyleCameraCapture() : _takingPictureWithACameraInMaterialStyle();
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
                                hintText: 'Maxsulot nomi',
                                icon: Icons.text_fields,
                                textEditingController: _productNameController,
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    flex: 15,
                                    child: StoreTextField(
                                      hintText: 'Maxsulot Barcode',
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
                                hintText: 'Maxsulot tavsifi',
                                icon: Icons.description,
                                textEditingController: _productDescriptionController,
                              ),
                              StoreTextField(
                                hintText: 'Maxsulot Sotuvchi korxona',
                                icon: Icons.corporate_fare,
                                textEditingController: _productVendorController,
                              ),
                              StoreTextField(
                                hintText: 'Narxi',
                                textInputType: TextInputType.number,
                                icon: Icons.price_check,
                                textEditingController: _productPriceController,
                              ),
                              StoreTextField(
                                hintText: 'Asl narxi',
                                textInputType: TextInputType.number,
                                icon: Icons.price_check,
                                textEditingController: _productCostController,
                              ),
                              StoreTextField(
                                hintText: 'Chegirma %',
                                textInputType: TextInputType.number,
                                icon: Icons.discount,
                                textEditingController: _productDiscountController,
                              ),
                              StoreTextField(
                                hintText: 'Chegirma boshlanish vaqti',
                                textInputType: TextInputType.number,
                                icon: Icons.discount,
                                textEditingController: _productDiscountController,
                              ),
                              StoreTextField(
                                hintText: 'Chegirma tugash vaqti',
                                textInputType: TextInputType.number,
                                icon: Icons.discount,
                                textEditingController: _productDiscountController,
                              ),
                              StoreTextField(
                                hintText: 'Miqdor',
                                textInputType: TextInputType.number,
                                icon: Icons.notifications,
                                textEditingController: _productStockController,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: SizedBox(),
                                    flex: 1,
                                  ),
                                  Flexible(
                                    flex: 9,
                                    fit: FlexFit.tight,
                                    child: DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        labelText: 'O\'lchov birligi',
                                      ),
                                      value: _selectedValue,
                                      items: productMeasurementTypes.map<DropdownMenuItem<String>>(
                                        (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        },
                                      ).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _selectedValue = newValue;
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Please select an option';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              StoreTextField(
                                hintText: 'Ogohlantiruvchi miqdor',
                                textInputType: TextInputType.number,
                                icon: Icons.notifications,
                                textEditingController: _productNotifySizeController,
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
          ),
        );
      },
    );
  }

  List<String> productMeasurementTypes = ProductMeasurementUnit.values.map((value) => value.name).toList();
}
