import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterdatingapp/common_widgets.dart';
import 'package:flutterdatingapp/database_management_code/database.dart';
import 'package:flutterdatingapp/database_management_code/internal/DataModels.dart';

class Message
{
  String message;
  bool received;
}

class MessageHandler
{

  void setup() async
  {
    DBProvider.db.setupMessages();
  }

  final databaseReference = Firestore.instance;
  void sendMessage(String sendTo, String message, BuildContext context) async
  {

    if (await DBProvider.db.canSendMessage() == true)
      {
        UserInfo user = await DBProvider.db.getUser();
        String userId = user.onlineLocation;

        //record message for user
        _recordMessage(userId, sendTo, userId, message);

        //record message for receiver
        _recordMessage(sendTo, sendTo, userId, message);
      }
    else
      {
        popup("Did not send",
            "You need to earn messages before you can send them. You can do this on the chat screen.",
            context, null);
      }

  }

  void _recordMessage(String id, String toId, String fromId, String message)
  {
    databaseReference.collection("users").document(id).collection("messages").add({
      "to":[toId],
      "from":[fromId],
      "message":message,
      "time": Timestamp.now(),
    });
  }

  Future<List<Message>> getAllMessages(String talkingToId) async
  {
    List<Message> result = [];

    UserInfo user = await DBProvider.db.getUser();
    String userId = user.onlineLocation;

    QuerySnapshot foundData = await databaseReference.collection("users").document(userId).collection("messages")
    .where("from", arrayContainsAny: [userId, talkingToId])
    .orderBy("time", descending: false).getDocuments();

    print("Messages number is " + foundData.documents.length.toString());

    result = getMessageFromFirestoreResult(talkingToId, foundData);

    return result;
  }

  Future<Stream<QuerySnapshot>> listenForUpdates(String talkingToId) async
  {
    UserInfo user = await DBProvider.db.getUser();
    String userId = user.onlineLocation;

    return databaseReference.collection("users").document(userId).collection("messages")
        .where("from", arrayContainsAny: [userId, talkingToId]).orderBy("time", descending: false)
        .snapshots();
  }

  List<Message> getMessageFromFirestoreResult(String talkingToId, QuerySnapshot data)
  {
    List<Message> result = [];

    data.documents.forEach((element) {
      Message foundMessage = Message();
      foundMessage.received = element.data["from"][0] == talkingToId ? true : false;
      foundMessage.message = element.data["message"].toString();
      if (foundMessage.received == true)
      {
        print(foundMessage.message + " is received");
      }
      else
      {
        print(foundMessage.message + " is sent");
      }
      result.add(foundMessage);
    });

    return result;

  }

}