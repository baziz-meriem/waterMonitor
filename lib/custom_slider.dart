import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CustomSlider extends StatefulWidget {
  const CustomSlider({
    super.key,
    this.height = 400,
    this.width = 200,
});
  final double height;
  final double width;
  @override
  State <CustomSlider> createState()=> _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  //global key for detecting our slider widget
  final GlobalKey _key = LabeledGlobalKey("main_slider");

  //initial values
double _dragPosition = 0;

//drag persentage from 0 to 1,
// for 0 is 0% and 1 is 100%



  final Future<FirebaseApp> _fApp = Firebase.initializeApp();
  double realTimeValue = 0.5;
  double getOnceValue = 0.8;
@override
  Widget build (BuildContext context) {
  DatabaseReference _testRef = FirebaseDatabase.instance.ref().child('test/distance');
  _testRef.onValue.listen(
          (event){
        setState((){
          realTimeValue = event.snapshot.value as double;
        });
      }
  );
  return Scaffold(
      appBar: AppBar(title: Text("Welcome here")),
      body:FutureBuilder(
        future: _fApp,
        builder: (context,snapshot) {
          if(snapshot.hasError) {
            return Text("Semething went wrong with firebase");
          }else if(snapshot.hasData){
            return  Row(
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
                            "${(realTimeValue *100).floor()}%",
                            style:Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        const SizedBox(height:8),
                        ///widget for draw our border
                        ///so we can precisely calculate the main slider and not the border
                        Container(
                            decoration: BoxDecoration(
                              border:Border.all(
                                width:8,
                                color:Colors.grey,
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
                                            clipper: PersentagePainter(persentage: realTimeValue),
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