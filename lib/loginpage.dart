import 'package:flutter/material.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email;
  String _password;
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
                   padding: EdgeInsets.fromLTRB(15.0, 60.0, 0.0, 0.0),
                   child: Text(
                     "Hello",
                     style: TextStyle(
                       fontSize: 80.0,
                       fontWeight: FontWeight.bold
                     )
                   )
                 ),
                  Container(
                   padding: EdgeInsets.fromLTRB(15.0, 125.0, 0.0, 0.0),
                   child: Text(
                     "There",
                     style: TextStyle(
                       fontSize: 80.0,
                       fontWeight: FontWeight.bold
                     )
                   )
                 ),
                  Container(
                   padding: EdgeInsets.fromLTRB(220.0, 125.0, 0.0, 0.0),
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
                  SizedBox(height: 20.0,),
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
                    onChanged: (value) {
                      setState(() {
                        _password = value;
                      });
                    },
                    obscureText: true,
                  ),
                  SizedBox(height: 5.0,),
                  Container(
                    alignment:Alignment(1.0, 0.0),
                    padding: EdgeInsets.only(top:15.0,left:20.0),
                    child: InkWell(
                      child: Text("Forgot Password",
                      style: TextStyle(
                        color: Color(0xff36d1dc),
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat",
                        decoration: TextDecoration.underline
                      ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40.0),
                  NiceButton(
                  radius: 40,
                  width: 1500,
                  padding: const EdgeInsets.all(15),
                  text: "LOGIN",
                  gradientColors: [secondColor, firstColor],
                  onPressed: () {
                    FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: _email,
                      password: _password
                    ).then((user){
                      Navigator.of(context).pushReplacementNamed('/homepage');
                    }).catchError((e){
                      print(e);
                    });
                  },
                ),
                  // Container(
                  //   height: 40.0,
                  //   child: Material(
                  //     borderRadius: BorderRadius.circular(20.0),
                  //     shadowColor: Colors.green,
                  //     color: Colors.greenAccent,
                  //     elevation: 7.0,
                  //     child: GestureDetector(
                  //       onTap: () {},
                  //       child: Center(
                  //         child: Text(
                  //           "LOGIN",
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
                  // Text("New to App?"),
                  // SizedBox(height: 10.0),
                  // Container(
                  //   height: 40.0,
                  //   color: Colors.transparent,
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       border: Border.all(
                  //         color: Colors.black,
                  //         style: BorderStyle.solid,
                  //         width: 1.0
                  //       ),
                  //       color: Colors.transparent,
                  //       borderRadius: BorderRadius.circular(20.0)
                  //     ),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: <Widget>[
                  //         Center(
                  //           child: ImageIcon(AssetImage('assets/images/facebook.png')),
                  //         ),
                  //         SizedBox(width: 10.0),
                  //         Center(
                  //           child: Text("Log in with facebook",
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
                NiceButton(
                  radius: 40,
                  width: 1500,
                  padding: const EdgeInsets.all(15),
                  text: "REGISTER",
                  gradientColors: [secondColor, firstColor],
                  onPressed: (){
                    Navigator.of(context).pushNamed('/signup');
                  },
                ),
              ],
              )
            ),
            SizedBox(height: 30.0),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     Text(
            //       'New to App ?',
            //       style: TextStyle(
            //         fontFamily:"Montserrat",

            //       ),
            //     ),
            //     SizedBox(width: 5.0),
            //     InkWell(
            //       onTap: () {
            //         Navigator.of(context).pushNamed('/signup');
            //       },
            //       child: Text("Register",
            //         style: TextStyle(
            //           color: Color(0xff36d1dc),
            //           fontFamily: 'MOntserrat',
            //           fontWeight: FontWeight.bold,
            //           decoration: TextDecoration.underline
            //         ),
            //       ),
            //     )
            //   ],
            // )
         ],
         )
    );
  }
}