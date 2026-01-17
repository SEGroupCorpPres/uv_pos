import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'store.dart';

class AddEditStoreScreen extends StatefulWidget {
  const AddEditStoreScreen({
    super.key,
  });

  static Page page() => const MaterialPage(
        child: AddEditStoreScreen(),
      );

  @override
  State<AddEditStoreScreen> createState() => _AddEditStoreScreenState();
}

class _AddEditStoreScreenState extends State<AddEditStoreScreen> {
  late TextEditingController _storeNameTextEditingController = TextEditingController();
  late TextEditingController _storeDescriptionTextEditingController = TextEditingController();
  late TextEditingController _storePhoneTextEditingController = TextEditingController();
  late TextEditingController _storeAddressTextEditingController = TextEditingController();

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
    // _storeNameTextEditingController = TextEditingController(text: _name ?? '');
    // _storeDescriptionTextEditingController = TextEditingController(text: _description ?? '');
    // _storePhoneTextEditingController = TextEditingController(text: _phone ?? '');
    // _storeAddressTextEditingController = TextEditingController(text: _address ?? '');
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

  //
  // Future<void> _cupertinoStyleCameraCapture() async {
  //   final List<XFile> files = await imageHelper.pickImage(source: ImageSource.camera, maxResolution: 600);
  //   if (files.isNotEmpty) {
  //     final croppedFile = await imageHelper.crop(file: files.first, cropStyle: CropStyle.rectangle);
  //     if (croppedFile != null) {
  //       setState(() {
  //         _name = _storeNameTextEditingController.text;
  //         _description = _storeDescriptionTextEditingController.text;
  //         _phone = _storePhoneTextEditingController.text;
  //         _address = _storeAddressTextEditingController.text;
  //         _image = File(croppedFile.path);
  //       });
  //     }
  //   }
  // }
  //
  // Future<void> _cupertinoStyleGalleryImageUpload() async {
  //   final List<XFile> files = await imageHelper.pickImage(maxResolution: 600);
  //   if (files.isNotEmpty) {
  //     if (files.length == 1) {
  //       final croppedFile = await imageHelper.crop(file: files.first, cropStyle: CropStyle.rectangle);
  //       if (croppedFile != null) {
  //         setState(() {
  //           _name = _storeNameTextEditingController.text;
  //           _description = _storeDescriptionTextEditingController.text;
  //           _phone = _storePhoneTextEditingController.text;
  //           _address = _storeAddressTextEditingController.text;
  //           _image = resizeImage(File(croppedFile.path), 600, 600);
  //
  //         });
  //       }
  //     } else {}
  //   }
  // }

  Future<void> _takingAPictureWithACameraInMaterialStyle() async {
    final List<XFile> files =
        await imageHelper.pickImage(source: ImageSource.camera, maxResolution: 300);
    if (files.isNotEmpty) {
      final croppedFile =
          await imageHelper.crop(file: files.single, cropStyle: CropStyle.rectangle);
      if (croppedFile != null) {
        setState(() {
          // _name = _storeNameTextEditingController.text;
          // _description = _storeDescriptionTextEditingController.text;
          // _phone = _storePhoneTextEditingController.text;
          // _address = _storeAddressTextEditingController.text;
          _image = resizeImage(File(croppedFile.path), 300, 300);
        });
      }
    }
  }

  Future<void> _uploadingAPictureFromTheGalleryInMaterialStyle() async {
    final List<XFile> files = await imageHelper.pickImage(maxResolution: 300);
    if (files.isNotEmpty) {
      if (files.length == 1) {
        final croppedFile =
            await imageHelper.crop(file: files.first, cropStyle: CropStyle.rectangle);
        if (croppedFile != null) {
          setState(() {
            // _name = _storeNameTextEditingController.text;
            // _description = _storeDescriptionTextEditingController.text;
            // _phone = _storePhoneTextEditingController.text;
            // _address = _storeAddressTextEditingController.text;
            _image = resizeImage(File(croppedFile.path), 300, 300);
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
    final Size size = MediaQuery.sizeOf(context);

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
          title: BlocBuilder<AppBloc, AppState>(
            builder: (context, appState) {
              switch (appState.isEdit) {
                case true:
                  return const Text('Do\'konni tahrirlash');
                default:
                  return const Text('Do\'kon yaratish');
              }
            },
          ),
          centerTitle: false,
          actions: _buildAddEditStoreAppBarActions(context),
        ),
        body: SingleChildScrollView(
          child: BlocBuilder<AppBloc, AppState>(
            builder: (context, appState) {
              return BlocConsumer<StoreBloc, StoreState>(
                listener: _storeBlocConsumerListener,
                builder: (context, state) {
                  if (state is StoreCreating || state is StoreUpdating) {
                    return Container(
                      width: size.width,
                      height: ScreenUtil.defaultSize.height,
                      child: Center(child: CircularProgressIndicator.adaptive()),
                    );
                  } else if (state is StoreLoading) {
                    return Container(
                      width: size.width,
                      height: ScreenUtil.defaultSize.height,
                      child: Center(child: CircularProgressIndicator.adaptive()),
                    );
                  } else if (state is StoreError) {
                    return ErrorWidget(state.error);
                  } else if (state is StoreByIdLoaded) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20).r,
                      child: _addEditStoreForm(isEdit: appState.isEdit, store: state.store),
                    );
                  } else {
                    return Container();
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAddEditStoreAppBarActions(BuildContext context) {
    return [
      BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          if (state.isEdit) {
            return TextButton.icon(
              onPressed: () => _createEditStoreMethod(isEdit: true),
              icon: const Icon(Icons.save),
              label: const Text(
                'Saqlash',
              ),
            );
          } else {
            return TextButton.icon(
              onPressed: () => _createEditStoreMethod(isEdit: false),
              icon: const Icon(Icons.save),
              label: const Text(
                'Qo\'shish',
              ),
            );
          }
        },
      ),
    ];
  }

  void _createEditStoreMethod({required bool isEdit}) {
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

      if (!isEdit) {
        context.read<StoreBloc>().add(CreateStoreEvent(store, _image));
      } else {
        context.read<StoreBloc>().add(UpdateStoreEvent(store, _image));
      }
      _clearField();
    }
  }

  Column _addEditStoreForm({required bool isEdit, required StoreModel? store}) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              StoreTextField(
                hintText: 'Do\'kon nomi',
                icon: Icons.text_fields,
                initialValue: isEdit ? store!.name : '',
                textEditingController: _storeNameTextEditingController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Iltimos do\'kon nomini kiriting';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value;
                },
              ),
              StoreTextField(
                hintText: 'Do\'kon tavsilotlari',
                icon: Icons.description,
                initialValue: isEdit ? store!.description : '',
                textEditingController: _storeDescriptionTextEditingController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Iltimos do\'kon tavsilotlarini kiriting';
                  }
                  return null;
                },
              ),
              StoreTextField(
                hintText: 'Do\'kon telefon raqami',
                icon: Icons.phone,
                initialValue: isEdit ? store!.phone : '',
                textEditingController: _storePhoneTextEditingController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Iltimos do\'kon telefon raqamini kiriting';
                  }
                  return null;
                },
              ),
              StoreTextField(
                hintText: 'Do\'kon addressi',
                icon: Icons.location_on,
                initialValue: isEdit ? store!.address : '',
                textEditingController: _storeAddressTextEditingController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Iltimos do\'kon addressini kiriting';
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
            !isEdit
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
                  title: 'Rasmni tanlash',
                  icon: Icons.image,
                  onPressed: () {
                    // Platform.isIOS ? _cupertinoStyleGalleryImageUpload() :
                    _uploadingAPictureFromTheGalleryInMaterialStyle();
                  },
                ),
                StoreButton(
                  title: 'Suratga olish',
                  icon: Icons.camera_alt,
                  onPressed: () {
                    // _saveFields(
                    //     _storeNameTextEditingController.text,
                    //     _storeDescriptionTextEditingController.text,
                    //     _storePhoneTextEditingController.text,
                    //     _storeAddressTextEditingController.text);
                    // Platform.isIOS ? _cupertinoStyleCameraCapture() :
                    _takingAPictureWithACameraInMaterialStyle();
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  void _storeBlocConsumerListener(context, state) {
    if (state is StoreCreated) {
      // Navigate back or show a success message when the store is created
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Do\'kon muvaffaqiyatli yaratildi')));
      BlocProvider.of<AppBloc>(context).add(
        NavigateToStoreListScreen(),
      );
    } else if (state is StoreUpdated) {
      // Navigate back or show a success message when the store is updated
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Do\'kon muvaffaqiyatli taxrirlandi')));
      BlocProvider.of<AppBloc>(context).add(
        NavigateToStoreListScreen(),
      );
    } else if (state is StoreError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Xato: ${state.error}')));
    }
  }
}
