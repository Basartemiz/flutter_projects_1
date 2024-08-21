import 'package:flutter/cupertino.dart';

class MyText extends StatefulWidget{

 MyText({Key? key}) : super(key: key);
@override
  StateText createState() => StateText();
}
class StateText extends State<MyText>{
  String text="";
  void changeText(String newString) {
    setState(() {
      text = newString;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Text(text);
    throw UnimplementedError();
  }
}