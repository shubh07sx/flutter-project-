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
                 {'subcat': selected, 'name': user.displayName,'email': user.email,'photo': user.photoUrl,'uid': user.uid},
                
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
   final String username;
    final String email;
   final String photo;
    final String uid;
  NextPage({Key key, this.value, this.username, this.email, this.photo, this.uid}) : super(key: key);

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
                    onLongPress:() {
                      var route = new MaterialPageRoute(
                        builder: (BuildContext context) => new UserprofPage(val: document['subcat'],username: document['name'],email:document['email'],photo:document['photo'],uid: document['uid']),
                        
                      );
                      
                      Navigator.of(context).push(route);
                     
                    } ,

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
                 trailing: Icon(
                        Icons.chat,
                         color: Colors.blue,
                        ),
                  onTap: () {
                  Navigator.of(context).pushNamed('/chat');
                  //  FirebaseAuth.instance.currentUser().then((user){
                  //     Firestore.instance.collection('users').document(user.uid).collection('friends').add(
                  //       {
                  //         'friendname': document['name'],
                  //         'status': "Dont know",
                  //         'sendername': user.displayName,
                  //       }
                  //     );
                  //  });
                  //  print("added");
                  },
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

class UserprofPage extends StatefulWidget {
  final String val;
  final String username;
  final String email;
  final String photo;
  final String uid;
   UserprofPage({Key key, this.val,this.username,this.email,this.photo,this.uid}) : super(key: key);
  @override
  _UserprofPageState createState() => _UserprofPageState();
}

class _UserprofPageState extends State<UserprofPage> {
   var city = "...";
  var bio = "...";

  @override void initState() {
    super.initState();
    initUserState();
   
  }
  Future<void> initUserState() async {
    var user = await FirebaseAuth.instance.currentUser();
    var snap = await Firestore.instance.collection('city').document(widget.uid).get();
    var data = snap.data;
    var snap1 = await Firestore.instance.collection('bio').document(widget.uid).get();
    var data1 = snap1.data;
     setState(() {
       city = data['city'];
       bio = data1['bio'];
    });
  }
  var profpic = 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQL3964IjJHoLSLZ4iXOa9TPZcLzq7IKyFuzIXcaYlUwHg_61TV';
  @override
  Widget build(BuildContext context) {
  return Scaffold(
            backgroundColor: Colors.white,
            body: ListView(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 20.0,right:20.0,top:20.0),
                      child: Container(
                        height: 100.0,
                        width: 100.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(55.0),
                          image: DecorationImage(
                            image: NetworkImage(widget.photo??"https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQL3964IjJHoLSLZ4iXOa9TPZcLzq7IKyFuzIXcaYlUwHg_61TV"),
                            fit: BoxFit.cover
                          ),
                        ),
                      ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.0,right:20.0,top:20.0),
                        child: Text(
                         widget.username,
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0
                          )
                        )
                      ),
                      //  Padding(
                      //   padding: EdgeInsets.only(left: 20.0,right:20.0,top:20.0),
                      //   child: Text(
                      //     "San Franciso,CA",
                      //     style: TextStyle(
                      //       fontFamily: "Montserrat",
                      //       color: Colors.grey,
                      //       fontSize: 15.0
                      //     )
                      //   )
                      // ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.0,right:20.0,top:20.0),
                        child: Text(
                          widget.email,
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w300,
                            fontSize: 15.0
                          )
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.0,right: 20.0,top: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    "SanFrancisco, USA",
                                    style: TextStyle(
                                      fontFamily: "Montserrat",
                                      color: Colors.black87,
                                      fontSize: 15.0
                                  )
                                )
                              ],
                            ),
                            
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                   widget.val,
                                    style: TextStyle(
                                      fontFamily: "Montserrat",
                                      color: Colors.black87,
                                      fontSize: 15.0
                                  )
                                )
                              ],
                            ),
                          ],
                        )
                      ),
                      // SizedBox(height: 10.0,),
                      // Padding(
                      //   child: Center(
                      //   child: image == null
                      //       ? Text('Smash the Camera Button to Take a Picture')
                      //       : Image.file(image)),
                            
                      // ),
                      // SizedBox(height: 10.0),
                      // FloatingActionButton(
                      //     onPressed: getImage,
                      //     tooltip: 'Pick Image',
                      //     child: Icon(Icons.add_a_photo),
                      //   ),
                     
                      SizedBox(height: 220.0),
                      // Padding(
                      //   padding: EdgeInsets.only(left: 20.0,right:240.0,top:20.0),
                      //   child: AnimatedContainer(
                      //     duration: Duration(milliseconds: 1000),
                      //     height: 40.0,
                      //     width: 100.0,
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(20.0),
                      //       color: toggleValue ? Colors.greenAccent[100]: Colors.redAccent[100].withOpacity(0.5)
                      //     ),
                      //     child: Stack(
                      //       children: <Widget>[
                      //         AnimatedPositioned(
                      //           duration: Duration(milliseconds: 1000),
                      //           curve: Curves.easeIn,
                      //           top: 3.0,
                      //           left: toggleValue ? 60.0 : 0.0,
                      //           right: toggleValue ? 0.0 : 60.0,
                      //           child: InkWell(
                      //             onTap: toggleButton,
                      //             child: AnimatedSwitcher(
                      //               duration: Duration(milliseconds: 1000),
                      //               transitionBuilder: (Widget child,Animation<double> animation){
                      //                 return RotationTransition(
                      //                   child: child,
                      //                   turns: animation
                      //                 );
                      //               },
                      //               child: toggleValue ? Icon(Icons.check_circle,color: Colors.green,size: 35.0,
                      //               key: UniqueKey()
                      //               ) : Icon(Icons.remove_circle_outline,color: Colors.red,size: 35.0,
                      //               key: UniqueKey()
                      //               ) 
                      //             ),
                      //           )
                      //         )
                      //       ],
                      //     )
                      //   )
                      // ),
                    ],
                  )
                ],
            )
      );
  }
}

