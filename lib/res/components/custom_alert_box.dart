import 'package:e_store/res/components/custom_button.dart';
import 'package:flutter/material.dart';

import '../../utils/routes/routes_name.dart';
import '../../utils/utils.dart';
import '../../view_model/auth_view_model.dart';

class CustomAlertBox extends StatelessWidget {
  const CustomAlertBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: const Text('Alert!'),
      content: const Text('Do you really want to Log out?'),
      actions: [
        CustomButton(
            height: 35,
            width: 90,
            text: 'Yes',
            onPressed: () {
              AuthViewModel.signOutUser();
              Navigator.pushReplacementNamed(context, RoutesName.loginView);
              Utils.flushBarMessage(
                  context, 'User logged out successfully');
            }),
        CustomButton(
            height: 35,
            width: 90,
            text: 'No',
            onPressed: () {
              Navigator.of(context).pop(false);
            }),
      ],
    );
  }
}
