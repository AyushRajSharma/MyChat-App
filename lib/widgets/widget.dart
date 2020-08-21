import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context){
  return AppBar(
    title: Row(
      children: <Widget>[
        Image.asset("assets/images/logo.png", height: 30.0,width: 35.0,),
        Text("Mychat App"),
      ],
    ),
  );
}

InputDecoration textInputDecoration(String hintText){
  return  InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      color: Colors.white54,

    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    enabledBorder: UnderlineInputBorder(

        borderSide: BorderSide(color: Colors.white)
    ),
  );
}

TextStyle simpleTextFieldStyle(){
  return TextStyle(
    color: Colors.tealAccent,
  );
}
TextStyle mediumTextStyle(){
  return TextStyle(
      color: Colors.white,
      fontSize: 20
  );
}