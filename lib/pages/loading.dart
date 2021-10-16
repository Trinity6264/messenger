import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:messenger/const/const_color.dart';
import 'package:messenger/pages/wrapper/wrapper.dart';

class Loading extends HookWidget {
  const Loading({Key? key}) : super(key: key);

  void _delayed(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const Wrapper(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    _delayed(context);
    return Scaffold(
      backgroundColor: bgColor,
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Spacer(),
            Text(
              'Messenger',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 100,
            ),
            CircularProgressIndicator.adaptive(backgroundColor: Colors.white),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
