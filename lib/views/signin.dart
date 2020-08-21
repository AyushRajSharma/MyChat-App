import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chatRoomScreen.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  AuthMethods authMethods = new AuthMethods();
  final formKey = GlobalKey<FormState>();


  TextEditingController emailTextEditingController =
  new TextEditingController();
  TextEditingController passwordTextEditingController =
  new TextEditingController();
  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;



  signMeIn(){

    if (formKey.currentState.validate()){
      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);

      setState(() {
        isLoading = true;

      });

      databaseMethods
          .getUserByUserEmail(emailTextEditingController.text).then((val){
            snapshotUserInfo =val;
            HelperFunctions.saveUserNameSharedPreference(snapshotUserInfo.documents[0].data["name"]);
            HelperFunctions.saveUserMobileNoSharedPreference(snapshotUserInfo.documents[1].data["phone"]);
      });
      authMethods.signInWithEmailAndPassword(emailTextEditingController.text,
          passwordTextEditingController.text).then((val) {

        if (val != null){
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => ChatRoom()
          ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height -50,
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 35),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Form(
                    key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                          validator: (val) {
                            //TODO make things to varify gmail, email
                            return RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(val)
                                ? null
                                : "please provide a valid email.";
                          },
                          controller: emailTextEditingController,
                          style: simpleTextFieldStyle(),
                          decoration: textInputDecoration("Email")),
                      TextFormField(
                          obscureText: true,
                          validator: (val) {
                            return val.length < 6
                                ? "password can't be less than 6 char"
                                : null;
                          },
                          controller: passwordTextEditingController,
                          style: simpleTextFieldStyle(),
                          decoration: textInputDecoration("Password")),
                    ],
                  ),
                ),
                SizedBox(
                  height: 12.0,
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Container(
                    child:
                        Text("Forgot Password?", style: TextStyle(
                          color: Colors.tealAccent,
                          fontSize: 17.0,
                          decoration: TextDecoration.underline
                        ),),
                  ),
                ),
                SizedBox(
                  height: 12.0,
                ),
                Container(
                  child: GestureDetector(
                    onTap: (){
                      signMeIn();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical:18, horizontal: 60),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xff007EF4),
                            const Color(0xff2A75BC)

                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text("Sign In", style:mediumTextStyle()),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 60),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text("Sign with Google", style: mediumTextStyle()),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Don't have an account? ", style: mediumTextStyle(),),
                    GestureDetector(
                      onTap: (){
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text("Register Here ", style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            decoration: TextDecoration.underline
                        ),
                          
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 35.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
