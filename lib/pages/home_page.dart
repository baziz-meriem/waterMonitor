import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import '../components/TextField.dart';
import '../waterTank_page.dart';


class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final firebaseRef = FirebaseDatabase.instance.ref().child("test/sensors");

  final user = FirebaseAuth.instance.currentUser!;

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      appBar: AppBar(title: Text("Overview"),
        backgroundColor: Colors.indigo[900],
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: SafeArea(

        child: FirebaseAnimatedList(
          padding: EdgeInsets.all(12),
          query: firebaseRef.orderByChild("user_Id").equalTo(user.uid),
          itemBuilder: (context,
              snapshot,
              animation,
              index) {

            var percentage = double.parse(snapshot
                .child('percentage')
                .value
                .toString());


            return Card(
              elevation: 20,
              child: ListTile(
                title: Text("Water Level" + "  "+snapshot
                    .child('percentage')
                    .value
                    .toString() + "%", style: TextStyle(fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[900]),),
                subtitle: Text("\n"+"Total liters " + "    " + snapshot
                    .child('totalLiters')
                    .value
                    .toString()+"\n"+"Radius value"+"  "+snapshot.child('r').value.toString()+"\n"+"Height value"+"  "+snapshot.child('totalHeight').value.toString(), style: TextStyle(fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[850])),

                trailing: PopupMenuButton(
                  icon: Icon(Icons.more_vert),
                  itemBuilder: (context) =>
                  [
                    PopupMenuItem(
                        value: 1,
                        child: ListTile(
                          onTap: () {
                            Navigator.pop(context);
                            showMyDialog(context,snapshot.child('sensor_Id').value.toString());
                          },
                          leading: Icon(Icons.edit),
                          title: Text('Edit'),
                        )
                    )
                  ],
                ),
                contentPadding: EdgeInsets.all(19),

                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          waterTank(percentage: percentage))
                  );
                },
                iconColor: Colors.indigo[900],
                textColor: Colors.black,
              ),
            );

          },

        ),

      ),

    );

  }
}
void showMyDialog(BuildContext cxt,String id) {
  final rController = TextEditingController();
  final heightController = TextEditingController();
  final litersController = TextEditingController();

  showDialog(
    context:cxt,
    builder: (context) {
      return AlertDialog(
        title:Text('Update Watertank Data',style: TextStyle(fontSize: 21,
        fontWeight: FontWeight.bold,
        color: Colors.indigo[900]),),
        content:SingleChildScrollView(
          child :SafeArea(
          child: Column(
              mainAxisSize: MainAxisSize.min,
      children: [
      const SizedBox(height:10),
          MyTextField(
            controller: rController,
            hintText: 'WaterTank radius',
            obscureText: false,
          ),
          MyTextField(
            controller: heightController,
            hintText: 'Total height',
            obscureText: false,
          ),
          MyTextField(
            controller: litersController,
            hintText: 'Total liters',
            obscureText: false,
          ),

      ]),
        ),
        ),
        backgroundColor: Colors.indigo[50],
        actions:[
          TextButton(onPressed: (){
            Navigator.pop(context);
            var ref=FirebaseDatabase.instance.ref().child("test/sensors");
            ref.child(id).update({
              'r':double.parse(rController.text),
              'totalHeight':double.parse(heightController.text),
              'totalLiters':double.parse(litersController.text)
            });
          }, child: Text('Update', style: TextStyle(fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.indigo[900]))),
          TextButton(onPressed: (){
            Navigator.pop(context);

          }, child: Text('Cancel', style: TextStyle(fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.indigo[900]))),
        ],
      );
    },
  );


}