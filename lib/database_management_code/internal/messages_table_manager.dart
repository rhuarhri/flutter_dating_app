import 'package:sqflite/sqflite.dart';
import './DataModels.dart';

class GetFromMessages
{
  Future<int> getCurrentMessageAmount(Database db) async
  {
    int messageAmount = 0;

    Messages foundMessages = await getAll(db);

    messageAmount = foundMessages.messageAmount;

    return messageAmount;
  }

  Future<bool> canSendMessage(Database db) async
  {
    bool canSend = false;

    Messages foundMessages = await getAll(db);

    if (foundMessages.messageAmount <= 0 || foundMessages.messageAmount == null)
      {
        canSend = false;
      }
    else
      {
        canSend = true;
      }

    return canSend;
  }

  Future<Messages> getAll(Database db) async
  {
    Messages foundMessages = Messages();

    var res = await db.query("Messages");
    if (res.isNotEmpty == true)
      {
        foundMessages = Messages.fromMap(res[0]);
      }

    return foundMessages;
  }
}

class UpdateToMessages
{
  void oneMessageSent(Database db) async
  {
    Messages foundMessage = await GetFromMessages().getAll(db);

    foundMessage.messageAmount = (foundMessage.messageAmount - 1);

    db.update("Messages", foundMessage.toMap(), where: "id = ?", whereArgs: [foundMessage.id]);
  }

  void addMessages(Database db, int addingMessagesAmount) async
  {
    Messages foundMessage = await GetFromMessages().getAll(db);

    foundMessage.messageAmount = (foundMessage.messageAmount + addingMessagesAmount);

    db.update("Messages", foundMessage.toMap(), where: "id = ?", whereArgs: [foundMessage.id]);
  }

}

class AddToMessages
{
  //The update of messages the user get when they install the app.
  int _startMessageAmount = 100;

   void addNewMessagesValue(Database db) async
   {
     Messages foundMessage = await GetFromMessages().getAll(db);

     if (foundMessage.messageAmount == null) {
       Messages newMessageAmountValue = Messages();
       newMessageAmountValue.messageAmount = _startMessageAmount;

       db.insert("Messages", newMessageAmountValue.toMap());
     }
   }

}