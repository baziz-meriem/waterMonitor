import 'package:flutter/material.dart';
import 'package:flutterprojects/components/My_button.dart';

import '../components/TextField.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmpasswordController = TextEditingController();

  void signUserUp(){}

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
                    size:80,),
                  const SizedBox(height: 50,),
                  Text('Let\'s create an account for you!',
                    style:TextStyle(color:Colors.grey[700],
                      fontSize:16,
                    ),
                  ),
                  const SizedBox(height:20),
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
                  MyTextField(
                    controller: confirmpasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                  ),

                  const SizedBox(height: 20),
                  MyButton(
                      onTap: signUserUp),
                  const SizedBox(height: 50,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account ?', style:TextStyle(color:Colors.grey[700])),
                      const SizedBox(width:4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Login now',
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
