import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../provider/image_provider.dart';
import '../utils/utils.dart';

class StorageRepo {
  static final ValueNotifier<bool> btnUploadData = ValueNotifier<bool>(false);
  static final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<String>? uploadItemToFirebaseStorage(
      context, referencePath) async {
    final provider =
        Provider.of<ImageProviderFromGallery>(context, listen: false);
    if (provider.image != null) {
      final path = provider.image is XFile ? provider.image.path : provider.image;
      if (provider.image is XFile) {
        String fileName = basename(path);
        Reference storageReference =
            FirebaseStorage.instance.ref().child('$referencePath$fileName');
        UploadTask uploadTask = storageReference.putFile(File(path));
        final imageUrl = await storageReference.getDownloadURL();
        await uploadTask;
        return imageUrl;
      }
    }
    return '';
  }

  static void uploadProductToFirebase(
      {required context,
      required title,
      required price,
      required description,
      required isSellingProduct}) async {
    final userId = _auth.currentUser!.uid.toString();
    btnUploadData.value = true;

    String imageUrl = await uploadItemToFirebaseStorage(context, 'images/')!;

    final dateTime = DateTime.now().microsecondsSinceEpoch.toString();
    final newItem = _fireStore.collection('products').doc(dateTime);
    final user = await _fireStore.collection('users').doc(userId).get();

    DateTime now = DateTime.now();
    String formattedDateTime = DateFormat.MMMd().add_jm().format(now);
    String customFormattedDateTime = formattedDateTime.replaceAll(',', ' at');
    await newItem.set({
      'productId': dateTime,
      'uid': userId,
      'name': user['fullName'].toString(),
      'imageUrl': imageUrl.toString(),
      'isSellingProduct': isSellingProduct,
      'title': title,
      'price': price,
      'description': description,
      'time': customFormattedDateTime,
      'phone': user['phone'].toString()
    }).then((value) {
      Navigator.pop(context);
      Utils.snackBarMessage(context, 'Data uploaded Successfully');
    });
    btnUploadData.value = false;
  }
}
