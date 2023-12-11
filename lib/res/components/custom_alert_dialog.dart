import 'package:e_store/res/components/custom_button.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final void Function()? onPressed;
  final String buttonTitle;
  const CustomAlertDialog(
      {required this.onPressed, required this.buttonTitle, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      actionsPadding: const EdgeInsets.all(10),
      content: const Text('Are you sure?'),
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
