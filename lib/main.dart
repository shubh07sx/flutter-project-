// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:usingfirestore_app/categories.dart';
import 'package:usingfirestore_app/chatpage.dart';
import 'package:usingfirestore_app/fashioncategory.dart';
import 'package:usingfirestore_app/filmscategory.dart';
import 'package:usingfirestore_app/groups.dart';
import 'package:usingfirestore_app/musiccategory.dart';
import 'package:usingfirestore_app/selectprofpic.dart';
import 'homepage.dart';
import 'loginpage.dart';
import 'loginsignup.dart';
import 'chatpage.dart';
import 'tempchat.dart';
import 'signuppage.dart';
import 'categories.dart';

void main() {
  //  WidgetsFlutterBinding.ensureInitialized();
  runApp(new MyApp());
  // var storage = FirebaseStorage.instance;
  // var starpath = storage.ref().child('/profilepics/1442.jpg');
  // var s = DateTime.now();
  // var url =  starpath.getDownloadURL();
  // var e = DateTime.now();
  // print(e.difference(s).inMilliseconds);
  // print(url);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return new MaterialApp(
        debugShowCheckedModeBanner: false,
          home: LoginSignup(),
          routes: <String,WidgetBuilder> {
              '/landingpage': (BuildContext context) => new MyApp(),
              '/signup': (BuildContext context) => new SignupPage(),
              '/loginpage': (BuildContext context) => new LoginPage(),
              '/homepage': (BuildContext context) => new HomePage(),
              '/selectpic': (BuildContext context) => new SelectProfilePage(),
              '/category': (BuildContext context) => new CategoryPage(),
              '/films': (BuildContext context) => new FilmPage(),
              '/fashion': (BuildContext context)=> new FashionPage(),
              '/music': (BuildContext context) => new MusicPage(),
              '/groups': (BuildContext context) => new GroupsPage(),
              '/chat': (BuildContext context) => new ChatPage(),
              '/tempchat': (BuildContext context) => new TempChat(),
           },
      );
  }
  
}