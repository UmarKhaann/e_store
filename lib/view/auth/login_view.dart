import 'package:e_store/repository/auth_repo.dart';
import 'package:e_store/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';

import '../../res/components/custom_button.dart';
import '../../res/components/custom_input_field.dart';
import '../../res/components/stack_background_design.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  focusNode: _emailFocusNode,
                  hintText: 'Email',
                  icon: Icons.mail,
                  controller: _emailController,
                  keyboardInputType: TextInputType.emailAddress,
                ),
                CustomInputField(
                    focusNode: _passwordFocusNode,
                    hintText: 'Password',
                    icon: Icons.lock,
                    isPasswordField: true,
                    controller: _passwordController),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                    text: 'LOGIN',
                    isLoading: AuthRepo.logInBtnLoading.value,
                    onPressed: () async {
                      await AuthRepo.logInUser(
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
                Expanded(
                  flex: _emailFocusNode.hasFocus || _passwordFocusNode.hasFocus ? 2 : 1,
                  child: Container(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
