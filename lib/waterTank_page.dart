import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class waterTank extends StatefulWidget {
  const waterTank({
    super.key,
    this.height = 320,
    this.width = 200,
    this.distance=0,
});
  final double distance;
  final double height;
  final double width;
  @override
  State <waterTank> createState()=> _waterTankState();
}

class _waterTankState extends State<waterTank> {

  //global key for detecting our slider widget
  final GlobalKey _key = LabeledGlobalKey("main_slider");

  final Future<FirebaseApp> _fApp = Firebase.initializeApp();
  Widget build (BuildContext context) {
  /*DatabaseReference _testRef = FirebaseDatabase.instance.ref().child('test/distance');
  _testRef.onValue.listen(
          (event){
        setState((){
          distance= event.snapshot.value as double;
        });
      }
  );*/
  return Scaffold(
      appBar: AppBar(title: Text("Water Tank Monitor"),backgroundColor: Colors.indigo[900],),
      backgroundColor: Colors.indigo[50],
      body:FutureBuilder(
        future: _fApp,
        builder: (context,snapshot) {
          if(snapshot.hasError) {
            return Text("Semething went wrong with firebase");
          }else if(snapshot.hasData){
            return  Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left:0,top:10,right:0,bottom:15),
                  child: Container(
                    height: 90,
                   child: Expanded(
                     child: ListView(
                       scrollDirection: Axis.horizontal,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: InkWell(
                              onTap: (){},
                              child:Container(
                                width: 150,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color:Colors.indigo[50],border: Border.all(
                                  width: 2,color: (Colors.indigo[800])!
                                ),),
                                child: Center(child: RichText(
                                  text: TextSpan(
                                    style: DefaultTextStyle.of(context).style,

                                    children: <TextSpan>[
                                      TextSpan(
                                        text: "Litters to fill\n",
                                        style: TextStyle(color: Colors.black.withOpacity(0.6),fontSize: 18,fontWeight:FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: "20 L",
                                        style: TextStyle(color: Colors.black.withOpacity(0.8),fontSize: 18,fontWeight:FontWeight.bold,),

                                      ),
                                    ],
                                  ),
                                )),
                              )
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: InkWell(
                                onTap: (){},
                                child:Container(
                                  width: 150,
                                  decoration: BoxDecoration(

                                      borderRadius: BorderRadius.circular(10),
                                      color:Colors.indigo[50],

                                    border: Border.all(
                                      width: 2,color: (Colors.indigo[800])!
                                    ),),
                                  child: Center(child: RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: "Remaining\n",
                                          style: TextStyle(color: Colors.black.withOpacity(0.6),fontSize: 18,fontWeight:FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text: "5 L",
                                          style: TextStyle(color: Colors.black.withOpacity(0.8),fontSize: 18,fontWeight:FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  )),
                                )
                            ),
                          )
                        ],
                      ),
                   ), ),
                ),
                      Padding(
                      padding: const EdgeInsets.only(left :0,top:0,right:30,bottom:10),
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children:[
                            //precision indicator
                            Container(
                              height: widget.height,
                              margin:const EdgeInsets.fromLTRB(0,0,8,4),
                              child:Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: List.generate(11,(index) {
                                  return Text(
                                    "${100-(index*10)}",
                                  );
                                }),
                              ),
                            ),
                            Column(
                                mainAxisSize: MainAxisSize.min,
                                children:[
                                  AnimatedOpacity(
                                    duration: const Duration(milliseconds: 100),
                                    opacity:1,
                                    child :Text(
                                      "${(widget.distance *100).floor()}%",
                                      style:Theme.of(context).textTheme.headlineSmall,
                                    ),
                                  ),
                                  const SizedBox(height:8),
                                  ///widget for draw our border
                                  ///so we can precisely calculate the main slider and not the border
                                  Container(
                                      decoration: BoxDecoration(
                                        border:Border.all(
                                          width:5,
                                          color:Colors.blueGrey,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      ///gesture detector for detecting vertical drag
                                      /// so we can drag vertical to change the persentage of the slider
                                      child:RotatedBox(
                                        ///so that the y offset 0% is on the bottom,
                                          quarterTurns: 2,
                                          child:Container(
                                              key:_key,
                                              height: widget.height,
                                              width:widget.width,
                                              decoration: BoxDecoration(

                                                borderRadius:BorderRadius.circular(8),
                                              ),
                                              /// the widget that draw of how much we tap/drag its parent,
                                              /// and use absorb pointer so this widget and its child
                                              /// will pass the gesture so the parent widget can detect
                                              child:AbsorbPointer(
                                                  child:ClipPath(
                                                    /// we cut path base on how much we tap its parent
                                                      clipper: PersentagePainter(persentage: widget.distance),
                                                      child:Container(
                                                        height: widget.height,
                                                        width: widget.width,
                                                        decoration: BoxDecoration(
                                                            borderRadius:BorderRadius.circular(8),
                                                            gradient:const LinearGradient(
                                                              colors:[
                                                                Colors.blueAccent,
                                                                Colors.lightBlueAccent,
                                                              ],
                                                              begin:AlignmentDirectional.bottomEnd,
                                                              end:AlignmentDirectional.topCenter,
                                                            )
                                                        ),
                                                      )
                                                  )
                                              )
                                          )
                                      )
                                  )
                                ]
                            )
                          ]

                      ),
                    ),
                  ],
            );
          }else{
            return CircularProgressIndicator();
          }
        },
      )
  );

}

}
///custom clippath for cutting path base on how much we tapdrag its parent

class PersentagePainter extends CustomClipper<Path> {
  final double persentage;
  PersentagePainter({
    this.persentage = 0,
});
  @override
  Path getClip (Size size) {
    final path =Path();
    path.moveTo(0,size.height * persentage);
    path.lineTo(0,0);
    path.lineTo(size.width,0);
    path.lineTo(size.width,size.height * persentage);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}