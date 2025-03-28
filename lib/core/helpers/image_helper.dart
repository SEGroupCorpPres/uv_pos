import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageHelper {
  ImageHelper({
    ImagePicker? imagePicker,
    ImageCropper? imageCropper,
  })  : _imagePicker = imagePicker ?? ImagePicker(),
        _imageCropper = imageCropper ?? ImageCropper();

  final ImagePicker _imagePicker;
  final ImageCropper _imageCropper;

  // Method to pick images
  Future<List<XFile>> pickImage({
    ImageSource source = ImageSource.gallery,
    int imageQuality = 100,
    double? maxResolution,
    bool multiple = false,
  }) async {
    if (multiple) {
      // Pick multiple images
      return await _imagePicker.pickMultiImage(
        imageQuality: imageQuality,
        maxHeight: maxResolution,
        maxWidth: maxResolution,
      );
    }
    // Pick single image
    final XFile? file = await _imagePicker.pickImage(
      source: source,
      imageQuality: imageQuality,
      maxWidth: maxResolution,
      maxHeight: maxResolution,
    );
    if (file != null) {
      return [file];
    }
    return [];
  }

  // Method to pick videos
  Future<XFile?> pickVideo({
    ImageSource source = ImageSource.gallery,
  }) async {
    // Pick video
    final XFile? file = await _imagePicker.pickVideo(source: source);
    return file;
  }

  // Method to crop images
  Future<CroppedFile?> crop({
    required XFile file,
    CropStyle cropStyle = CropStyle.rectangle,
  }) async {
    // Crop image
    return await _imageCropper.cropImage(
      sourcePath: file.path,
      compressQuality: 100,
      uiSettings: [
        IOSUiSettings(
          cropStyle: cropStyle
        ),
        AndroidUiSettings(cropStyle: cropStyle),
      ],
    );
  }

  Future<String> uploadImageToStorage(File image, String path) async {
    final storageRef = FirebaseStorage.instance.ref().child(path);
    final uploadTask = storageRef.putFile(image);
    final snapshot = await uploadTask.whenComplete(() => null);
    return await snapshot.ref.getDownloadURL();
  }
}
