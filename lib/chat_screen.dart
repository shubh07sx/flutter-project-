import 'package:flutter/material.dart';
import 'chatmessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String username;
  // void initState() async{
  //   super.initState();
  //   FirebaseUser user = await FirebaseAuth.instance.currentUser();
  //   username = user.displayName;
  //   print(username);
  // }
  
  final TextEditingController _textController = new TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage> [];

  void _handleSubmitted(String text){
    
    _textController.clear();
    ChatMessage message = new ChatMessage(
      text: text,
    );
    setState(() {
      _messages.insert(0,message);
    });
  } 

  Widget _textComposerWidget() {
    return IconTheme(
      data: new IconThemeData(
        color: Colors.blue,
      ),
        child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                decoration: new InputDecoration.collapsed(
                  hintText: "Send a message"
                ),
                controller: _textController,
                onSubmitted: _handleSubmitted,
              ),
            ),
            new Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () {
                  _handleSubmitted(_textController.text);
                },
              )
            )
          ],
        )
      ),
    );
  }

  
  @override
  Widget build(BuildContext context) {
    return new Column(
        children: <Widget>[
          new Flexible(
            child: new ListView.builder(
              padding: new EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_,int index) => _messages[index],
              itemCount: _messages.length,
            )
          ),
          new Divider(height: 1.0,),
          new Container(
            decoration: new BoxDecoration(
              color: Theme.of(context).cardColor,
              
            ),
            child: _textComposerWidget(),
          )
        ],
      );
  }
}