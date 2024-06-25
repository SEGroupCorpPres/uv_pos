import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uv_pos/app/presentation/bloc/auth/app_bloc.dart';
import 'package:uv_pos/core/helpers/image_helper.dart';
import 'package:uv_pos/features/data/remote/models/store_model.dart';
import 'package:uv_pos/features/presentation/widgets/store/store_button.dart';
import 'package:uv_pos/features/presentation/widgets/store/store_text_field.dart';
import 'package:uv_pos/generated/assets.dart';

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

  static Page page() => Platform.isIOS
      ? const CupertinoPage(
          child: AddEditStoreScreen(),
        )
      : const MaterialPage(
          child: AddEditStoreScreen(),
        );

  @override
  State<AddEditStoreScreen> createState() => _AddEditStoreScreenState();
}

class _AddEditStoreScreenState extends State<AddEditStoreScreen> {
  late TextEditingController _storeNameTextEditingController;
  late TextEditingController _storeDescriptionTextEditingController;
  late TextEditingController _storePhoneTextEditingController;
  late TextEditingController _storeAddressTextEditingController;
  File? _image;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(debugLabel: 'createEditStoreFormKey');
  final ImageHelper imageHelper = ImageHelper();

  @override
  void initState() {
    _storeNameTextEditingController = TextEditingController(text: widget.storeNameTextEditingController ?? '');
    _storeDescriptionTextEditingController = TextEditingController(text: widget.storeDescriptionTextEditingController ?? '');
    _storePhoneTextEditingController = TextEditingController(text: widget.storePhoneTextEditingController ?? '');
    _storeAddressTextEditingController = TextEditingController(text: widget.storeAddressTextEditingController ?? '');
    // TODO: implement initState
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
    final Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: InkWell(
          onTap: () => BlocProvider.of<AppBloc>(context).add(
            NavigateToStoreListScreen(),
          ),
          child: Icon(Icons.adaptive.arrow_back),
        ),
        title: const Text('Create Store'),
        centerTitle: false,
        actions: [
          TextButton.icon(
            onPressed: () => BlocProvider.of<AppBloc>(context).add(
              NavigateToStoreListScreen(),
            ),
            icon: const Icon(Icons.save),
            label: const Text(
              'Save',
            ),
          ),
        ],
      ),
      body: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          StoreModel? store;
          if (state.isEdit) {
            if (state.store != null) {
              store = state.store;
            }
          }
          _storeNameTextEditingController.text = store?.name ?? '';
          _storeDescriptionTextEditingController.text = store?.description ?? '';
          _storePhoneTextEditingController.text = store?.phone ?? '';
          _storeAddressTextEditingController.text = store?.address ?? '';

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      StoreTextField(
                        hintText: 'Store Name',
                        icon: Icons.text_fields,
                        textEditingController: _storeNameTextEditingController,
                      ),
                      StoreTextField(
                        hintText: 'Store Description',
                        icon: Icons.description,
                        textEditingController: _storeDescriptionTextEditingController,
                      ),
                      StoreTextField(
                        hintText: 'Store Phone',
                        icon: Icons.phone,
                        textEditingController: _storePhoneTextEditingController,
                      ),
                      StoreTextField(
                        hintText: 'Store Address',
                        icon: Icons.location_on,
                        textEditingController: _storeAddressTextEditingController,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
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
                                      image: NetworkImage(store!.imageUrl),
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
          );
        },
      ),
    );
  }
}
