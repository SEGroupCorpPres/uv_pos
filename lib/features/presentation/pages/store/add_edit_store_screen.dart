import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uv_pos/app/presentation/bloc/auth/app_bloc.dart';
import 'package:uv_pos/core/helpers/image_helper.dart';
import 'package:uv_pos/features/data/remote/models/store_model.dart';
import 'package:uv_pos/features/presentation/bloc/store/store_bloc.dart';
import 'package:uv_pos/features/presentation/widgets/store/store_button.dart';
import 'package:uv_pos/features/presentation/widgets/store/store_text_field.dart';
import 'package:uv_pos/generated/assets.dart';

class AddEditStoreScreen extends StatefulWidget {
  const AddEditStoreScreen({
    super.key,
  });

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

  String? _name;
  String? _description;
  String? _phone;
  String? _address;
  File? _image;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(debugLabel: 'createEditStoreFormKey');
  bool _isEdit = false;
  final ImageHelper imageHelper = ImageHelper();
  String uid = '';

  @override
  void initState() {
    getUID();
    getFields();
    _storeNameTextEditingController = TextEditingController(text: _name ?? '');
    _storeDescriptionTextEditingController = TextEditingController(text: _description ?? '');
    _storePhoneTextEditingController = TextEditingController(text: _phone ?? '');
    _storeAddressTextEditingController = TextEditingController(text: _address ?? '');
    // TODO: implement initState
    super.initState();
  }

  Future<void> _saveFields(String name, String desc, String phone, String address) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('store_name', name);
    preferences.setString('store_desc', desc);
    preferences.setString('store_phone', phone);
    preferences.setString('store_address', address);
  }

  Future<void> _clearField() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('store_name');
    preferences.remove('store_desc');
    preferences.remove('store_phone');
    preferences.remove('store_address');
  }

  Future<void> _cupertinoStyleCameraCapture() async {
    final List<XFile> files = await imageHelper.pickImage(source: ImageSource.camera);
    if (files.isNotEmpty) {
      final croppedFile = await imageHelper.crop(file: files.first, cropStyle: CropStyle.rectangle);
      if (croppedFile != null) {
        setState(() {
          _name = _storeNameTextEditingController.text;
          _description = _storeDescriptionTextEditingController.text;
          _phone = _storePhoneTextEditingController.text;
          _address = _storeAddressTextEditingController.text;
          _image = File(croppedFile.path);
        });
      }
    }
  }

  Future<void> _cupertinoStyleGalleryImageUpload() async {
    final List<XFile> files = await imageHelper.pickImage();
    if (files.isNotEmpty) {
      if (files.length == 1) {
        final croppedFile = await imageHelper.crop(file: files.first, cropStyle: CropStyle.rectangle);
        if (croppedFile != null) {
          setState(() {
            _name = _storeNameTextEditingController.text;
            _description = _storeDescriptionTextEditingController.text;
            _phone = _storePhoneTextEditingController.text;
            _address = _storeAddressTextEditingController.text;
            _image = File(croppedFile.path);
          });
        }
      } else {}
    }
  }

  Future<void> _takingAPictureWithACameraInMaterialStyle() async {
    final List<XFile> files = await imageHelper.pickImage(source: ImageSource.camera);
    if (files.isNotEmpty) {
      final croppedFile = await imageHelper.crop(file: files.single, cropStyle: CropStyle.rectangle);
      if (croppedFile != null) {
        setState(() {
          _name = _storeNameTextEditingController.text;
          _description = _storeDescriptionTextEditingController.text;
          _phone = _storePhoneTextEditingController.text;
          _address = _storeAddressTextEditingController.text;
          _image = File(croppedFile.path);
        });
      }
    }
  }

  Future<void> _uploadingAPictureFromTheGalleryInMaterialStyle() async {
    final List<XFile> files = await imageHelper.pickImage();
    if (files.isNotEmpty) {
      if (files.length == 1) {
        final croppedFile = await imageHelper.crop(file: files.first, cropStyle: CropStyle.rectangle);
        if (croppedFile != null) {
          setState(() {
            _name = _storeNameTextEditingController.text;
            _description = _storeDescriptionTextEditingController.text;
            _phone = _storePhoneTextEditingController.text;
            _address = _storeAddressTextEditingController.text;
            _image = File(croppedFile.path);
          });
        }
      } else {}
    }
  }

  Future<void> getUID() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    uid = sharedPreferences.getString('uid')!;
  }

  Future<void> getFields() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _name = await sharedPreferences.getString('store_name');
    _description = await sharedPreferences.getString('store_desc');
    _phone = await sharedPreferences.getString('store_phone');
    _address = await sharedPreferences.getString('store_address');
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
    MediaQuery.sizeOf(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, result) {
        if (didPop) {
          return;
        }
        BlocProvider.of<AppBloc>(context).add(
          NavigateToStoreListScreen(),
        );
      },
      child: Scaffold(
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
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  final createdDate = Timestamp.now();
                  final store = StoreModel(
                    id: createdDate.microsecondsSinceEpoch.toString(),
                    uid: uid,
                    name: _storeNameTextEditingController.text,
                    description: _storeDescriptionTextEditingController.text,
                    phone: _storePhoneTextEditingController.text,
                    address: _storeAddressTextEditingController.text,
                  );
                  if (!_isEdit) {
                    context.read<StoreBloc>().add(CreateStoreEvent(store, _image));
                  } else {
                    context.read<StoreBloc>().add(UpdateStoreEvent(store, _image));
                  }
                  _clearField();
                }
              },
              icon: const Icon(Icons.save),
              label: const Text(
                'Save',
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: BlocBuilder<AppBloc, AppState>(
            builder: (context, appState) {
              StoreModel? store;
              if (appState.isEdit) {
                _isEdit = true;
                if (appState.store != null) {
                  store = appState.store;
                }
              }
              _storeNameTextEditingController.text = store?.name ?? _name ?? '';
              _storeDescriptionTextEditingController.text = store?.description ?? _description ?? '';
              _storePhoneTextEditingController.text = store?.phone ?? _phone ?? '';
              _storeAddressTextEditingController.text = store?.address ?? _address ?? '';
              return BlocConsumer<StoreBloc, StoreState>(
                listener: (context, state) {
                  if (state is StoreCreated) {
                    // Navigate back or show a success message when the store is created
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Store created successfully')));
                    BlocProvider.of<AppBloc>(context).add(
                      NavigateToStoreListScreen(),
                    );
                  } else if (state is StoreUpdated) {
                    // Navigate back or show a success message when the store is updated
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Store updated successfully')));
                    BlocProvider.of<AppBloc>(context).add(
                      NavigateToStoreListScreen(),
                    );
                  } else if (state is StoreError) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${state.error}')));
                  }
                },
                builder: (context, state) {
                  if (state is StoreCreating) {
                    return const Center(child: CircularProgressIndicator.adaptive());
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20).r,
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a name';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _name = value;
                                },
                              ),
                              StoreTextField(
                                hintText: 'Store Description',
                                icon: Icons.description,
                                textEditingController: _storeDescriptionTextEditingController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a description';
                                  }
                                  return null;
                                },
                              ),
                              StoreTextField(
                                hintText: 'Store Phone',
                                icon: Icons.phone,
                                textEditingController: _storePhoneTextEditingController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a phone number';
                                  }
                                  return null;
                                },
                              ),
                              StoreTextField(
                                hintText: 'Store Address',
                                icon: Icons.location_on,
                                textEditingController: _storeAddressTextEditingController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a address';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            !appState.isEdit
                                ? Center(
                                    child: Container(
                                      width: 150.r,
                                      height: 150.r,
                                      margin: EdgeInsets.symmetric(vertical: 30.r),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10.r),
                                        clipBehavior: Clip.hardEdge,
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
                                        image: NetworkImage(store!.imageUrl!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                            SizedBox(width: 30.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                    _saveFields(_storeNameTextEditingController.text, _storeDescriptionTextEditingController.text, _storePhoneTextEditingController.text,
                                        _storeAddressTextEditingController.text);
                                    Platform.isIOS ? _cupertinoStyleCameraCapture() : _takingAPictureWithACameraInMaterialStyle();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
