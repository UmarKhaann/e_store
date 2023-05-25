import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
  final String hintText;
  final IconData? icon;
  final bool isPasswordField;
  final TextEditingController controller;
  final TextInputType keyboardInputType;
  final int maxLines;

  const CustomInputField(
      {required this.hintText,
      this.icon,
      this.isPasswordField = false,
      required this.controller,
      this.keyboardInputType = TextInputType.text,
      this.maxLines = 1,
      Key? key})
      : super(key: key);

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  ValueNotifier<bool> obscureText = ValueNotifier<bool>(true);

  @override
  void dispose() {
    // TODO: implement dispose
    obscureText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: obscureText,
      builder: (context, value, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: TextFormField(
              maxLines: widget.maxLines,
              controller: widget.controller,
              textInputAction: TextInputAction.next,
              obscureText: widget.isPasswordField ? obscureText.value : false,
              keyboardType: widget.keyboardInputType,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                  contentPadding: widget.icon == null
                      ? const EdgeInsets.symmetric(horizontal: 10, vertical: 5)
                      : null,
                  prefixIcon:
                      widget.icon == null ? null : Icon(widget.icon),
                  suffixIcon: !widget.isPasswordField
                      ? null
                      : IconButton(
                          onPressed: () {
                            obscureText.value = obscureText.value? false: true;
                          },
                          icon: Icon(obscureText.value
                              ? Icons.visibility_off
                              : Icons.visibility)),
                  hintText: widget.hintText,
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
