import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'custom_slider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  final Future<FirebaseApp> _fApp = Firebase.initializeApp();
  String realTimeValue = '0';
  String getOnceValue = '0';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome here")),
      body:FutureBuilder(
        future: _fApp,
        builder: (context,snapshot) {
          if(snapshot.hasError) {
            return Text("Semething went wrong with firebase");
          }else if(snapshot.hasData){
            return Center(child: CustomSlider());
          }else{
            return CircularProgressIndicator();
          }
        },
      )
    );
  }
  Widget content(){
    DatabaseReference _testRef = FirebaseDatabase.instance.ref().child('test/distance');
    _testRef.onValue.listen(
        (event){
          setState((){
            realTimeValue = event.snapshot.value.toString();
          });
        }
    );
    return Container(
      child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child:Text(
              "Real Time Counter : $realTimeValue ",
              style:TextStyle(fontSize:20),
            )),
          SizedBox(
            height: 50,
          ),
          GestureDetector(
            onTap:() async {
              //get once firebase value
              final snapshot = await _testRef.get();
              if(snapshot.exists) {
                setState(() {
                  getOnceValue = snapshot.value.toString();
                });
              }
            },
            child:Container(
              height: 50,
              width: 150,
              decoration: BoxDecoration(
                color:Colors.blue,borderRadius:BorderRadius.circular(5)),
    child: Center(
    child:Text(
    "Get Once",
    style:TextStyle(color:Colors.white,fontSize:20),
    ),
              ),
            )
          ),
          SizedBox(
            height: 50,
          ),
          Center(
            child: Text(
              "Get Once Counter :$getOnceValue",
              style:TextStyle(fontSize:20),
            )),
        ],
      )
    );
  }
}
