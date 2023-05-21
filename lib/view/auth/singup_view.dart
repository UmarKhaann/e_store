import 'package:e_store/res/components/custom_input_field.dart';
import 'package:e_store/res/components/stack_background_design.dart';
import 'package:e_store/utils/routes/routes_name.dart';
import 'package:e_store/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import '../../res/components/custom_button.dart';

class SignUpView extends StatelessWidget {
  SignUpView({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: AuthViewModel.signUpBtnLoading,
        builder: (context, value, child) {
          return Stack(
            children: [
              const StackBackground(text: 'SIGNUP'),
              SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    children: [
                      Expanded(flex: 2, child: Container()),
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
                        isLoading: AuthViewModel.signUpBtnLoading.value,
                        onPressed: () {
                          AuthViewModel.signUpUser(
                              context: context,
                              username: _usernameController.text,
                              fullName: _fullNameController.text,
                              email: _emailController.text,
                              phone: _phoneController.text,
                              password: _passwordController.text);
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
                              style: TextStyle(
                                  fontWeight: FontWeight.bold),
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
          );
        },
      ),
    );
  }
}
