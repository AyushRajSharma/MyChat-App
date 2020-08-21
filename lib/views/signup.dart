import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/chatRoomScreen.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isloading = false;
  DatabaseMethods databaseMethods = new DatabaseMethods();
  AuthMethods authMethods = new AuthMethods();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  TextEditingController usernameTextEditingController =
      new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  TextEditingController phoneTextEditingController =
      new TextEditingController();

  signMeUp() {

    //it is going to check validation
    if (formKey.currentState.validate()) {

      Map <String, String> userMapInfo = {
        "name" : usernameTextEditingController.text,
        "email" : emailTextEditingController.text,
        "phone" : phoneTextEditingController.text
      };
// called SharedPreference to save data
      HelperFunctions.saveUserNameSharedPreference(usernameTextEditingController.text);
      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);
      HelperFunctions.saveUserMobileNoSharedPreference(phoneTextEditingController.text);

      setState(() {
        isloading = true;
      });
      authMethods.signUpwithEmailAndPassword(emailTextEditingController.text,
          passwordTextEditingController.text).then((val) {
            //print("${val.uid}");
        databaseMethods.uploadUserInfo(userMapInfo);

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
      body: isloading ? Container(
        child: Center(child: CircularProgressIndicator())
      ) : SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 35),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                          validator:  (val) {
                           return val.isEmpty ? "please provide a valid username." : val.length < 4 ?
                            "username can't be of less than 6 charecter" :null;

                          },
                          controller: usernameTextEditingController,
                          style: simpleTextFieldStyle(),
                          decoration: textInputDecoration("Username")),
                      TextFormField(
                          validator: (val) {
                            //TODO make things to validate gmail, email
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
                          validator: (val) {
                            return val.length != 10
                                ? "please provide a valid dyhs mobile no":
                                null
                            ;
                          },
                          keyboardType: TextInputType.phone,
                          controller: phoneTextEditingController,
                          style: simpleTextFieldStyle(),
                          decoration: textInputDecoration("Contact No")),
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
                  height: 28.0,
                ),
                GestureDetector(
                  onTap: () {
                    signMeUp();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 60),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text("SignUp", style: mediumTextStyle()),
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
                  child: Text("SignUp with Google", style: mediumTextStyle()),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Already have an Account? ",
                      style: mediumTextStyle(),
                    ),
                    GestureDetector(
                      onTap: (){
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "SignIn",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              decoration: TextDecoration.underline),
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
