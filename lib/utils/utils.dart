import 'package:flutter/material.dart';

class Utils {
  static snackBarMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  static fieldFocusChange(BuildContext context, FocusNode? currentFocus,
      FocusNode? nextFocus) {
    currentFocus?.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
