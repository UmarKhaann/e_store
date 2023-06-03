import 'package:e_store/res/components/custom_button.dart';
import 'package:flutter/material.dart';

class CustomAlertBox extends StatelessWidget {
  final String title;
  final String content;
  final void Function()? yesOnPressed;
  final void Function()? noOnPressed;

  const CustomAlertBox({
    required this.title,
    required this.content,
    required this.yesOnPressed,
    required this.noOnPressed,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(title),
      content: Text(content),
      actions: [
        CustomButton(
            height: 35,
            width: 90,
            text: 'Yes',
            onPressed: yesOnPressed!),
        CustomButton(
            height: 35,
            width: 90,
            text: 'No',
            onPressed: noOnPressed!),
      ],
    );
  }
}
