import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/repository/auth_repo.dart';

class PostsRepo {
  static deletePost(String productId) {
    FirebaseFirestore.instance.collection('products').doc(productId).delete();
  }

  static Future<QuerySnapshot<Map<String, dynamic>>>? getPosts() async {
    return await FirebaseFirestore.instance
        .collection('products')
        .where('uid', isEqualTo: AuthRepo.currentUserUid)
        .get();
  }
}
