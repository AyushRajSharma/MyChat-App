import 'package:chat_app/helper/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  TextEditingController phoneTextEditingController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
          Icon(
          Icons.account_circle),
            Text("User Profile")
          ],

          ),
        ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
                SizedBox(height: 16),
              Container(
                alignment: Alignment.topCenter,

                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage('assets/images/user.png'),
                ),

              ),
              SizedBox(height: 16),
              Container(
                alignment: Alignment.center,
                child: Text("${Constant.myName}", style: TextStyle(
                    color: Colors.teal,
                    fontSize: 32
                ),),
              ),
              SizedBox(height: 32),

              Card(
                  color: Colors.black12,
                  margin:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.email,
                      color: Colors.teal[900],
                    ),
                    title: Text(
                      "${Constant.myEmail}",
                      style:
                      TextStyle(fontFamily: '',
                          color: Colors.teal,
                          fontSize: 20.0),
                    ),
                  )),
              Card(
                  color: Colors.black12,
                  margin:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.phone_android,
                      color: Colors.teal[900],
                    ),
                    title: Text(
                      "${Constant.mobNo}",
                      style:
                      TextStyle(fontFamily: '',
                          color: Colors.teal,
                          fontSize: 20.0),
                    ),
                  )),



            ],
          ),
        ),
      ),


    );
  }
}
