

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'services/usermanagement.dart';
import 'profilepage.dart';

// class DashboardPage extends StatelessWidget {
//   const DashboardPage({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Center(
//         child: Text('Dashboard Page'),
//       )
//     );
//   }
// }
class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}




class _DashboardPageState extends State<DashboardPage> {
  UserManagement usermanagement = new UserManagement();

  var displayname = "Tom";
  var proffesionName = '...';
  var bio = "...";
  var city = '...';
  var profpic = 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQL3964IjJHoLSLZ4iXOa9TPZcLzq7IKyFuzIXcaYlUwHg_61TV';
  bool newtoggleValue = false;
  // var user = FirebaseAuth.instance.currentUser();
  // var newdisplayName;
  // var newprofpic;
   
  @override initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) async {
      setState(() {
          displayname = user.displayName;
       
      });
      initUserData();
    }).catchError((e){
      print(e);
    });
   
  }
  Future<void> initUserData() async {

    // FirebaseAuth.instance.currentUser().then((user) async {
    //   var snap = await Firestore.instance.collection('users').document(user.uid).get();
    //   proffesionName = snap.data['proffesion'].toString();
    // }).catchError((e){
    //   print(e);
    // });

    var user = await FirebaseAuth.instance.currentUser();
    // profilePicUrl = user.photoUrl;
    // nickName = user.displayName;
    var snap =
        await Firestore.instance.collection('users').document(user.uid).get();
    var data = snap.data;
    var snap1 = await Firestore.instance.collection('bio').document(user.uid).get();
    var data1 = snap1.data;
    var snap2 = await Firestore.instance.collection('city').document(user.uid).get();
    var data2 = snap2.data;
    var snap3 = await Firestore.instance.collection('available').document(user.uid).get();
    var data3 = snap3.data; 
    setState(() {
      proffesionName = data['proffesion'];
      bio = data1['bio'];
      city = data2['city'];
      newtoggleValue = data3['value'];
    });
   
  }
  // File image;
  // Future getImage() async {
  //   File picture = await ImagePicker.pickImage(
  //       source: ImageSource.camera, maxWidth: 300.0, maxHeight: 500.0);
  //   setState(() {
  //     image = picture;
  //   });
  // }
  // bool toggleValue = false;
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
                            image: NetworkImage(profpic),
                            fit: BoxFit.cover
                          ),
                        ),
                      ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.0,right:20.0,top:20.0),
                        child: Text(
                         displayname??'default value',
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
                           bio??"Lorem Ipsum bio of the user to be displayed....",
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
                                    city??"San Franciso,USA",
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
                                    proffesionName??"default value",
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
                      Padding(
                        padding: EdgeInsets.only(left: 20.0,right:240.0,top:20.0),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 1000),
                          height: 40.0,
                          width: 100.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: newtoggleValue ? Colors.greenAccent[100]: Colors.redAccent[100].withOpacity(0.5)
                          ),
                          child: Stack(
                            children: <Widget>[
                              AnimatedPositioned(
                                duration: Duration(milliseconds: 1000),
                                curve: Curves.easeIn,
                                top: 3.0,
                                left: newtoggleValue ? 60.0 : 0.0,
                                right: newtoggleValue ? 0.0 : 60.0,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      newtoggleValue = !newtoggleValue;
                                      FirebaseAuth.instance.currentUser().then((user){
                                        Firestore.instance.collection('available').document(user.uid).setData(
                                          {"value": newtoggleValue,'user': user.displayName}
                                        ).catchError((e){
                                          print(e);
                                        });
                                      });
                                    });
                                  },
                                  child: AnimatedSwitcher(
                                    duration: Duration(milliseconds: 1000),
                                    transitionBuilder: (Widget child,Animation<double> animation){
                                      return RotationTransition(
                                        child: child,
                                        turns: animation
                                      );
                                    },
                                    child: newtoggleValue ? Icon(Icons.check_circle,color: Colors.green,size: 35.0,
                                    key: UniqueKey()
                                    ) : Icon(Icons.remove_circle_outline,color: Colors.red,size: 35.0,
                                    key: UniqueKey()
                                    ) 
                                  ),
                                )
                              )
                            ],
                          )
                        )
                      ),
                    ],
                  )
                ],
            )
      );
  }
  // toggleButton() {
    
  //   setState(() {
  //     toggleValue = !toggleValue;
      
  //   //   FirebaseAuth.instance.currentUser().then((user){
  //   //   displayname = user.displayName;
  //   //   profpic = user.photoUrl;

  //   //   print(displayname);
  //   //   print(profpic);
  //   // }).catchError((e){
  //   //   print(e);
  //   // });
  //   //   print(displayname);
  //   });
  // }
}