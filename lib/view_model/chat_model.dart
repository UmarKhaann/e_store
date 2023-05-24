import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ChatModel{
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static sentChatMessage({required String message, required dynamic productDocs}){

    DateTime now = DateTime.now();
    String formattedDateTime =
    DateFormat.MMMd().add_jm().format(now);
    String customFormattedDateTime =
    formattedDateTime.replaceAll(',', ' at');

    final id = (_auth.currentUser!.uid+productDocs['productId']+productDocs['uid']).split('')..sort()..join();
    final doc = _firestore.collection('conversations').doc(id.toString());
    doc.get().then((value){
      if(value.exists){
        doc.update({
          "messages": FieldValue.arrayUnion([
            {
              "sender": _auth.currentUser!.uid,
              "message": message,
              "time": customFormattedDateTime,
            }
          ]),
        });
      }else{
        doc.set({
          "members": [
            _auth.currentUser!.uid,
            productDocs['uid']
          ],
          "productId": productDocs['productId'],
          "productName": productDocs['title'],
          "imageUrl": productDocs['imageUrl'],
          'userName': productDocs['name'],
          "messages": [
            {
              "sender": _auth.currentUser!.uid,
              "message": message,
              "time": customFormattedDateTime,
            }
          ],
        });
      }
    });
  }
}