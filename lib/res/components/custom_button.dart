import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isLoading;
  final double width;
  final double height;
  final Color bgColor;
  final Color textColor;

  const CustomButton(
      {required this.text,
      required this.onPressed,
      this.isLoading = false,
        this.height = 50,
        this.width = double.infinity,
        this.bgColor = Colors.black,
        this.textColor = Colors.white,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: bgColor,
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white,))
            : Center(
                child: Text(
                text,
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
              )),
      ),
    );
  }
}