import 'package:flutter/material.dart';
import 'chat_screen.dart';
class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Chat Page")
      ),
      body: new ChatScreen()
    );

  }
}