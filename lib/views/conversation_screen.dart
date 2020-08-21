import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  ConversationScreen(this.chatRoomId);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageTextEditingController = new TextEditingController();
  Stream chatMessageStream;

  Widget chatMessageList(){
    return StreamBuilder(
        stream: chatMessageStream,
        builder: (context, snapshot){
          return snapshot.hasData ? ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index){
            return MessageTile(snapshot.data.documents[index].data["message"],
                snapshot.data.documents[index].data["sendBy"] == Constant.myName);
          }): Container();

    });
  }

  sendMessage(){
    if(messageTextEditingController.text.isNotEmpty){
      Map <String, dynamic> messageMap ={
        "message" : messageTextEditingController.text,
        "sendBy": Constant.myName,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addCoversationMessages(widget.chatRoomId, messageMap);
      messageTextEditingController.text = "";
    }
  }
  @override
  void initState() {
      databaseMethods.getCoversationMessages(widget.chatRoomId).then(
          (val){
            setState(() {
              chatMessageStream = val;
            });
          }
      );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Image.asset("assets/images/logo.png", height: 30.0,width: 35.0,),
            Text("${widget.chatRoomId.toString().replaceAll("_", "")
                .replaceAll(Constant.myName, "")}")
          ],
        ),

      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
                alignment: Alignment.topCenter,
                child: chatMessageList()),
            Container(child: SizedBox(height: 70000.0,)),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.black38,
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                child: Row(

                  children: <Widget>[
                    Expanded(

                      child: TextField(
                        style: TextStyle(
                            color: Colors.white
                        ),
                        controller: messageTextEditingController,
                        decoration: InputDecoration(
                            hintText: "Message type here ...",
                            hintStyle: TextStyle(
                              color: Colors.white54,
                            ),
                            border: InputBorder.none
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        sendMessage();
                        },
                      child: Container(
                          height: 47,
                          width:  47,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    const Color(0x36FFFFFF),
                                    const Color(0x0FFFFFFF)
                                  ]
                              ),
                              borderRadius: BorderRadius.circular(48)
                          ),
                          padding: EdgeInsets.all(8),
                          child: Image.asset("assets/images/icons.png")),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile(this.message, this.isSendByMe);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(left: isSendByMe ? 0:26, right: isSendByMe ? 20:0),
        margin: EdgeInsets.symmetric(vertical: 8),
        width: MediaQuery.of(context).size.width,
        alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 26, vertical: 15),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isSendByMe ?  [
                const Color(0xff007EF4),
                const Color(0xff2A75BC)
              ]
                  : [
                const Color(0x1AFFFFFF),
                const Color(0x1AFFFFFF)
              ],

            ),
                borderRadius: isSendByMe ? BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomLeft: Radius.circular(23)
          ) : BorderRadius.only(
               topLeft: Radius.circular(23),
               topRight: Radius.circular(23),
               bottomLeft: Radius.circular(23)
      )
          ),
          child: Text(message,style: TextStyle(
              color: Colors.white,
              fontSize: 20
          )),
        ),
      ),
    );
  }
}
