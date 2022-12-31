import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import '../waterTank_page.dart';

class HomePage extends StatelessWidget {
   HomePage({super.key});

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
          itemBuilder: (
              context,
              snapshot,
              animation,
              index){
            var distance = double.parse(snapshot.child('distance').value.toString());
            return Card(
              elevation: 20,
              child: ListTile(
                title:Text("water level percentage"+"\n"+snapshot.child('distance').value.toString()+"%",style: TextStyle(fontSize: 21,fontWeight: FontWeight.bold,color:Colors.indigo[900]),),
                subtitle: Text("sensor still functional "+"\n"+snapshot.child('functional').value.toString(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.grey[600])),
                trailing: Icon(Icons.arrow_forward_ios),
                contentPadding: EdgeInsets.all(12),

               onTap: (){
                 Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context)=> waterTank(distance: distance))
               ); },
               iconColor:Colors.indigo[900],
                textColor: Colors.black,
              ),
            );
          },
        ),
      ),
      /*floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your onPressed code here!
        },
        label: const Text('ADD'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.grey[900],
      ),*/
    );
  }

}
