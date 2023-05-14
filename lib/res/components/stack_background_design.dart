import 'package:flutter/material.dart';

class StackBackground extends StatelessWidget {
  final String text;
  const StackBackground({
    required this.text,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -100,
      left: -150,
      child: CircleAvatar(
        radius: 180,
        backgroundColor: Colors.black,
        child: Container(
          decoration: const BoxDecoration(color: Colors.black),
          child: Padding(
            padding: const EdgeInsets.only(left: 130, top: 150),
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 30),
            ),
          ),
        ),
      ),
    );
  }
}
