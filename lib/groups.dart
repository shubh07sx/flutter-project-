import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'musiccategory.dart';

class GroupsPage extends StatefulWidget {
  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Person List",
        style: TextStyle(
          color: Colors.white
        )
        )
      ),
      body: _personList(),
    );
  
  }
  Widget _personList(){
      return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('music').where("subcat",isEqualTo: "Graphic Designer").snapshots(),
      builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
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

