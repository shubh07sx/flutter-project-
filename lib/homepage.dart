import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'profilepage.dart';
import 'dashboard.dart';
import 'chatpage.dart';
import 'groups.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 2,vsync: this);
  }


  @override
  Widget build(BuildContext context) {

      return Scaffold(
         bottomNavigationBar: new Material(
           color: Colors.blueAccent,
           child: TabBar(
              controller: tabController,
              tabs: <Widget>[
                new Tab(icon: Icon(Icons.home)),
                new Tab(icon: Icon(Icons.person)),
              ],
           ),
         ), 
         body: new TabBarView(
           controller: tabController,
           children: <Widget>[
             DashboardPage(),
             ProfilePage()
           ],
         )
    );












































    // return Scaffold(
    //   appBar: new AppBar(
    //     title: new Text('Dashboard'),
    //     centerTitle: true,
    //   ),
    //   body: Center(
    //     child: Container(
    //       child: new Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: <Widget>[
    //           new Text('You are now Logged In'),
    //           SizedBox(
    //             height: 15.0,
    //           ),
    //           new OutlineButton(
    //             borderSide: BorderSide(
    //               color: Colors.red, style: BorderStyle.solid, width: 3.0),
    //             child: Text('Logout'),
    //             onPressed: () {
    //               FirebaseAuth.instance.signOut().then((value) {
    //                 Navigator.of(context).pushReplacementNamed('/landingpage');
    //               }).catchError((e){
    //                 print(e);
    //               });
    //             },
    //           )
    //         ],
    //       )
    //     ),
    //   )
    // );
  }
}