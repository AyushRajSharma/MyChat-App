import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{

  getUserByUsername(String username) async{
      return await Firestore.instance.collection("users")
          .where("name",isEqualTo: username)
          .getDocuments();
  }
  getUserByUserEmail(String userEmail) async{
      return await Firestore.instance.collection("users")
          .where("email",isEqualTo: userEmail)
          .getDocuments();
  }
  uploadUserInfo(userMap){
    Firestore.instance.collection("users")
        .add(userMap).catchError((e){
          print(e.toString());
    });
  }

  createChatRoom(String chatRoomId, chatRoomMap){
    Firestore.instance.collection("ChatRoom")
    .document(chatRoomId).setData(chatRoomMap).catchError((e){
      print(e.toString());
    });
  }
  // to add conversation messages

  addCoversationMessages(String chatRoomId, messageMap){
    Firestore.instance.collection("ChatRoom")
        .document(chatRoomId)
        .collection("Chats")
        .add(messageMap).catchError((e){
      print(e.toString());
    });
  }

  // get messages

  getCoversationMessages(String chatRoomId)async{
      return   Firestore.instance.collection("ChatRoom")
        .document(chatRoomId)
        .collection("Chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  getChatRoom(String username)async{
    return  Firestore.instance.collection("ChatRoom")
        .where("users", arrayContains: username)
        .snapshots();
  }

}


