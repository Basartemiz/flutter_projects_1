
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CalButton extends StatelessWidget{
final VoidCallback? onPressed;
   final String buttonText;
   final Widget child; 
  CalButton({Key? key, 
    this.onPressed,
    required this.buttonText,
    required this.child}) : super(key: key);
    @override
  Widget build(BuildContext context) {
    return
     Container(
      padding:EdgeInsets.all(2),
      width: 5,
      height: 10,
      child:FloatingActionButton(
        backgroundColor: Color.fromRGBO(255, 133, 27,1),
        onPressed: onPressed,child: child,));
    
  }
}