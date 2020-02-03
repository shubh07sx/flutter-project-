import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'services/usermanagement.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => new _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var profilePicUrl =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQL3964IjJHoLSLZ4iXOa9TPZcLzq7IKyFuzIXcaYlUwHg_61TV';

  var nickName = 'Tom';

  var proffesionName = 'Actor';
  bool isLoading = false;
  var proff;

  File selectedImage;

  UserManagement userManagement = new UserManagement();

  String newNickName;
  String newProffesion;

  void initState() {
    super.initState();
    // setState(() {
    //    initUserData();
    // });
   
    FirebaseAuth.instance.currentUser().then((user) async {
      //  var snap = await Firestore.instance.collection('users').document(user.uid).get();
      setState((){
        profilePicUrl = user.photoUrl;
        nickName = user.displayName;
        // proffesionName = snap.data['proffesion'].toString();
      });
      initUserData();
    }).catchError((e) {
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
    setState(() {
      proffesionName = data['proffesion'];
    });
  }

  Future selectPhoto() async {
    setState(() {
      isLoading = true;
    });
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = tempImage;
      uploadImage();
    });
  }

  Future uploadImage() async {
    var randomno = Random(25);
    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('profilepics/${randomno.nextInt(5000).toString()}.jpg');
    StorageUploadTask task = firebaseStorageRef.putFile(selectedImage);
    StorageTaskSnapshot snapshottask = await task.onComplete;
    String downloadUrl = await snapshottask.ref.getDownloadURL();
    if (downloadUrl != null) {
      setState(() {
        userManagement.updateProfilePic(downloadUrl.toString()).then((val) {
          setState(() {
            profilePicUrl = val.downloadUrl.toString();
            isLoading = false;
          });
        }).catchError((e) {
          print(e);
        });
      });
      // userManagement.updateProfilePic(downloadUrl.toString()).then((val){
      //    setState(() {
      //       profilePicUrl = val.downloadUrl.toString();
      //       isLoading = false;
      //     });
      // }).catchError((e){
      //   print(e);
      // });
    }
  }

  Future<bool> editName(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit Nick Name', style: TextStyle(fontSize: 15.0)),
            content: Container(
              height: 100.0,
              width: 100.0,
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                        labelText: 'New Name',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold)),
                    onChanged: (value) {
                      newNickName = value;
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Update'),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    isLoading = true;
                  });
                  userManagement.updateNickName(newNickName).then((onValue) {
                    setState(() {
                      isLoading = false;
                      nickName = newNickName;
                    });
                  }).catchError((e) {
                    print(e);
                  });
                },
              )
            ],
          );
        });
  }

  Future<bool> dialogTrigger(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Job Done', style: TextStyle(fontSize: 15.0)),
            content: Text('Added'),
            actions: <Widget>[
              FlatButton(
                child: Text('Alright'),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Future<bool> editProffesion(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title:
                Text('Edit Proffesion Name', style: TextStyle(fontSize: 15.0)),
            content: Container(
              height: 100.0,
              width: 100.0,
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                        labelText: 'New Proffesion',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold)),
                    onChanged: (value) {
                      newProffesion = value;
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Update'),
                textColor: Colors.blue,
                onPressed: () async {
                  Navigator.of(context).pop();
                  setState(() {
                    isLoading = true;
                  });
                  
                  FirebaseAuth.instance.currentUser().then((user) async {
                    userManagement.updateUserData(newProffesion);
                    var snap = await Firestore.instance.collection('users').document(user.uid).get();
                    setState(() {
                      isLoading = false;
                      proffesionName = snap.data['proffesion'].toString();
                      // Firestore.instance.collection('users').document(user.uid).get();
                    });
                    // print(snap);
                    // print(snap.data);
                    
                 }).catchError((e){
                    print(e);
                  });


                  // var user = await FirebaseAuth.instance.currentUser();
                  //  userManagement.updateUserData(newProffesion);

                  // var snap = await Firestore.instance
                  //     .collection('users')
                  //     .document(user.uid)
                  //     .get();
                  // print(snap);
                  // print(snap.data);
                  // print(snap.data['proffesion'].toString());
                  // setState(() {
                  //   proffesionName = snap.data['proffesion'].toString();
                  //   isLoading = false;
                  // });

                  // FirebaseAuth.instance.currentUser().then((user){
                  //   // Map<String,dynamic> proffesion = {'proffesion': this.newProffesion,'uid':user.uid};
                  //   Firestore.instance.collection('users').document(user.uid).setData({
                  //     'proffesion': this.newProffesion,
                  //     'uid': user.uid
                  //   });

                  // }).catchError((e){
                  //   print(e);
                  // });

                  // Firestore.instance.collection('/users/proffesion').add(proffesion).catchError((e){
                  //     print(e);
                  //   });
                },
              )
            ],
          );
        });
  }

  getLoader() {
    return isLoading
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator(),
            ],
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // backgroundColor:Colors.black87,
        body: new Stack(
        
      children: <Widget>[
        ClipPath(
          child: Container(color: Colors.black.withOpacity(0.8)),
          clipper: getClipper(),
        ),
        Positioned(
          
            width: 350.0,
            top: MediaQuery.of(context).size.height / 5,
            child: Column(
              children: <Widget>[
                Container(
                     
                    width: 150.0,
                    height: 150.0,
                    decoration: BoxDecoration(
          
                        color: Colors.red,
                        image: DecorationImage(
                            image: NetworkImage(profilePicUrl),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.all(Radius.circular(75.0)),
                        boxShadow: [
                          BoxShadow(blurRadius: 7.0, color: Colors.black)
                        ])),
                SizedBox(height: 20.0),
                getLoader(),
                SizedBox(height: 65.0),
                Text(
                  nickName??'default name',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 15.0),
                Text(
                  proffesionName ?? 'default value',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 17.0,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 25.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                        height: 30.0,
                        width: 110.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.blueAccent,
                          color: Colors.black12,
                          elevation: 7.0,
                          child: GestureDetector(
                            onTap: selectPhoto,
                            child: Center(
                              child: Text(
                                'Edit Photo',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Montserrat'),
                              ),
                            ),
                          ),
                        )),
                    Container(
                        height: 30.0,
                        width: 110.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.blueAccent,
                          color: Colors.black12,
                          elevation: 7.0,
                          child: GestureDetector(
                            onTap: () {
                              editProffesion(context);
                            },
                            child: Center(
                              child: Text(
                                'Edit Proffesion',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Montserrat'),
                              ),
                            ),
                          ),
                        )),
                    // Container(
                    //     height: 30.0,
                    //     width: 65.0,
                    //     child: Material(
                    //       borderRadius: BorderRadius.circular(20.0),
                    //       shadowColor: Colors.greenAccent,
                    //       color: Colors.green,
                    //       elevation: 7.0,
                    //       child: GestureDetector(
                    //         onTap: () {
                    //           editName(context);
                    //         },
                    //         child: Center(
                    //           child: Text(
                    //             'Edit Name',
                    //             style: TextStyle(
                    //                 color: Colors.white,
                    //                 fontFamily: 'Montserrat'),
                    //           ),
                    //         ),
                    //       ),
                    //     )),
                    // Container(
                    //     height: 30.0,
                    //     width: 65.0,
                    //     child: Material(
                    //       borderRadius: BorderRadius.circular(20.0),
                    //       shadowColor: Colors.redAccent,
                    //       color: Colors.red,
                    //       elevation: 7.0,
                    //       child: GestureDetector(
                    //         onTap: () {
                    //           FirebaseAuth.instance.signOut().then((value) {
                    //             Navigator.of(context)
                    //                 .pushReplacementNamed('/landingpage');
                    //           }).catchError((e) {
                    //             print(e);
                    //           });
                    //         },
                    //         child: Center(
                    //           child: Text(
                    //             'Log out',
                    //             style: TextStyle(
                    //                 color: Colors.white,
                    //                 fontFamily: 'Montserrat'),
                    //           ),
                    //         ),
                    //       ),
                    //     ))
                  ],
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                   Container(
                        height: 30.0,
                        width: 110.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.greenAccent,
                          color: Colors.black12,
                          elevation: 7.0,
                          child: GestureDetector(
                            onTap: () {
                              editName(context);
                            },
                            child: Center(
                              child: Text(
                                'Edit Name',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Montserrat'),
                              ),
                            ),
                          ),
                        )),
                    Container(
                        height: 30.0,
                        width: 110.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.redAccent,
                          color: Colors.black12,
                          elevation: 7.0,
                          child: GestureDetector(
                            onTap: () {
                              FirebaseAuth.instance.signOut().then((value) {
                                Navigator.of(context)
                                    .pushReplacementNamed('/landingpage');
                              }).catchError((e) {
                                print(e);
                              });
                            },
                            child: Center(
                              child: Text(
                                'Log out',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Montserrat'),
                              ),
                            ),
                          ),
                        ))
                ],),
                 SizedBox(height: 15.0),
                 Container(
                        height: 30.0,
                        width: 110.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.greenAccent,
                          color: Colors.black12,
                          elevation: 7.0,
                          child: GestureDetector(
                            onTap: () {
                             Navigator.of(context).pushNamed('/category');
                            },
                            child: Center(
                              child: Text(
                                'Select Category',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Montserrat'),
                              ),
                            ),
                          ),
                        )
                      ),
              ],
            ))
      ],
    ));
  }
}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 1.9);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
