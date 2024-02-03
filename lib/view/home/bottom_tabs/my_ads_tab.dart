import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/repository/posts_repo.dart';
import 'package:e_store/res/components/custom_alert_dialog.dart';
import 'package:flutter/material.dart';

class MyPostsTab extends StatefulWidget {
  const MyPostsTab({super.key});

  @override
  State<MyPostsTab> createState() => _MyPostsTabState();
}

class _MyPostsTabState extends State<MyPostsTab> {
  static Stream<QuerySnapshot<Map<String, dynamic>>>? posts;
  @override
  void initState() {
    posts = PostsRepo.getPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: StreamBuilder(
        stream: posts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty || !snapshot.hasData) {
            return const Center(child: Text("No posts found"));
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final reversedIndex =
                            (snapshot.data!.docs.length - 1) - index;
                        final data = snapshot.data!.docs[reversedIndex];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Card(
                            child: SizedBox(
                              height: 100,
                              child: Row(
                                children: [
                                  if (data['imageUrl'].isNotEmpty)
                                    ClipRRect(
                                      borderRadius: const BorderRadius.horizontal(
                                          left: Radius.circular(10)),
                                      child: CachedNetworkImage(
                                        width: 100,
                                        imageUrl: data['imageUrl'],
                                        fit: BoxFit.cover,
                                        progressIndicatorBuilder: (context, url,
                                                downloadProgress) =>
                                            Center(
                                                child: CircularProgressIndicator(
                                                    value: downloadProgress
                                                        .progress)),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data['title'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        Text('${data['price']} Rs'),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(data['time']),
                                      ],
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                  PopupMenuButton(
                                      itemBuilder: (BuildContext contetxt) {
                                    return [
                                      const PopupMenuItem(
                                        child: Text("Edit"),
                                      ),
                                      PopupMenuItem(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return CustomAlertDialog(
                                                buttonTitle: "Yes",
                                                title: 'Delete post?',
                                                content:
                                                    'Are you sure you want to delete post?',
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                  await PostsRepo.deletePost(
                                                      data['productId']);
                                                  PostsRepo.getPosts();
                                                },
                                              );
                                            },
                                          );
                                        },
                                        child: const Text("Delete"),
                                      ),
                                    ];
                                  }),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
