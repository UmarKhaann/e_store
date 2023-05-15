import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> docs;
  const CustomCard({
    required this.docs,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.height;
    return Card(
      color: Colors.white,
      child: Column(

        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10)),
            child: Image.network(
                width: double.infinity,
                height: height * .2,
                fit: BoxFit.cover,
                docs['imageUrl'].toString()),
          ),
          SizedBox(
            height: height * .01,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(docs['title'].toString()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Price: ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold),
                    ),
                    Text('${docs['price'].toString()}\$'),
                  ],
                ),
              ],
            ),
          ),
          // Text(docs['description'].toString())
        ],
      ),
    );
  }
}
