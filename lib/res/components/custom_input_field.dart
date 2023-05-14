import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool isPasswordField;
  final TextEditingController controller;
  final TextInputType keyboardInputType;
  final ValueNotifier<bool> obscureText = ValueNotifier<bool>(true);

  CustomInputField(
      {required this.hintText,
      required this.icon,
      this.isPasswordField = false,
      required this.controller,
      this.keyboardInputType = TextInputType.text,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: obscureText,
      builder: (context, value, child){
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: TextFormField(
              controller: controller,
              textInputAction: TextInputAction.next,
              obscureText: isPasswordField ? obscureText.value : false,
              keyboardType: keyboardInputType,
              textCapitalization: TextCapitalization.words,
              decoration: isPasswordField
                  ? InputDecoration(
                  prefixIcon: Icon(
                    icon,
                    color: Colors.black,
                  ),
                  suffixIcon: IconButton(
                      onPressed: () {
                        obscureText.value =
                        !obscureText.value;
                      },
                      icon: Icon(
                        obscureText.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      )),
                  hintText: hintText,
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: InputBorder.none)
                  : InputDecoration(
                  prefixIcon: Icon(
                    icon,
                    color: Colors.black,
                  ),
                  hintText: hintText,
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: InputBorder.none),
            ),
          ),
        );
      },
    );
  }
}
