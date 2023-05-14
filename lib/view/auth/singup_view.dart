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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: ValueListenableBuilder(
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
                          hintText: 'Email',
                          icon: Icons.mail,
                          controller: _emailController,
                          keyboardInputType: TextInputType.emailAddress,
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
                                email: _emailController.text,
                                password: _passwordController.text,
                                username: _usernameController.text);
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
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
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
      ),
    );
  }
}
