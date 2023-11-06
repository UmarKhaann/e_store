import 'package:e_store/res/components/custom_input_field.dart';
import 'package:e_store/res/components/stack_background_design.dart';
import 'package:e_store/utils/routes/routes_name.dart';
import 'package:e_store/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';

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
      body: Stack(
        children: [
          const StackBackground(),
          Container(
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
          )
        ],
      ),
    );
  }
}
