import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String hintText;
  final IconData? icon;
  final bool isPasswordField;
  final TextEditingController controller;
  final TextInputType keyboardInputType;
  final ValueNotifier<bool> obscureText = ValueNotifier<bool>(true);
  final int maxLines;

  CustomInputField(
      {required this.hintText,
      this.icon,
      this.isPasswordField = false,
      required this.controller,
      this.keyboardInputType = TextInputType.text,
      this.maxLines = 1,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: obscureText,
      builder: (context, value, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: TextFormField(
              maxLines: maxLines,
              controller: controller,
              textInputAction: TextInputAction.next,
              obscureText: isPasswordField ? obscureText.value : false,
              keyboardType: keyboardInputType,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                  contentPadding: icon == null
                      ? const EdgeInsets.symmetric(horizontal: 10, vertical: 5)
                      : null,
                  prefixIcon:
                      icon == null ? null : Icon(icon, color: Colors.black),
                  suffixIcon: !isPasswordField
                      ? null
                      : IconButton(
                          onPressed: () {
                            obscureText.value = !obscureText.value;
                          },
                          icon: Icon(obscureText.value
                              ? Icons.visibility_off
                              : Icons.visibility)),
                  hintText: hintText,
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: InputBorder.none),
              validator: (value) {
                if (value == null) {
                  return "field can't be empty!";
                }
                return null;
              },
            ),
          ),
        );
      },
    );
  }
}
