import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/conversation_screen.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingcontroller = new TextEditingController();

  QuerySnapshot searchSnapshot;
  initiateSearch(){
    databaseMethods.getUserByUsername(searchTextEditingcontroller.text)
        .then((val){
      setState(() {
        searchSnapshot = val;
      });
    });
  }
  Widget searchList(){
    return (searchSnapshot != null) ? ListView.builder(
        itemCount: searchSnapshot.documents.length,
        shrinkWrap: true,
        itemBuilder: (context, index){
          return searchTile(
              userName: searchSnapshot.documents[index].data["name"],
              userEmail:  searchSnapshot.documents[index].data["email"]
          );
        }): Container();
  }

  /// creating a chatRoom, and send user to conversation Screen(when he click on message)
  createChatRoomAndStartConversation(String username){
    // call to get unique ChatRoomId
    String chatRoomId = getChatRoomId(username, Constant.myName);
    //create a list of users
    List<String>users = [username, Constant.myName ];
    Map<String, dynamic> chatRoomMap = {
      "users" : users,
      "ChatRoomId": chatRoomId
    };
    databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => ConversationScreen(chatRoomId)
    ));

  }


  Widget searchTile({String userName, String userEmail}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 16),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(userName, style: simpleTextFieldStyle(),),
              Text(userEmail, style: simpleTextFieldStyle(),)
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatRoomAndStartConversation(userName);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30)
              ),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Text("Message", style: mediumTextStyle(),),
            ),
          )
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.black38,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              child: Row(

               children: <Widget>[
                 Expanded(

                   child: TextField(
                        style: TextStyle(
                          color: Colors.white
                        ),
                     controller: searchTextEditingcontroller,
                      decoration: InputDecoration(
                        hintText: "Seach Username ...",
                        hintStyle: TextStyle(
                          color: Colors.white54,
                        ),
                            border: InputBorder.none
                      ),
                   ),
                 ),
                 GestureDetector(
                   onTap: (){
                     initiateSearch();
                   },
                   child: Container(
                       height: 40,
                       width:  40,
                       decoration: BoxDecoration(
                         gradient: LinearGradient(
                           colors: [
                             const Color(0x36FFFFFF),
                             const Color(0x0FFFFFFF)
                           ]
                         ),
                         borderRadius: BorderRadius.circular(40)
                       ),
                       padding: EdgeInsets.all(11),
                       child: Image.asset("assets/images/1.png")),
                 ),
               ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}



getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}