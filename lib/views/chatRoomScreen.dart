import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/conversation_screen.dart';
import 'package:chat_app/views/search.dart';
import 'package:chat_app/views/userProfile.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Stream chatRoomStream;

  Widget chatRoomList(){
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
              return ChatRoomTile(
                snapshot.data.documents[index].data["ChatRoomId"]
                    .toString().replaceAll("_", "")
                    .replaceAll(Constant.myName, ""),
                  snapshot.data.documents[index].data["ChatRoomId"]
              );
            }): Container();
      },
    );
  }

  @override
  void initState() {
    getUserIno();

    super.initState();
  }
  getUserIno()async{
    Constant.myName = await HelperFunctions.getUserNameSharedPreference();
    Constant.myEmail = await HelperFunctions.getUserEmailSharedPreference();
    Constant.mobNo = await HelperFunctions.getUserMobileNoSharedPreference();
    databaseMethods.getChatRoom(Constant.myName).then((val){
      setState(() {
        chatRoomStream = val;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/images/logo.png", height: 30.0,width: 35.0,),
        flexibleSpace: FlexibleSpaceBar(
          title: Text("Mychat App"),
        ),
        actions:[
          GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => UserProfile()
                ));
              },

              child: Container(
                  padding: EdgeInsets.all(20),
                  child: Icon(Icons.account_circle))),
          GestureDetector(
            onTap: (){

              HelperFunctions.saveUserLoggedInSharedPreference(false);
              authMethods.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => Authenticate()
              ));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => SearchScreen()
          ));
      },),
    );
  }
}
class ChatRoomTile extends StatelessWidget {
  final String username;
  final String chatRoomId;
  ChatRoomTile(this.username, this.chatRoomId);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ConversationScreen(chatRoomId)
        ));
      },
      child: Container(
        color: Colors.black38,
        margin: EdgeInsets.symmetric(vertical: 3),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16 ),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40)
              ),
              child: Text("${username.substring(0,1).toUpperCase()}",style : mediumTextStyle()),
            ),
            SizedBox(width: 8,),
            Text(username, style : mediumTextStyle())
          ],
        ),
      ),
    );
  }
}
