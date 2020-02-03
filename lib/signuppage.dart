import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'services/usermanagement.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String _email;
  String _password;
  String _nickName;
  @override
  Widget build(BuildContext context) {
    var firstColor = Color(0xff5b86e5), secondColor = Color(0xff36d1dc);
        return Scaffold(
      resizeToAvoidBottomPadding: false,
       body: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: <Widget>[
           Container(
             child: Stack(
               children: <Widget>[
                  Container(
                   padding: EdgeInsets.fromLTRB(15.0, 55.0, 0.0, 0.0),
                   child: Text(
                     "Signup",
                     style: TextStyle(
                       fontSize: 80.0,
                       fontWeight: FontWeight.bold
                     )
                   )
                 ),
                  Container(
                   padding: EdgeInsets.fromLTRB(260.0, 55.0, 0.0, 0.0),
                   child: Text(
                     ".",
                     style: TextStyle(
                       fontSize: 80.0,
                       fontWeight: FontWeight.bold,
                       color: Color(0xff36d1dc)
                     )
                   )
                 )
               ],
             ),
            ),
            Container(
              padding: EdgeInsets.only(top: 35.0, left:20.0,right:20.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                      labelText: "EMAIL",
                      labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Colors.grey
                      ),
                      hintText: "alexdaddrio001@gmail.com",
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.green
                        )
                      )
                    ),
                    onChanged: (value) {
                      setState(() {
                        _email = value;
                      });
                    },
                  
                  ),
                  SizedBox(height: 10.0,),
                   TextField(
                    decoration: InputDecoration(
                      labelText: "PASSWORD",
                      labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Colors.grey
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.green
                        )
                      )
                    ),
                    obscureText: true,
                    onChanged: (value) {
                      setState(() {
                        _password = value;
                      });
                    },
                  ),
                  SizedBox(height: 10.0,),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "NickName",
                      labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Colors.grey
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.green
                        )
                      )
                    ),
                    onChanged: (value) {
                      setState(() {
                        _nickName = value;
                      });
                    },
                  ),
                  SizedBox(height: 40.0),
                  NiceButton(
                  radius: 40,
                  width: 1500,
                  padding: const EdgeInsets.all(15),
                  text: "SIGNUP",
                  gradientColors: [secondColor, firstColor],
                  onPressed: () async {
                          var result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                            email: _email,
                            password: _password
                          ).then((result) async {
                              var userUpdateInfo = new UserUpdateInfo();
                              userUpdateInfo.displayName = _nickName;
                              userUpdateInfo.photoUrl = "https://pixel.nymag.com/imgs/daily/vulture/2017/06/14/14-tom-cruise.w700.h700.jpg";
                              await result.user.updateProfile(userUpdateInfo);
                              await result.user.reload();
                              FirebaseUser updatedUser = await FirebaseAuth.instance.currentUser();
                              print("USERNAME IS:${updatedUser.displayName}");
                            }).then((user){
                              FirebaseAuth.instance.currentUser().then((user){
                                      print('user1:${user.photoUrl}:ok');
                                      UserManagement().storeNewUser(user, context);
                              });
                            }).catchError((e){
                              print(e);
                            });
                          // }).catchError((e){
                          //   print(e);
                          // });
                          
                  },
                ),
                  // Container(
                  //   height: 40.0,
                  //   child: Material(
                  //     borderRadius: BorderRadius.circular(20.0),
                  //     shadowColor: Colors.blueGrey,
                  //     color: Color(0xff36d1dc),
                  //     elevation: 7.0,
                  //     child: GestureDetector(
                  //       onTap: () {
                  //         FirebaseAuth.instance.createUserWithEmailAndPassword(
                  //           email: _email,
                  //           password: _password
                  //         ).then((signedInUser){
                  //             UserManagement().storeNewUser(signedInUser,context);
                  //         }).catchError((e){
                  //           print(e);
                  //         });
                  //       },
                  //       child: Center(
                  //         child: Text(
                  //           "SIGNUP",
                  //           style: TextStyle(
                  //             color: Colors.white,
                  //             fontWeight: FontWeight.bold,
                  //             fontFamily: 'Montserrat'
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 20.0,),
                  NiceButton(
                  radius: 40,
                  width: 1500,
                  padding: const EdgeInsets.all(15),
                  text: "GOBACK",
                  gradientColors: [secondColor, firstColor],
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                  // Container(
                    
                  //   height: 40.0,
                  //   color: Colors.transparent,
                  //   child: Container(
                      
                  //     decoration: BoxDecoration(
                      
                  //       border: Border.all(
                  //         color: Colors.black,
                  //         style: BorderStyle.solid,
                  //         width: 1.0,
                  //       ),
                  //       color: Colors.transparent,
                  //       borderRadius: BorderRadius.circular(20.0),

                  //     ),
                  //     child: Row(             
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: <Widget>[
                  //         SizedBox(width: 10.0),
                  //         Center(
                  //           child: Text("GO BACK",
                  //           style: TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //             fontFamily: "Montserrat"
                  //           )
                  //           ),
                  //         )
                  //       ],
                  //     )
                  //   )
                  // ),
              ],
              )
            ),
         ],
         )
    );
  }
}