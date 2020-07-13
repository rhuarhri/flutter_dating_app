import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterdatingapp/match_manager.dart';
import 'package:flutterdatingapp/message_handler.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import './color_scheme.dart';

class MessagesScreen extends StatelessWidget
{
  MatchInfo user = MatchInfo();

  MessagesScreen({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MessageBody(user);
  }

}

class MessageBody extends StatefulWidget
{
  MatchInfo user = MatchInfo();
  MessageBody(this.user);

  @override
  State<StatefulWidget> createState() {
    return _MessageBody(user);
  }

}

class _MessageBody extends State<MessageBody>
{
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController messageController = TextEditingController();

  MatchInfo user = MatchInfo();

  _MessageBody(this.user);

  List<Message> messages = [];

  MessageHandler messageHandler = MessageHandler();

  bool isSetupRequired = true;
  void setUp() async
  {
    messages = await messageHandler.getAllMessages(user.accountId);
    Stream<QuerySnapshot> messageListener = await messageHandler.listenForUpdates(user.accountId);
    messageListener.listen((event) {
      if (event == null)
        {
          print("event failed");
        }
      else
        {
          messages = messageHandler.getMessageFromFirestoreResult(user.accountId, event);
          setState(() {

          });
        }
    });
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {

    if(isSetupRequired == true)
      {
        setUp();
        isSetupRequired = false;
      }

    return Scaffold(
      key: scaffoldKey,
      body: messageBody(context),
      floatingActionButton: actionBTN(context),
    );
  }

  Widget messageBody(BuildContext context)
  {
    return
      CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: primary,

            expandedHeight: MediaQuery
                .of(context)
                .size
                .height * .40,
            //40% screen height

            flexibleSpace: FlexibleSpaceBar(
              background: userDescription(),
            ),
          ),
          SliverList(

              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index)
                {
                  if (messages[index].received == true)
                  {
                    return receivedMessage(messages[index].message);
                  }
                  else
                  {
                    return sentMessage(messages[index].message);
                  }
                },
                childCount: messages.length,

              )

          ),
        ],
      );
  }

  Widget receivedMessage(String message)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start, children: [
      Padding(padding: EdgeInsets.all(5.0), child:
      Container(color: primary, child:
      Padding(padding: EdgeInsets.all(5.0), child: Text(message),
      ),),
      )
    ],);

  }

  Widget sentMessage(String message)
  {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      Padding(padding: EdgeInsets.all(5.0), child:
      Container(color: Colors.white, child:
      Padding(padding: EdgeInsets.all(5.0), child:
      Text(message),)
        ,),)
    ],);
  }

  Widget userDescription()
  {

    return
      Container(
        child: Row(children: [
          CachedNetworkImage(
            imageUrl: user.image,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(MdiIcons.alertCircle),
            fit: BoxFit.contain,
          ),
          Expanded(child:
          Padding(padding: EdgeInsets.all(12.0), child:
          Container(child:
          Padding(padding: EdgeInsets.all(5.0), child:
          Column(
            children: [
              Flexible(child:
              Text(user.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),),
                  fit: FlexFit.tight,
                  flex: 1),
              Flexible(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Text(user.description),),
                fit: FlexFit.tight,
                flex: 4,
              )
            ],),
          ),
            color: Colors.white,
          ),
          ),
          )
        ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
      );
  }

  Widget footer(BuildContext context)
  {
    return
      Container(height: 80, child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(child: Container(child:
          TextField(
              controller: messageController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "message"
              )
          ),
            height: 50,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: primaryDark))
            ),
            margin: EdgeInsets.all(16.0),
          ),fit: FlexFit.loose, flex: 3,),
          Flexible(child: IconButton(icon:Icon(MdiIcons.arrowRight, color: secondaryDark,), onPressed: (){

            messageHandler.sendMessage(user.accountId, messageController.text, context);
            messageController.text = "";

            Navigator.pop(context);
          }),fit: FlexFit.loose, flex: 1,),
        ],), color: primary,);
  }

  Widget actionBTN(BuildContext context)
  {
    return FloatingActionButton(
      backgroundColor: secondary,
      child:Icon(MdiIcons.chat, color: Colors.white, size: 36,), onPressed: ()
    {
      _messageDisplay(context);
    },
    );
  }

  void _messageDisplay(BuildContext context)
  {
    scaffoldKey.currentState.showBottomSheet((context) => footer(context));

  }
}