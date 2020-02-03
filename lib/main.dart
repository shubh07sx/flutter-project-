import 'package:flutter/material.dart';
import 'package:usingfirestore_app/categories.dart';
import 'package:usingfirestore_app/fashioncategory.dart';
import 'package:usingfirestore_app/filmscategory.dart';
import 'package:usingfirestore_app/groups.dart';
import 'package:usingfirestore_app/musiccategory.dart';
import 'package:usingfirestore_app/selectprofpic.dart';
import 'homepage.dart';
import 'loginpage.dart';
import 'signuppage.dart';
import 'categories.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return new MaterialApp(
        debugShowCheckedModeBanner: false,
          home: LoginPage(),
          routes: <String,WidgetBuilder> {
              '/landingpage': (BuildContext context) => new MyApp(),
              '/signup': (BuildContext context) => new SignupPage(),
              '/homepage': (BuildContext context) => new HomePage(),
              '/selectpic': (BuildContext context) => new SelectProfilePage(),
              '/category': (BuildContext context) => new CategoryPage(),
              '/films': (BuildContext context) => new FilmPage(),
              '/fashion': (BuildContext context)=> new FashionPage(),
              '/music': (BuildContext context) => new MusicPage(),
              '/groups': (BuildContext context) => new GroupsPage()
           },
      );
  }
  
}