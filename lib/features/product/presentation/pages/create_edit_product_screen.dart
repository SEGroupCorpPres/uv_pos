// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:future_pos/core/helpers/helpers.dart';
// import 'package:future_pos/core/helpers/sku_generator.dart';

// import 'product.dart';

// class CreateProductScreen extends StatefulWidget {
//   const CreateProductScreen({super.key});

//   static Page page() => const MaterialPage(
//         child: CreateProductScreen(),
//       );

//   @override
//   State<CreateProductScreen> createState() => _CreateProductScreenState();
// }

// class _CreateProductScreenState extends State<CreateProductScreen> {
//   late final TextEditingController _productNameController =
//       TextEditingController();
//   late final TextEditingController _productBarcodeController =
//       TextEditingController();
//   late final TextEditingController _productDescriptionController =
//       TextEditingController();
//   late final TextEditingController _productSellingPriceController =
//       TextEditingController();
//   late final TextEditingController _productPurchasingPriceController =
//       TextEditingController();
//   late final TextEditingController _productDiscountController =
//       TextEditingController();
//   late SKUGenerator skuGenerator;

//   File? _thumbnail;
//   final GlobalKey<FormState> _formKey =
//       GlobalKey<FormState>(debugLabel: 'createProductFormKey');
//   final ImageHelper imageHelper = ImageHelper();

//   String? image = '';
//   String? barcode = '';
//   String? _selectedUnit = ProductMeasurementUnit.dona.name;
//   String? _selectedSupplier;
//   String? _productName;
//   String? _productBarcode;
//   String? _productDescription;
//   double? _productSellingPrice;
//   double? _productPurchasingPrice;
//   List<String>? _productImages;
//   List<String>? _supplierIds;
//   String? _unit;
//   String? _weight;
//   Dimensions? _dimensions;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }

//   List<Widget> _buildCreateEditProductScreenAppBarActions({
//     required BuildContext context,
//     required bool isEdit,
//     required String storeID,
//   }) {
//     return [
//       BlocBuilder<ProductBloc, ProductState>(
//         builder: (context, state) {
//           if (isEdit) {
//             if (state is ProductLoading) {
//               return Container();
//             } else if (state is ProductError) {
//               return ErrorWidget(state.error);
//             } else if (state is ProductByIdLoaded) {
//               return TextButton.icon(
//                 onPressed: () => _createEditProductMethod(
//                     isEdit: true,
//                     productModel: state.product,
//                     storeID: storeID),
//                 icon: const Icon(Icons.save),
//                 label: const Text('Taxrirlash'),
//               );
//             } else {
//               return Container();
//             }
//           } else {
//             return TextButton.icon(
//               onPressed: () => _createEditProductMethod(
//                   isEdit: false, productModel: null, storeID: storeID),
//               icon: const Icon(Icons.save),
//               label: const Text('Qo\'shish'),
//             );
//           }
//         },
//       ),
//     ];
//   }

//   void _createEditProductMethod(
//       {required bool isEdit,
//       required ProductModel? productModel,
//       required String storeID}) {
//     if (_formKey.currentState?.validate() ?? false) {
//       final createdDate = Timestamp.now();

//       String id = '';
//       if (!isEdit) {
//         id = createdDate.microsecondsSinceEpoch.toString();
//       } else {
//         image = productModel!.thumbnail;
//         id = productModel.id;
//       }
//       final Meta meta = Meta(
//         createdAt: createdDate.toString(),
//         updatedAt: Timestamp.now().toString(),
//         qrCode: '',
//         barcode: _productBarcodeController.text,
//       );
//       final Dimensions dimensions = Dimensions(
//         width: 0,
//         height: 0,
//         depth: 0,
//       );
//       skuGenerator = SKUGenerator(
//           categoryCode: '',
//           productName: _productNameController.text,
//           sequenceNumber: _dimensions?.height!.toInt());
//       final product = ProductModel(
//         id: id,
//         name: _productNameController.text,
//         meta: meta,
//         description: _productDescriptionController.text,
//         supplierIds: [],
//         sellingPrice: double.parse(_productSellingPriceController.text),
//         purchasePrice: double.parse(_productPurchasingPriceController.text),
//         unit: _selectedUnit!,
//         storeId: storeID,
//         brand: '',
//         sku: isEdit ? productModel!.sku : skuGenerator.sku,
//         weight: 0,
//         dimensions: dimensions,
//         imageUrls: [],
//         thumbnail: '',
//         categoryId: '',
//         discount: double.parse(_productDiscountController.text.isNotEmpty
//             ? _productDiscountController.text
//             : '0'),
//       );
//       if (!isEdit) {
//         context.read<ProductBloc>().add(
//             CreateProductEvent(_thumbnail, product: product, storeID: storeID));
//       } else {
//         context.read<ProductBloc>().add(
//             UpdateProductEvent(_thumbnail, product: product, storeID: storeID));
//       }
//     }
//   }

//   Future<void> _takingPictureWithACameraInMaterialStyle() async {
//     final List<XFile> files = await imageHelper.pickImage(
//         source: ImageSource.camera, maxResolution: 300);
//     if (files.isNotEmpty) {
//       final croppedFile = await imageHelper.crop(
//           file: files.single, cropStyle: CropStyle.rectangle);
//       if (croppedFile != null) {
//         setState(() {
//           _productName = _productNameController.text;
//           _productBarcode = _productBarcodeController.text;
//           _productDescription = _productDescriptionController.text;
//           _thumbnail = resizeImage(File(croppedFile.path), 300, 300);
//         });
//       }
//     }
//   }

//   Future<void> _uploadingPictureFromTheGalleryInMaterialStyle() async {
//     final List<XFile> files = await imageHelper.pickImage(maxResolution: 300);
//     if (files.isNotEmpty) {
//       if (files.length == 1) {
//         final croppedFile = await imageHelper.crop(
//             file: files.first, cropStyle: CropStyle.rectangle);
//         if (croppedFile != null) {
//           setState(() {
//             _productName = _productNameController.text;
//             _productBarcode = _productBarcodeController.text;
//             _productDescription = _productDescriptionController.text;
//             _thumbnail = resizeImage(File(croppedFile.path), 300, 300);
//           });
//         }
//       } else {}
//     }
//   }

//   void _productBlocListener(
//       {required BuildContext context,
//       required ProductState state,
//       required bool isEdit,
//       required String storeID}) {
//     if (state is ProductCreated || state is ProductUpdated) {
//       // Navigate back or show a success message when the product is created
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text(!isEdit
//               ? 'Maxsulot bazaga qo\'shildi'
//               : 'Maxsulot tahrirlandi')));
//       BlocProvider.of<AppBloc>(context).add(
//         NavigateToProductListScreen(storeID: storeID),
//       );
//     } else if (state is ProductError) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('Xato: ${state.error}')));
//     }
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     _productNameController.dispose();
//     _productBarcodeController.dispose();
//     _productDescriptionController.dispose();
//     _productSellingPriceController.dispose();
//     _productPurchasingPriceController.dispose();
//     _productDiscountController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.sizeOf(context);
//     return BlocBuilder<AppBloc, AppState>(
//       builder: (context, appState) {
//         return PopScope(
//           canPop: false,
//           onPopInvokedWithResult: (bool didPop, result) {
//             if (didPop) {
//               return;
//             }
//             context.read<AppBloc>().add(
//                   NavigateToProductListScreen(storeID: appState.storeID),
//                 );
//           },
//           child: Scaffold(
//             appBar: AppBar(
//               automaticallyImplyLeading: true,
//               leading: InkWell(
//                 onTap: () {
//                   BlocProvider.of<AppBloc>(context).add(
//                     NavigateToProductListScreen(storeID: appState.storeID),
//                   );
//                   BlocProvider.of<ProductBloc>(context)
//                       .add(LoadProductsEvent(storeID: appState.storeID!));
//                 },
//                 child: Icon(Icons.adaptive.arrow_back),
//               ),
//               title: Text(!appState.isEdit
//                   ? 'Maxsulotni yaratish'
//                   : 'Maxsulotni tahrirlash'),
//               centerTitle: false,
//               actions: _buildCreateEditProductScreenAppBarActions(
//                   context: context,
//                   isEdit: appState.isEdit,
//                   storeID: appState.storeID!),
//             ),
//             resizeToAvoidBottomInset: true,
//             body: BlocConsumer<ProductBloc, ProductState>(
//               listener: (context, state) {
//                 _productBlocListener(
//                     context: context,
//                     state: state,
//                     isEdit: appState.isEdit,
//                     storeID: appState.storeID!);
//               },
//               builder: (context, state) {
//                 if (appState.isEdit) {
//                   if (state is ProductCreating || state is ProductUpdating) {
//                     return const Center(
//                         child: CircularProgressIndicator.adaptive());
//                   } else if (state is StoreCreating || state is StoreUpdating) {
//                     return Container(
//                       width: size.width,
//                       height: ScreenUtil.defaultSize.height,
//                       child:
//                           Center(child: CircularProgressIndicator.adaptive()),
//                     );
//                   } else if (state is ProductError) {
//                     return ErrorWidget(state.error);
//                   } else if (state is ProductByIdLoaded) {
//                     return SingleChildScrollView(
//                       child: _buildCreateEditProductFormWidget(
//                           size: size,
//                           appState: appState,
//                           context: context,
//                           product: state.product),
//                     );
//                   }
//                 } else {
//                   return SingleChildScrollView(
//                     child: _buildCreateEditProductFormWidget(
//                         size: size,
//                         appState: appState,
//                         context: context,
//                         product: null),
//                   );
//                 }
//                 return Container();
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Column _buildCreateEditProductFormWidget({
//     required Size size,
//     required AppState appState,
//     required BuildContext context,
//     required ProductModel? product,
//   }) {
//     return Column(
//       children: [
//         SizedBox(
//           width: size.width,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               !appState.isEdit
//                   ? Center(
//                       child: Container(
//                         width: 200.r,
//                         height: 200.r,
//                         margin: EdgeInsets.symmetric(vertical: 30.r),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(10.r),
//                           child: _thumbnail == null
//                               ? Image.asset(Assets.imagesImageBg)
//                               : Image.file(
//                                   _thumbnail!,
//                                   width: 200.r,
//                                   height: 200.r,
//                                 ),
//                         ),
//                       ),
//                     )
//                   : image != null
//                       ? Container(
//                           width: 150.r,
//                           height: 150.r,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10.r),
//                             image: DecorationImage(
//                               image: NetworkImage(image!),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         )
//                       : Container(
//                           width: 150.r,
//                           height: 150.r,
//                           margin: EdgeInsets.symmetric(vertical: 30.r),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(10.r),
//                             child: Image.asset(Assets.imagesImageBg),
//                           ),
//                         ),
//               SizedBox(height: 20.h),
//               SizedBox(
//                 width: size.width,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     StoreButton(
//                       title: 'Tasvirni tanlang',
//                       icon: Icons.image,
//                       onPressed: () =>
//                           _uploadingPictureFromTheGalleryInMaterialStyle(),
//                     ),
//                     StoreButton(
//                       title: 'Suratga oling',
//                       icon: Icons.camera_alt,
//                       onPressed: () =>
//                           _takingPictureWithACameraInMaterialStyle(),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 10.w),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 StoreTextField(
//                   hintText: 'Maxsulot nomi',
//                   icon: Icons.text_fields,
//                   textEditingController: _productNameController,
//                   initialValue: appState.isEdit ? product?.name : null,
//                 ),
//                 Row(
//                   children: [
//                     Flexible(
//                       flex: 15,
//                       child: StoreTextField(
//                         hintText: 'Maxsulot Barcode',
//                         textEditingController: _productBarcodeController,
//                         initialValue:
//                             appState.isEdit ? product?.meta.barcode : null,
//                         icon: Icons.qr_code_2,
//                         onTap: () => BlocProvider.of<AppBloc>(context).add(
//                           NavigateToBarcodeScannerScreen(),
//                         ),
//                       ),
//                     ),
//                     const Flexible(
//                       flex: 2,
//                       child: Center(child: Icon(Icons.qr_code)),
//                     ),
//                   ],
//                 ),
//                 StoreTextField(
//                   hintText: 'Maxsulot tavsifi',
//                   icon: Icons.description,
//                   textEditingController: _productDescriptionController,
//                   initialValue: product?.description,
//                 ),
//                 StoreTextField(
//                   hintText: 'Sotiladigan Narx',
//                   textInputType: TextInputType.number,
//                   icon: Icons.price_check,
//                   textEditingController: _productSellingPriceController,
//                   initialValue:
//                       appState.isEdit ? product?.sellingPrice.toString() : null,
//                 ),
//                 StoreTextField(
//                   hintText: 'Asl narxi',
//                   textInputType: TextInputType.number,
//                   icon: Icons.price_check,
//                   textEditingController: _productPurchasingPriceController,
//                   initialValue: appState.isEdit
//                       ? product?.purchasePrice.toString()
//                       : null,
//                 ),
//                 StoreTextField(
//                   hintText: 'Chegirma',
//                   textInputType: TextInputType.number,
//                   icon: Icons.discount,
//                   textEditingController: _productDiscountController,
//                   initialValue:
//                       appState.isEdit ? product?.discount.toString() : null,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Flexible(
//                       child: SizedBox(),
//                       flex: 1,
//                     ),
//                     Flexible(
//                       flex: 9,
//                       fit: FlexFit.tight,
//                       child: DropdownButtonFormField<String>(
//                         decoration: InputDecoration(
//                           labelText: 'O\'lchov birligi',
//                         ),
//                         value: _selectedUnit,
//                         items: productMeasurementTypes
//                             .map<DropdownMenuItem<String>>(
//                           (String value) {
//                             return DropdownMenuItem<String>(
//                               value: value,
//                               child: Text(value),
//                             );
//                           },
//                         ).toList(),
//                         onChanged: (String? newValue) {
//                           setState(() {
//                             _selectedUnit = newValue;
//                           });
//                         },
//                         validator: (value) {
//                           if (value == null) {
//                             return 'Iltimos o\'lchov birligini tanlang';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 12.h),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Flexible(
//                       child: SizedBox(),
//                       flex: 1,
//                     ),
//                     Flexible(
//                       flex: 9,
//                       fit: FlexFit.tight,
//                       child: DropdownButtonFormField<String>(
//                         decoration: InputDecoration(
//                           labelText: 'Yetkazib beruvchi',
//                         ),
//                         value: _selectedUnit,
//                         items: productMeasurementTypes
//                             .map<DropdownMenuItem<String>>(
//                           (String value) {
//                             return DropdownMenuItem<String>(
//                               value: value,
//                               child: Text(value),
//                             );
//                           },
//                         ).toList(),
//                         onChanged: (String? newValue) {
//                           setState(() {
//                             _selectedUnit = newValue;
//                           });
//                         },
//                         validator: (value) {
//                           if (value == null) {
//                             return 'Iltimos o\'lchov birligini tanlang';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 12.h),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   List<String> productMeasurementTypes =
//       ProductMeasurementUnit.values.map((value) => value.name).toList();
// }
