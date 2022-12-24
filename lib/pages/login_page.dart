import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterprojects/components/My_button.dart';

import '../components/TextField.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  void signUserIn() async{
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // pop the loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);
      // show error message
      showErrorMessage(e.code);
    }
  }

  // error message to user
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
                children: [
                   const SizedBox(height: 50,),
                   const Icon(
                    Icons.lock,
                    size:100,),
                 const SizedBox(height: 50,),
                  Text('Welcome back you\'ve been missed!',
                  style:TextStyle(color:Colors.grey[700],
                    fontSize:16,
                  ),
                  ),
                  const SizedBox(height:25),
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Forgot password?',
                          style:TextStyle(color:Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  MyButton(
                      text:'Sign In',
                      onTap: signUserIn),
                  const SizedBox(height: 50,),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Text('Not a member?', style:TextStyle(color:Colors.grey[700])),
                     const SizedBox(width:4),
                     GestureDetector(
                       onTap:widget.onTap,
                       child: const Text(
                         'Register now',
                         style:TextStyle(
                           color:Colors.blue, fontWeight:FontWeight .bold
                         ),
                       ),
                     )
                   ],
                 )
                  ]),
          ),
        ),
      ),
    );
  }
}
