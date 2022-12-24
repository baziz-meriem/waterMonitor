import 'package:flutter/material.dart';
import 'package:flutterprojects/components/My_button.dart';

import '../components/TextField.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn(){}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
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
                  controller: usernameController,
                  hintText: 'User Name',
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
                    onTap: signUserIn),
                const SizedBox(height: 50,),
               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Text('Not a member?', style:TextStyle(color:Colors.grey[700])),
                   const SizedBox(width:4),
                   Text(
                     'Register now',
                     style:TextStyle(
                       color:Colors.blue, fontWeight:FontWeight .bold
                     ),
                   )
                 ],
               )
                ]),
        ),
      ),
    );
  }
}
