import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class FashionPage extends StatefulWidget {
  @override
  _FashionPageState createState() => _FashionPageState();
}

class _FashionPageState extends State<FashionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: Text("Fashion Category",
        style:  TextStyle(
          color: Colors.white,
        ),
      )),
      
      body: RadioButtonGroup(
        labels: <String>[
          "Design",
          "Style",
          "Textile",
          "Model",
          "Photograph",
          "Tailor",
          "Make Up",
          "Graphic Design",
          "Buisness"
        ],
         onSelected: (String selected) {
           FirebaseAuth.instance.currentUser().then((user){
             Firestore.instance.collection('users').document(user.uid).collection('fashion').document(user.uid).setData(
               {'subcat': selected, 'useruid': user.uid}
             );
           });
         }
      )
    );
  }
}