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
bool _showPersentage = false;
double _dragPosition = 0;

//drag persentage from 0 to 1,
// for 0 is 0% and 1 is 100%
double _dragPersentage = 0.5;

void _onDragStart(DragStartDetails details) {
if (_key.currentContext == null) return;
 //we'll find the render box from specific widget that has key: _key
  final renderBox = _key.currentContext!.findRenderObject() as RenderBox;
 // from the rendre box we obtain its positiion and offset
 /// by calculation global position (our gesture) to the renderbox
  /// we can obtain which part of the widget/ rendrebox that we tap/drag
  final offset = renderBox.globalToLocal(details.globalPosition);
  _onDrag(offset);
}
void _onDragUpdate(DragUpdateDetails details) {
  if(_key.currentContext == null) return;
  ///we will find the rendre box from specific widget that has key:_key
  final renderBox = _key.currentContext!.findRenderObject() as RenderBox;
  //from the render box we obtain its position and offset,
  //by calculating global pos (our gesture) to the renderbox
  //we can obtain which part of the widget that were tapping
  final offset = renderBox.globalToLocal(details.globalPosition);
  _onDrag(offset);
}
void _onDragEnd(DragEndDetails details) {
  setState((){
    ///after we done draging and taping we hide the widget that shows much we drag
    _showPersentage = false;
  });
}
void _onDrag(Offset offset ) {
  ///after we have which part of the widget/rendrebox we are tp/drag
  ///we can manipulate that info
  double tempDragPosition = 0;
  if(offset.dy <= 0) {
    tempDragPosition = 0;
  } else if(offset.dy >= widget.height) {
    tempDragPosition = widget.height;
  }else {
  tempDragPosition = offset.dy;
  }
  setState(() {
    _dragPosition = tempDragPosition;
    ///in this case we will manipulate it
    ///to get the value of how much we drag on our widget
    _dragPersentage = _dragPosition/ widget.height;
    /// and when we tap it it will show the widget that show how much we dragged
    if(!_showPersentage) _showPersentage = true;
  });
}
@override
  Widget build (BuildContext context) {
  return Row(
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
            opacity:_showPersentage ? 1 : 0,
            child :Text(
              "${(_dragPersentage *100).floor()}%",
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
          child:GestureDetector(
            onVerticalDragStart: _onDragStart,
            onVerticalDragUpdate: _onDragUpdate,
            onVerticalDragEnd: _onDragEnd,
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
                    clipper: PersentagePainter(persentage:_dragPersentage),
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
          )
        ]
      )
    ]

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