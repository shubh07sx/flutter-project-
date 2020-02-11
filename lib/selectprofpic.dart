import 'dart:io';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:usingfirestore_app/services/usermanagement.dart';

class SelectProfilePage extends StatefulWidget {
  @override
  _SelectProfilePageState createState() => new _SelectProfilePageState();
}

class _SelectProfilePageState extends State<SelectProfilePage> {
  File newProfilePic;
  bool isLoading = false;

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      newProfilePic = tempImage;
       isLoading = true;
    });
  }

  uploadImage() async {
    var randomno = Random(25);
    final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(
      'profilepics/${randomno.nextInt(5000).toString()}.jpg'
    );
    StorageUploadTask task = firebaseStorageRef.putFile(newProfilePic);
    StorageTaskSnapshot snapshottask = await task.onComplete;
    String profpicpath =  await snapshottask.ref.getDownloadURL();
    print(profpicpath);
    if(profpicpath!=null){
      userManagement.updateProfilePic(profpicpath.toString()).then((val){
          Navigator.of(context).pushReplacementNamed('/homepage');
      }).catchError((e){
        print(e);
      });
    }
    
  }

  UserManagement userManagement = new UserManagement();

 @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: newProfilePic == null ? getChooseButton() : getUploadButton()
    );
  }
  Widget getChooseButton() {
    return new Stack(
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
                            image: NetworkImage(
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQL3964IjJHoLSLZ4iXOa9TPZcLzq7IKyFuzIXcaYlUwHg_61TV'),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.all(Radius.circular(75.0)),
                        boxShadow: [
                          BoxShadow(blurRadius: 7.0, color: Colors.black)
                        ])),
                SizedBox(height: 90.0),
                Text(
                  'You have signed up',
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 15.0),
                Text(
                  'Choose a profile pic',
                  style: TextStyle(
                      fontSize: 17.0,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 25.0),
                Row (
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                     Container(
                    height: 30.0,
                    width: 95.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      shadowColor: Colors.greenAccent,
                      color: Colors.green,
                      elevation: 7.0,
                      child: GestureDetector(
                        onTap : getImage,
                        child: Center(
                          child: Text(
                            'Change Pic',
                            style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                          ),
                        ),
                      ),
                    )),
                   Container(
                    height: 30.0,
                    width: 95.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      shadowColor: Colors.blueAccent,
                      color: Colors.blue,
                      elevation: 7.0,
                      child: GestureDetector(
                        onTap: () {},
                        child: Center(
                          child: Text(
                            'Skip',
                            style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                          ),
                        ),
                      ),
                    )),
                // Container(
                //     height: 30.0,
                //     width: 95.0,
                //     child: Material(
                //       borderRadius: BorderRadius.circular(20.0),
                //       shadowColor: Colors.redAccent,
                //       color: Colors.red,
                //       elevation: 7.0,
                //       child: GestureDetector(
                //           onTap: () {
                //               FirebaseAuth.instance.signOut().then((value) {
                //                 Navigator.of(context).pushReplacementNamed('/landingpage');
                //               }).catchError((e){
                //                 print(e);
                //               });
                //             },
                //         child: Center(
                //           child: Text(
                //             'Log out',
                //             style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                //           ),
                //         ),
                //       ),
                //     ))

                  ],
                ),
               
              ],
            ))
      ],
    );
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


Widget getUploadButton() {
 
    return new Stack(
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
                            image:FileImage(newProfilePic),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.all(Radius.circular(75.0)),
                        boxShadow: [
                          BoxShadow(blurRadius: 7.0, color: Colors.black)
                        ])),
                SizedBox(height: 90.0),
                Text(
                  'Image Selected',
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 15.0),
                Text(
                  'Tap Upload to proceed',
                  style: TextStyle(
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
                    width: 95.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      shadowColor: Colors.blueAccent,
                      color: Colors.blue,
                      elevation: 7.0,
                      child: GestureDetector(
                        onTap: uploadImage,
                        child: Center(
                          child: Text(
                            'Upload',
                            style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                          ),
                        ),
                      ),
                    )),
                   Container(
                    height: 30.0,
                    width: 95.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      shadowColor: Colors.greenAccent,
                      color: Colors.green,
                      elevation: 7.0,
                      child: GestureDetector(
                        onTap: () {},
                        child: Center(
                          child: Text(
                            'Skip',
                            style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                          ),
                        ),
                      ),
                    )),
                // Container(
                //     height: 30.0,
                //     width: 95.0,
                //     child: Material(
                //       borderRadius: BorderRadius.circular(20.0),
                //       shadowColor: Colors.redAccent,
                //       color: Colors.red,
                //       elevation: 7.0,
                //       child: GestureDetector(
                //           onTap: () {
                //               FirebaseAuth.instance.signOut().then((value) {
                //                 Navigator.of(context).pushReplacementNamed('/landingpage');
                //               }).catchError((e){
                //                 print(e);
                //               });
                //             },
                //         child: Center(
                //           child: Text(
                //             'Log out',
                //             style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                //           ),
                //         ),
                //       ),
                //     ))

                  ],
                ),
                SizedBox(height: 5.0),
                getLoader(),
               
              ],
            ))
      ],
    );
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