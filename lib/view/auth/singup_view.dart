import 'dart:io';

import 'package:e_store/provider/image_controller.dart';
import 'package:e_store/repository/auth_repo.dart';
import 'package:e_store/res/components/custom_input_field.dart';
import 'package:e_store/res/components/stack_background_design.dart';
import 'package:e_store/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../res/components/custom_button.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            const StackBackground(),
            Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(flex: 2, child: Container()),
                    Consumer<ImageController>(
                      builder: (context, providerImage, child) {
                        final image = providerImage.image;
                        return InkWell(
                            onTap: () {
                              providerImage.setImage(imageSource: ImageSource.gallery);
                            },
                            child: CircleAvatar(
                              radius: 70,
                              backgroundColor: Theme.of(context).cardColor,
                              backgroundImage: image != null
                                  ? FileImage(File(image.path))
                                  : null,
                              child: image == null
                                  ? const Icon(Icons.person_add_alt_1_rounded)
                                  : null,
                            ));
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomInputField(
                      hintText: 'Username',
                      icon: Icons.person,
                      controller: _usernameController,
                    ),
                    CustomInputField(
                      hintText: 'Full Name',
                      icon: Icons.person,
                      controller: _fullNameController,
                    ),
                    CustomInputField(
                      hintText: 'Email',
                      icon: Icons.mail,
                      controller: _emailController,
                      keyboardInputType: TextInputType.emailAddress,
                    ),
                    CustomInputField(
                      hintText: 'Phone Number',
                      icon: Icons.person,
                      controller: _phoneController,
                      keyboardInputType: TextInputType.phone,
                    ),
                    CustomInputField(
                        hintText: 'Password',
                        icon: Icons.lock,
                        isPasswordField: true,
                        controller: _passwordController),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      text: 'SIGNUP',
                      isLoading: AuthRepo.btnLoading.value,
                      onPressed: () {
                        if(_formkey.currentState!.validate()){
                          AuthRepo.signUpUser(
                            context: context,
                            username: _usernameController.text,
                            fullName: _fullNameController.text,
                            email: _emailController.text,
                            phone: _phoneController.text,
                            password: _passwordController.text);
                        }
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text('Already have an account?'),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, RoutesName.loginView);
                          },
                          child: const Text(
                            'LOGIN',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    Expanded(child: Container()),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
