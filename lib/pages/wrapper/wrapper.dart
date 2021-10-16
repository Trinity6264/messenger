import 'package:flutter/material.dart';
import 'package:messenger/models/firebase_model.dart';
import 'package:messenger/pages/wrapper/authentication.dart';
import 'package:messenger/pages/wrapper/home/home_page.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseModel?>(context);
    return user != null ? const HomePage() : const Authentication();
  }
}
