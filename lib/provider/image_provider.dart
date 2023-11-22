import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ImageProviderFromGallery extends ChangeNotifier {
  final ImagePicker _imagePicker = ImagePicker();
  dynamic _image;

  get image => _image;

  resetImage() {
    _image = null;
    notifyListeners();
  }

  assignImage(String value){
    _image = value;
    notifyListeners();
  }

  Future<void> setImage() async {
    final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 70);

    if (pickedFile != null) {
      _image = pickedFile;
    }
    notifyListeners();
  }
  Future<void> setImageFromCamera() async {
    final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 70);

    if (pickedFile != null) {
      _image = pickedFile;
    }
    notifyListeners();
  }
}
