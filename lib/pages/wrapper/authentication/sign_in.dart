import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:messenger/const/const_color.dart';
import 'package:messenger/service/custom_firebase.dart';
import 'package:messenger/shared/input_dec.dart';
import 'package:messenger/utils/auth_setting.dart';
import 'package:messenger/utils/custom_snackbar.dart';
import 'package:provider/provider.dart';

class SignIn extends HookWidget {
  const SignIn({Key? key}) : super(key: key);

  Widget _showDialog(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  static final _auth = CustomFirebase.instance;
  @override
  Widget build(BuildContext context) {
    final screenState = Provider.of<Authsettings>(context, listen: false);
    final userEmailCtrl = TextEditingController();
    final userPasswordCtrl = TextEditingController();
    return screenState.isPress
        ? _showDialog(context)
        : Scaffold(
            backgroundColor: bgColor,
            body: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 180),
                    const Text(
                      'Sign In',
                      style: TextStyle(
                        color: textInput,
                        fontSize: 30,
                      ),
                    ),
                    const SizedBox(height: 50),
                    TextField(
                      controller: userEmailCtrl,
                      decoration: inputDecoration.copyWith(hintText: 'Email'),
                    ),
                    const SizedBox(height: 30),
                    Consumer<Authsettings>(
                      builder: (_, data, __) {
                        return TextField(
                          obscureText: screenState.isSeen,
                          controller: userPasswordCtrl,
                          decoration: inputDecoration.copyWith(
                            hintText: 'Password',
                            suffixIcon: IconButton(
                              icon: Icon(!data.isSeen
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                screenState.toggleSeen();
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 50),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (userEmailCtrl.text == '' ||
                              !userEmailCtrl.text.contains('@')) {
                            customSnack('Provide valid email', context);
                          } else if (userPasswordCtrl.text == '' ||
                              userPasswordCtrl.text.length < 6) {
                            customSnack('Password can\'t be empty', context);
                          } else {
                            screenState.toggleToHomeTrue();
                            dynamic user =
                                await _auth.signInAccountWithEmailAndPassword(
                              email: userEmailCtrl.text.trim(),
                              password: userPasswordCtrl.text.trim(),
                            );
                            if (user == null) {
                              screenState.toggleToHomeFalse();
                              customSnack(_auth.errorMess.toString(), context);
                            }
                          }
                        },
                        child: const Text('Login'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50.0),
                      child: Consumer<Authsettings>(
                        builder: (_, data, __) {
                          return RichText(
                            text: TextSpan(children: [
                              const TextSpan(text: 'Don\'t have an account? '),
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    data.toggleFunc();
                                  },
                                text: ' Sign Up',
                                style: const TextStyle(
                                  color: textInput,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ]),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
