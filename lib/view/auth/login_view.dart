import 'package:e_store/utils/routes/routes_name.dart';
import 'package:e_store/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import '../../res/components/custom_button.dart';
import '../../res/components/custom_input_field.dart';
import '../../res/components/stack_background_design.dart';

class LoginView extends StatefulWidget {
  LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: AuthViewModel.logInBtnLoading,
        builder: (context, value, child) {
          return Stack(
            children: [
              const StackBackground(text: 'LOGIN'),
              SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    children: [
                      Expanded(flex: 2, child: Container()),
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
                          text: 'LOGIN',
                          isLoading: AuthViewModel.logInBtnLoading.value,
                          onPressed: () async {
                            await AuthViewModel.logInUser(
                                context: context,
                                email: _emailController.text,
                                password: _passwordController.text);
                          }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text("Don't have an account?"),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, RoutesName.signUpView);
                            },
                            child: const Text(
                              'SIGNUP',
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
