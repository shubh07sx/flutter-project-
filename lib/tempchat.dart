import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TempChat extends StatefulWidget {
  final FirebaseUser user;

  const TempChat({Key key, this.user}) : super(key: key);
  @override
  _TempChatState createState() => _TempChatState();
}

class _TempChatState extends State<TempChat> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();


  Future<void> callback() async {
    if (messageController.text.length > 0){
      await 
      _firestore.collection('messages').add({
        'text': messageController.text,
        'from': widget.user.email,
      });
      messageController.clear();
      scrollController.animateTo(
        scrollController.position.maxScrollExtent, 
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        leading: Hero(
          tag: "logo",
          child: Container(
            height: 40.0,
            child: Image.asset("assets/images/logo8final.png")
          ),
        ),
        title: Text("NB8F Chat"),
        actions: <Widget>[
         IconButton(
           icon: Icon(Icons.close),
           onPressed: () {
             Navigator.of(context).pop();
           },
         )
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('messages').snapshots(),
                builder: (context,snapshot){
                  if(!snapshot.hasData) 
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  List<DocumentSnapshot> docs = snapshot.data.documents;
                  List<Widget> messages = docs.map((doc) => 
                  Message(
                      from: doc.data['from'],
                      text: doc.data['text'],
                      me: widget.user.email == doc.data['from'],
                  )
                  ).toList();

                  return ListView(
                    controller: scrollController,
                    children: <Widget>[
                      ...messages,
                    ],
                  );  
                }
              )
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      // onSubmitted: (value) => callback(),
                      decoration: InputDecoration(
                        hintText: "Enter a Message......",
                        border: const OutlineInputBorder(),
                      ),
                      controller: messageController,
                    )
                  ),
                  SendButton(
                    text: "Send",
                    callback: callback,
                  )
                ],
              )
            )
          ],
        )
      ),
    );
  }
}

class SendButton extends StatelessWidget{
  final String text;
  final VoidCallback callback;

  const SendButton({Key key, this.text, this.callback}) : super(key: key);

  @override 
  Widget build(BuildContext context){
    return FlatButton(
      color: Colors.orange,
      onPressed: callback,
      child: Text(text),
    );
  }
  
}


class Message extends StatelessWidget {
  final String from;
  final String text;
  final bool me;
  const Message({Key key, this.from, this.text, this.me}) : super(key: key);

  
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: 
        me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            from
          ),
          Material(
            color: me ? Colors.teal : Colors.red,
            borderRadius: BorderRadius.circular(10.0),
            elevation: 6.0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 15.0 ),
              child: Text(
                text,
              ),
            )
          )
        ],
      )

    );
  }
}