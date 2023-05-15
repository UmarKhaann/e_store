import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import '../provider/imageProvider.dart';
import '../utils/utils.dart';

class StorageModel{
  static final ValueNotifier<bool> btnUploadData = ValueNotifier<bool>(false);
  static final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static final FirebaseAuth auth = FirebaseAuth.instance;


  static void uploadProductToFirebase({required context,required title,required price,required description, required uploadType})async{
    final provider = Provider.of<ImageProviderFromGallery>(context, listen: false);
    final userId = auth.currentUser!.uid.toString();

    btnUploadData.value = true;
    String fileName = basename(provider.image.path);
    Reference storageReference = FirebaseStorage.instance.ref().child('images/$fileName');
    UploadTask uploadTask = storageReference.putFile(File(provider.image.path));
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() async{
      final newUser = fireStore.collection(uploadType).doc(DateTime.now().microsecondsSinceEpoch.toString());
      final imageUrl = await storageReference.getDownloadURL();
      await newUser.set({
        'uid': userId,
        'imageUrl' : imageUrl.toString(),
        'title' : title,
        'price' : price,
        'description' : description,
      }).then((value) {
        Navigator.pop(context);
        Utils.flushBarMessage(context, 'Data uploaded Successfully');
      });
      btnUploadData.value = false;
    });
  }
}