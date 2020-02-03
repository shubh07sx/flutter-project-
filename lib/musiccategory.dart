import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:usingfirestore_app/services/usermanagement.dart';
import 'groups.dart';
import 'package:firebase_auth/firebase_auth.dart';
class MusicPage extends StatefulWidget {
  @override
  _MusicPageState createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  
  String selected;
  String temp;
  UserManagement usermanagement = new UserManagement();

  @override
  Widget build(BuildContext context) {
    var _textController = new TextEditingController();
    return Scaffold(
      appBar: AppBar(
       title: Text("Music Category",
        style:  TextStyle(
          color: Colors.white,
        ),
      )),
      
      body:  radiobutton()  ,
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
              
             usermanagement.selectedcat(selected);
             FirebaseAuth.instance.currentUser().then((user){
               setState(() {
                 temp = selected;
               });
               Firestore.instance.collection('music').document(user.uid).setData(
                 {'subcat': selected, 'name': user.displayName,'email': user.email,'photo': user.photoUrl},
                
               );
            
             });
              var route = new MaterialPageRoute(
                  builder: (BuildContext context) =>
                      new NextPage(value: selected),
              );
              Navigator.of(context).push(route);
            // Navigator.of(context).pushReplacementNamed('/groups');
          
           }
        ),
  );
}

}
class NextPage extends StatefulWidget {
   final String value;

  NextPage({Key key, this.value}) : super(key: key);

  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: Text("Music Category List",
        style: TextStyle(
          color: Colors.white,
          fontStyle: FontStyle.italic,
        )
        ),
      ),
      body: _PersonList(),
    );
    
  }
  Widget _PersonList(){
  var profpic = 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQL3964IjJHoLSLZ4iXOa9TPZcLzq7IKyFuzIXcaYlUwHg_61TV';
   return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('music').where("subcat",isEqualTo: widget.value).snapshots(),
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
                  
                    return new  ListTile(
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
                    //  trailing: Icon(
                    //     Icons.person_add,
                    //      color: Colors.blue,
                    //     ),
                      leading: new CircleAvatar(
                     radius: 30.0,
                     backgroundColor: Colors.transparent,
                     backgroundImage:
                        NetworkImage(document['photo']??profpic),
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
