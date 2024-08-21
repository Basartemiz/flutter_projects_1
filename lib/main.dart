
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:namer_app/myText.dart';
import 'CalButton.dart';

//variables for our main class
String result="" ;
LinkedList<My_entry> calculatorStack=LinkedList();
final GlobalKey <StateText> my_key=GlobalKey<StateText>();
void main()=>runApp(CupertinoApp(
  home:CupertinoPageScaffold(
    child: Center(
      child:Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Flexible(
              flex:1,
              fit:FlexFit.tight,
              child : Container(
                color: Color.fromARGB(0, 0, 0, 0),
            ),
            ),
            Flexible(
              flex: 1,
              fit:FlexFit.tight,
              child: MyText( key:my_key), 
              ),
            
            Flexible(
              flex:2,
              fit:FlexFit.tight,
              child:GridView.builder(
              padding:  const EdgeInsets.all(1.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4),
              
            itemBuilder: (BuildContext context, int index) {
                return buildButton(index);

              },
              
              itemCount: 16,
              ) ,)
          ],
        ),
      ),
    ),
  ),
));


Widget buildButton(int index){
  
  return CalButton(
    buttonText: getButtonText(index),
    onPressed: () {
     if(index==13){
        calculatorStack.clear();
        updateText();
     } 
      else if(index!=15){
      String potential_string=getButtonText(index);
      if(addCalculator(potential_string)){
        calculatorStack.add(My_entry(potential_string));
        updateText();
      }
      }

      else{ // = has been pressed
        //check for the last char 
        String last_char=calculatorStack.last.my_entry;
        if(last_char=="+"|| last_char=="-"|| last_char=="/"||last_char=="x"){
          return;
        }
        numberizeStack();
        double calculation=calculate();
        if(double.parse(calculatorStack.last.my_entry).toInt()==double.parse(calculatorStack.last.my_entry)){
          calculatorStack.last.my_entry=double.parse(calculatorStack.last.my_entry).toInt().toString();
        }
        updateText();
      }

     } ,
   child:Center(child: Text(getButtonText(index)),),

  );
}

String getButtonText(int index){
  String text="";
switch (index) {
    case 3:
      text="+";
      break;
    case 7:
      text="-";
      break;
    case 11:
      text="/";
      break;
    case 15:
      text="=";
      break;
    case 14:
      text="x";
      break;
    case 13:
      text="C";
      break;
    case 12:
      text="0";
      break;
    default:
      int result_index;
      if(index<4){
        result_index=index+1;
      }
      else if(index<8){
        result_index=index;
      }
      else if(index<12){
        result_index=index-1;
      }
      else{
        result_index=index-2;
      }
      text=result_index.toString();
      break;
  }
  return text;
}

void updateText(){
  String big_string="";
  for(var entry in calculatorStack){
    big_string+=entry.my_entry;
  }
  my_key.currentState?.changeText(big_string);
}


void numberizeStack(){

  LinkedList<My_entry> new_list=LinkedList();
  String number="";

  for(int i=0;i<calculatorStack.length;i++){
    String string=calculatorStack.elementAt(i).my_entry;
    if(string=="+"||string=="/"||string=="x"||string=="-"){
      new_list.add(My_entry(number));
      new_list.add(My_entry(string));
      number="";

    }
    else if(calculatorStack.length-1==i){ //the last char
      number+=string;
      new_list.add(My_entry(number));
      number="";
    }
    else{ //the other possiblity if the consequent char is number
      number+=string; //add to the number
    }
  }

  calculatorStack=new_list;

}

double calculate(){
  
  //division and multiplication
    for(int i=0;i< calculatorStack.length;i++){
    String entry_string=calculatorStack.elementAt(i).my_entry;
    if(entry_string=="x"||entry_string=="/"){
        double element_1=double.parse(calculatorStack.elementAt(i-1).my_entry); //get element before operator
        double element_2=double.parse(calculatorStack.elementAt(i+1).my_entry); //get element after operator
        calculatorStack.elementAt(i-1).unlink(); //remove element before operator
        calculatorStack.elementAt(i).unlink(); //remove element after operator
        double result=0;
        if(entry_string=="x"){
          result=(element_1*element_2).toDouble();
        }
        else{
          result=(element_1/element_2).toDouble();
        }
        calculatorStack.elementAt(i-1).my_entry=result.toString();
        i=i-2; //fix i to remedy for removing 2 elements
    }
    if(calculatorStack.length==1){
      break;
    }
  }

  //calculate plus and minus 
  
  for(int i=0;i< calculatorStack.length;i++){
    String entry_string=calculatorStack.elementAt(i).my_entry;
    if(entry_string=="+"||entry_string=="-"){
        double element_1=double.parse(calculatorStack.elementAt(i-1).my_entry); //get element before operator
        double element_2=double.parse(calculatorStack.elementAt(i+1).my_entry); //get element after operator
        calculatorStack.elementAt(i-1).unlink(); //remove element before operator
        calculatorStack.elementAt(i).unlink(); //remove element after operator
        double result=0;
        if(entry_string=="+"){
          result=element_1+element_2.toDouble();
        }
        else{
          result=(element_1-element_2).toDouble();
        }
        calculatorStack.elementAt(i-1).my_entry=result.toString();
        i=i-2; //fix i to remedy for removing 2 elements
    }

    //check if the list is empty
    if(calculatorStack.length==1){
      break;
    }
  }
  return double.parse(calculatorStack.first.my_entry);
}
// a function to check if the element can be added to calculator stack (basically checks if there is no succesive + signs)
bool addCalculator(String string){

    if(calculatorStack.isEmpty){ //check for empty stack
      if(string=="+" || string=="-" || string =="/" || string=="x"){
        return false;
      }
      return true;
    }

    String last_string=calculatorStack.last.my_entry;
    if(last_string=="x" || last_string=="-" || last_string=="/" ||last_string=="+" ){
      if(string=="+" || string=="-" || string =="/" || string=="x"){
        return false;
      }
      return true;
    }
    return true;
}



base class My_entry extends LinkedListEntry<My_entry>{
  String my_entry; //entry string

  My_entry(this.my_entry);

}