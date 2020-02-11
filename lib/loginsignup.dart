import 'package:flutter/material.dart';
import 'package:nice_button/nice_button.dart';
class LoginSignup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var firstColor = Color(0xFF37474F), secondColor = Color(0xFFB0BEC5);
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  width: 200.0,
                 
                  child: Image.asset("assets/images/logo8final.png"),
                ),
              ),
              // Text(
              //   "Tensor Chat",
              //   style: TextStyle(
              //     fontSize: 40.0,
              //   ),
              // ),
            ],
          ),
          SizedBox(
            height: 50.0,
          ),
           NiceButton(
                  width: 255,
                  elevation: 8.0,
                  radius: 52.0,
                  text: "Login",
                  background: firstColor,
                  onPressed: () {
                   Navigator.of(context).pushNamed('/loginpage');
                  },
           ),
           SizedBox(height: 30.0),
            NiceButton(
                  radius: 40,
                  padding: const EdgeInsets.all(15),
                  text: "Register",
                  icon: Icons.account_box,
                  gradientColors: [secondColor, firstColor],
                  onPressed: () {
                    Navigator.of(context).pushNamed('/signup');
                  },
                ),
        ],
      ),
    );
  }
}

