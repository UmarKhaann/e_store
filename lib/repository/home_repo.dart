import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/view_model/home_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class HomeRepo {
  static final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static final FirebaseAuth auth = FirebaseAuth.instance;

  static late Future<QuerySnapshot<Map<String, dynamic>>> sellingProducts;
  static late Future<QuerySnapshot<Map<String, dynamic>>> productsRequest;
  static late Stream<QuerySnapshot<Map<String, dynamic>>> conversations;
  static late Future<QuerySnapshot<Map<String, dynamic>>> favoriteProducts;

  static final currentUserUid = auth.currentUser!.uid;
  static final currentUserDoc =
      fireStore.collection('users').doc(currentUserUid);

  
  static Future<List> getIdsOfFavorites()async{
    final ids = await currentUserDoc.get();
    return ids['favorites'];
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getFavorites(whereIn) {
    favoriteProducts = fireStore.collection('products').where('productId', whereIn: whereIn).get();
    return favoriteProducts;
  }

  static void searchProducts(context, query) async {
    final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    homeViewModel.setQuery(query);
  }

  static searchProduct(docs, searchIn, query) {
    docs = docs.where((element) {
      final value = element.data()[searchIn].toString().toLowerCase();
      return value.startsWith(query.toLowerCase()) ||
          value.contains(query.toLowerCase().trim());
    }).toList();
    return docs;
  }

  static sort(docs, query) {
    docs.sort((b, a) {
      final aTitle = a.data()['title'].toString().toLowerCase();
      final bTitle = b.data()['title'].toString().toLowerCase();
      final queryy = query.toString().toLowerCase();

      if (aTitle.startsWith(queryy) && !bTitle.startsWith(queryy)) {
        return -1;
      } else if (!aTitle.startsWith(queryy) && bTitle.startsWith(queryy)) {
        return 1;
      }
      return aTitle.compareTo(bTitle);
    });
  }

  static Future<void> getPosts(context) async {
    final provider = Provider.of<HomeViewModel>(context, listen: false);
    final products = fireStore.collection('products');
    currentUserDoc
        .get()
        .then((value) => provider.setFavoritesList(value.data()!['favorites']));
    sellingProducts = products.where('isSellingProduct', isEqualTo: true).get();
    productsRequest =
        products.where('isSellingProduct', isEqualTo: false).get();
  }

  static getConversations() {
    conversations = fireStore
        .collection('conversations')
        .where('members', arrayContains: currentUserUid)
        .orderBy('lastMessageTime', descending: false)
        .snapshots();
  }

  static void getUserData(context) async {
    final provider = Provider.of<HomeViewModel>(context, listen: false);
    final snapShot = await currentUserDoc.get();
    provider.setUserData(snapShot);
  }

  static setFavorite(context, productId) {
    final provider = Provider.of<HomeViewModel>(context, listen: false);

    final doc = fireStore.collection('users').doc(currentUserUid);
    doc.get().then((value) {
      final List data = provider.favoritesList;
      if (data.contains(productId)) {
        data.remove(productId);
      } else {
        data.add(productId);
      }
      provider.setFavoritesList(data);
      doc.update({'favorites': data});
    });
  }
}
