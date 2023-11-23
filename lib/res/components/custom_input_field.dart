import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
  final String hintText;
  final IconData? icon;
  final Widget? suffixIcon;
  final bool isPasswordField;
  final TextEditingController? controller;
  final TextInputType keyboardInputType;
  final int maxLines;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;
  final EdgeInsets padding;
  final String password;
  final String confirmPassword;

  const CustomInputField(
      {required this.hintText,
      this.icon,
      this.suffixIcon = null,
      this.onChanged,
      this.isPasswordField = false,
      required this.controller,
      this.keyboardInputType = TextInputType.text,
      this.focusNode,
      this.maxLines = 1,
      this.padding =const EdgeInsets.symmetric(vertical: 5),
      this.password = "",
      this.confirmPassword = "",
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
    final OutlineInputBorder border = OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).canvasColor),
                  borderRadius: BorderRadius.circular(10),
                );
    return ValueListenableBuilder(
      valueListenable: obscureText,
      builder: (context, value, child) {
        return Padding(
          padding: widget.padding,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: TextFormField(
              focusNode: widget.focusNode,
              onChanged: widget.onChanged,
              maxLines: widget.maxLines,
              controller: widget.controller,
              textInputAction: TextInputAction.next,
              obscureText: widget.isPasswordField ? obscureText.value : false,
              keyboardType: widget.keyboardInputType,
              decoration: InputDecoration(
                contentPadding: widget.icon == null
                    ? const EdgeInsets.symmetric(horizontal: 15, vertical: 5)
                    : EdgeInsets.zero,
                prefixIcon: widget.icon == null ? null : Icon(widget.icon),
                suffixIcon: !widget.isPasswordField
                    ? widget.suffixIcon
                    : IconButton(
                        onPressed: () {
                          obscureText.value = obscureText.value ? false : true;
                        },
                        icon: Icon(obscureText.value
                            ? Icons.visibility_off
                            : Icons.visibility)),
                hintText: widget.hintText,
                enabledBorder: border,
                focusedBorder: border,
                errorBorder: border,
                focusedErrorBorder: border,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "${widget.hintText} can't be empty!";
                }else if(widget.isPasswordField){
                  if(widget.password != widget.confirmPassword){
                    return "password didn't match!";
                  }
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
