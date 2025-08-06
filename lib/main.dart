import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uber_app/Screen/Form/SignIn.dart';
import 'config/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


void main() async{
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'UberApp',
      debugShowCheckedModeBanner: false,
      home: SignIn(),
    );
  }
}
