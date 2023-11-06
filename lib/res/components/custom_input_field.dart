import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
  final String hintText;
  final IconData? icon;
  final bool isPasswordField;
  final TextEditingController controller;
  final TextInputType keyboardInputType;
  final int maxLines;
  final double circularBorderRadius;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;

  const CustomInputField(
      {required this.hintText,
      this.icon,
      this.onChanged,
      this.isPasswordField = false,
      this.circularBorderRadius = 5,
      required this.controller,
      this.keyboardInputType = TextInputType.text,
      this.focusNode,
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
            borderRadius: BorderRadius.circular(widget.circularBorderRadius),
            child: TextFormField(
              focusNode: widget.focusNode,
              onChanged: widget.onChanged,
              maxLines: widget.maxLines,
              controller: widget.controller,
              textInputAction: TextInputAction.next,
              obscureText: widget.isPasswordField ? obscureText.value : false,
              keyboardType: widget.keyboardInputType,
              decoration: InputDecoration(
                filled: true,
                  contentPadding: widget.icon == null
                      ? const EdgeInsets.symmetric(horizontal: 15, vertical: 5)
                      : null,
                  prefixIcon: widget.icon == null ? null : Icon(widget.icon),
                  suffixIcon: !widget.isPasswordField
                      ? null
                      : IconButton(
                          onPressed: () {
                            obscureText.value =
                                obscureText.value ? false : true;
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
