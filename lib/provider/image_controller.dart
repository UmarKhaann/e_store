import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ImageController extends ChangeNotifier {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _image;

  get image => _image;

  resetImage() {
    _image = null;
    notifyListeners();
  }

  Future<void> setImage({required ImageSource imageSource}) async {
    final XFile? pickedFile = await _imagePicker.pickImage(
        source: imageSource == ImageSource.gallery? ImageSource.gallery : ImageSource.camera, imageQuality: 70);

    if (pickedFile != null) {
      _image = pickedFile;
    }
    notifyListeners();
  }
}
