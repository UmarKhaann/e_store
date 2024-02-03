import 'package:e_store/res/components/custom_button.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final void Function()? onPressed;
  final String buttonTitle;
  final String title;
  final String content;
  const CustomAlertDialog({
    required this.onPressed,
    required this.buttonTitle,
    required this.title,
    required this.content,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      actionsPadding: const EdgeInsets.all(10),
      title: Text(title),
      titleTextStyle: const TextStyle(
          fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
      content: Text(content),
      actions: [
        CustomButton(
          height: 35,
          width: 90,
          text: buttonTitle,
          onPressed: onPressed!,
        ),
        CustomButton(
          height: 35,
          width: 90,
          text: 'Cancel',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
