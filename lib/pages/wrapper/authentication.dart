import 'package:flutter/material.dart';
import 'package:messenger/pages/wrapper/authentication/sign_in.dart';
import 'package:messenger/pages/wrapper/authentication/sign_up.dart';
import 'package:messenger/utils/auth_setting.dart';
import 'package:provider/provider.dart';

class Authentication extends StatelessWidget {
  const Authentication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _authset = Provider.of<Authsettings>(context, listen: false);
    return Consumer<Authsettings>(builder: (_, data, __) {
      return !_authset.isPressed ? const SignIn() : const SignUp();
    });
  }
}
