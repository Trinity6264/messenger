import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:messenger/models/firebase_model.dart';
import 'package:messenger/pages/loading.dart';
import 'package:messenger/service/custom_firebase.dart';
import 'package:messenger/utils/auth_setting.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp],
  );
  runApp((const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Authsettings>.value(
          value: Authsettings(),
        ),
        StreamProvider<FirebaseModel?>.value(
          initialData: FirebaseModel(email: '', name: '', uid: ''),
          value: CustomFirebase.instance.userData,
          catchError: (_, __) => null,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Messenger',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: const Loading(),
      ),
    );
  }
}
