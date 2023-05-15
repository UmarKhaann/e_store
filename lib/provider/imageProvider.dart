import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ImageProviderFromGallery extends ChangeNotifier {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _image;
  
  get image => _image;

  Future<void> setImage() async {
    final XFile? pickedFile =
    await _imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (pickedFile != null) {
        _image = pickedFile;
    }
    notifyListeners();
  }
}