import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'groups.dart';
import 'package:firebase_auth/firebase_auth.dart';
class MusicPage extends StatefulWidget {
  @override
  _MusicPageState createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  String selected;
  String temp;
  
  @override
  Widget build(BuildContext context) {
    print(temp);
    return Scaffold(
      appBar: AppBar(
       title: Text("Music Category",
        style:  TextStyle(
          color: Colors.white,
        ),
      )),
      
      body: temp==null ? radiobutton() : personlist(),
    );
  }
Widget radiobutton() {
  return Container(
     child: RadioButtonGroup(
          labels: <String>[
            "Vocal",
            "Beat",
            "Produce",
            "Instrument",
            "Compose",
            "Record",
            "Lyric",
            "Graphic Design",
            "Buisness",
          ],
           onSelected: (selected) {
             temp = selected;
             FirebaseAuth.instance.currentUser().then((user){
               Firestore.instance.collection('music').document(user.uid).setData(
                 {'subcat': selected, 'name': user.displayName,'email': user.email,},
                
               );
              print(temp);
             });
            
            // Navigator.of(context).pushReplacementNamed('/groups');
            print(temp);
           }
        ),
  );
}
Widget personlist(){
      return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('music').where("subcat",isEqualTo: temp).snapshots(),
      builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
        print(temp);
        if(snapshot.hasError)
        {
            return new Text("Error:${snapshot.error}");
        }
        switch(snapshot.connectionState){
          case ConnectionState.waiting: return new Text("Loading.....");
          default: 
            return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document){
                  return new ListTile(
                    title: new Text(document['name']),
                    subtitle: new Text(document['subcat']),
                  );
              }).toList(),
            );
        }
      }
    );

  }
}