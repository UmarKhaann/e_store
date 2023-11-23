import 'dart:io';

import 'package:e_store/provider/image_controller.dart';
import 'package:e_store/repository/auth_repo.dart';
import 'package:e_store/repository/home_repo.dart';
import 'package:e_store/res/components/custom_button.dart';
import 'package:e_store/res/components/custom_input_field.dart';
import 'package:e_store/view_model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late TextEditingController userNameController;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  void initState() {
    final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    nameController =
        TextEditingController(text: homeViewModel.userData.data()['fullName']);
    emailController =
        TextEditingController(text: homeViewModel.userData.data()['email']);
    phoneController =
        TextEditingController(text: homeViewModel.userData.data()['phone']);
    passwordController =
        TextEditingController(text: homeViewModel.userData.data()['password']);
    confirmPasswordController =
        TextEditingController(text: homeViewModel.userData.data()['password']);
    userNameController =
        TextEditingController(text: homeViewModel.userData.data()['username']);
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String? image = HomeRepo.auth.currentUser!.photoURL;
    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        builder: (context) {
                          final imageController = Provider.of<ImageController>(
                              context,
                              listen: false);
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                onTap: () {
                                  imageController.setImage(
                                      imageSource: ImageSource.camera);
                                  Navigator.pop(context);
                                },
                                title: const Text('Take a photo'),
                              ),
                              ListTile(
                                onTap: () {
                                  imageController.setImage(
                                      imageSource: ImageSource.gallery);
                                  Navigator.pop(context);
                                },
                                title: const Text('Pick from gallery'),
                              ),
                              ListTile(
                                onTap: () {
                                  AuthRepo.removeProfileImage(context);
                                  Navigator.pop(context);
                                },
                                title: const Text('Remove photo'),
                              ),
                              ListTile(
                                onTap: () => Navigator.pop(context),
                                title: const Text('Cancel'),
                              ),
                            ],
                          );
                        });
                  },
                  child: Consumer<ImageController>(
                    builder: (context, imageController, child) {
                      return CircleAvatar(
                        radius: 70,
                        backgroundColor: Theme.of(context).cardColor,
                        backgroundImage: imageController.image != null
                            ? FileImage(File(imageController.image.path))
                            : image == null
                                ? null
                                : NetworkImage(image) as ImageProvider,
                        child: image == null && imageController.image == null
                            ? const Text('Add image')
                            : null,
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(' Username'),
                CustomInputField(
                  hintText: '',
                  controller: userNameController,
                  padding: const EdgeInsets.only(bottom: 10),
                  onChanged: (value) {
                    formkey.currentState!.validate();
                  },
                ),
                const Text(' Enter your name'),
                CustomInputField(
                  hintText: '',
                  controller: nameController,
                  padding: const EdgeInsets.only(bottom: 10),
                  onChanged: (value) {
                    formkey.currentState!.validate();
                  },
                ),
                const Text(' Email'),
                CustomInputField(
                  hintText: '',
                  controller: emailController,
                  padding: const EdgeInsets.only(bottom: 10),
                  onChanged: (value) {
                    formkey.currentState!.validate();
                  },
                ),
                const Text(' Phone'),
                CustomInputField(
                  hintText: '',
                  controller: phoneController,
                  padding: const EdgeInsets.only(bottom: 10),
                  onChanged: (value) {
                    formkey.currentState!.validate();
                  },
                ),
                const Text(' Password'),
                CustomInputField(
                  hintText: '',
                  controller: passwordController,
                  isPasswordField: true,
                  padding: const EdgeInsets.only(bottom: 10),
                  onChanged: (value) {
                    formkey.currentState!.validate();
                  },
                  password: passwordController.text,
                  confirmPassword: confirmPasswordController.text,
                ),
                const Text(' Confirm password'),
                CustomInputField(
                  hintText: '',
                  controller: confirmPasswordController,
                  isPasswordField: true,
                  padding: const EdgeInsets.only(bottom: 10),
                  onChanged: (value) {
                    formkey.currentState!.validate();
                  },
                  password: passwordController.text,
                  confirmPassword: confirmPasswordController.text,
                ),
                CustomButton(
                    text: 'Save',
                    isLoading: AuthRepo.btnLoading.value,
                    onPressed: () {
                      if (formkey.currentState!.validate()) {
                        AuthRepo.updateUserInfo(
                          context: context,
                          name: nameController.text,
                          email: emailController.text,
                          phone: phoneController.text,
                          password: passwordController.text,
                        );
                        HomeRepo.getUserData(context);
                      }
                    }),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
