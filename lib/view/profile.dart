import 'dart:io';

import 'package:e_store/provider/image_provider.dart';
import 'package:e_store/repository/auth_repo.dart';
import 'package:e_store/repository/home_repo.dart';
import 'package:e_store/res/components/custom_button.dart';
import 'package:e_store/res/components/custom_input_field.dart';
import 'package:e_store/view_model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
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

  updateUserData(image) async {
    if (formkey.currentState!.validate()) {
      await AuthRepo.updateUserInfo(
        context: context,
        profileImage: image is XFile
            ? image.path
            : image,
        name: nameController.text,
        email: emailController.text,
        phone: phoneController.text,
        password: passwordController.text,
      );
      HomeRepo.getUserData(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        child: Consumer<ImageProviderFromGallery>(
          builder: (context, imageProviderFromgallery, child) {
            final bool hasProfileImage = imageProviderFromgallery.image == null;
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        imageProviderFromgallery.setImage();
                      },
                      child: imageProviderFromgallery.image is XFile
                          ? CircleAvatar(
                              radius: 70,
                              backgroundColor: Theme.of(context).cardColor,
                              backgroundImage: FileImage(File(
                                  '${imageProviderFromgallery.image.path}')),
                              child: hasProfileImage
                                  ? const Text('Add image')
                                  : null,
                            )
                          : CircleAvatar(
                              radius: 70,
                              backgroundColor: Theme.of(context).cardColor,
                              backgroundImage: NetworkImage(
                                  imageProviderFromgallery.image),
                              child: hasProfileImage
                                  ? const Text('Add image')
                                  : null,
                            ),
                    ),
                    const SizedBox(height: 20,),
                    const Text(' Username'),
                    CustomInputField(
                      hintText: '',
                      controller: userNameController,
                      padding: const EdgeInsets.only(bottom: 10),
                      onChanged: (value){
                        formkey.currentState!.validate();
                      },
                    ),
                    const Text(' Enter your name'),
                    CustomInputField(
                      hintText: '',
                      controller: nameController,
                      padding: const EdgeInsets.only(bottom: 10),
                      onChanged: (value){
                        formkey.currentState!.validate();
                      },
                    ),
                    const Text(' Email'),
                    CustomInputField(
                      hintText: '',
                      controller: emailController,
                      padding: const EdgeInsets.only(bottom: 10),
                      onChanged: (value){
                        formkey.currentState!.validate();
                      },
                    ),
                    const Text(' Phone'),
                    CustomInputField(
                      hintText: '',
                      controller: phoneController,
                      padding: const EdgeInsets.only(bottom: 10),
                      onChanged: (value){
                        formkey.currentState!.validate();
                      },
                    ),
                    const Text(' Password'),
                    CustomInputField(
                      hintText: '',
                      controller: passwordController,
                      isPasswordField: true,
                      padding: const EdgeInsets.only(bottom: 10),
                      onChanged: (value){
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
                      onChanged: (value){
                        formkey.currentState!.validate();
                      },
                      password: passwordController.text,
                      confirmPassword: confirmPasswordController.text,
                    ),
                    CustomButton(
                        text: 'Save',
                        isLoading: AuthRepo.updateBtnLoading.value,
                        onPressed: () {
                          updateUserData(imageProviderFromgallery.image);
                        }),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
