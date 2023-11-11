import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isLoading;
  final double width;
  final double height;

  const CustomButton(
      {required this.text,
      required this.onPressed,
      this.isLoading = false,
        this.height = 50,
        this.width = double.infinity,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        width: width,
        height: height,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: Text(
                text,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )),
      ),
    );
  }
}