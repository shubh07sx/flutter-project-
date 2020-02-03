import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class FashionPage extends StatefulWidget {
  @override
  _FashionPageState createState() => _FashionPageState();
}

class _FashionPageState extends State<FashionPage> {
  String selected;
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
         onSelected: (selected) {
           FirebaseAuth.instance.currentUser().then((user){
             Firestore.instance.collection('fashion').document(user.uid).setData(
               {'subcat': selected , 'name': user.displayName,'email': user.email,'photo': user.photoUrl}
             );
           });
           var route = new MaterialPageRoute(
                  builder: (BuildContext context) =>
                      new NextfashPage(value: selected),
            );
            Navigator.of(context).push(route);
         }
      )
    );
  }
}
class NextfashPage extends StatefulWidget {
  final String value;

  NextfashPage({Key key, this.value}) : super(key: key);
  @override
  _NextfashPageState createState() => _NextfashPageState();
}

class _NextfashPageState extends State<NextfashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Colors.black12,
        title: Text("Fashion Category List",
        style: TextStyle(
          color: Colors.white,
          fontStyle: FontStyle.italic,
        )
        ),
      ),
      body: _FashionList(),
    );
  }

  Widget _FashionList(){
    var profpic = 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQL3964IjJHoLSLZ4iXOa9TPZcLzq7IKyFuzIXcaYlUwHg_61TV';
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('fashion').where("subcat",isEqualTo: widget.value).snapshots(),
      builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
        // print(temp);
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
                    title: new Text(document['name'],
                    style: new TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18.9,
                      ),
                    ),
                    subtitle: new Text("Field:- ${document['subcat']},Email:-${document['email']}",
                    style: new TextStyle(
                          color: Colors.lightBlueAccent,
                          fontSize: 13.4,
                          fontStyle: FontStyle.italic,
                     )
                    ),
                      leading: new CircleAvatar(
                     radius: 30.0,
                     backgroundColor: Colors.transparent,
                     backgroundImage:
                        NetworkImage(document['photo']??profpic),
                ),
                  trailing: Icon(
                        Icons.person_add,
                         color: Colors.blue,
                        ),
                );
                Expanded(
                  child: Divider(),
                );
              }).toList(),
            );
        }
      }
    );
  }
}