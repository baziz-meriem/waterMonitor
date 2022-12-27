import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutterprojects/pages/auth_page.dart';
import 'package:flutterprojects/pages/login_page.dart';
import 'package:flutterprojects/pages/loginor_register_page.dart';
import 'package:flutterprojects/pages/register_page.dart';
import 'firebase_options.dart';

import 'waterTank_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {

  const MyApp({super.key});
  @override
  State<MyApp> createState()=> _MyAppState();
}
class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return AuthPage();

  }

}
