import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isLoading;

  const CustomButton(
      {required this.text,
      required this.onPressed,
      this.isLoading = false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white,))
            : Center(
                child: Text(
                text,
                style: const TextStyle(color: Colors.white),
              )),
      ),
    );
  }
}
