import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserManagement {
    Future<void> storeNewUser(FirebaseUser user, BuildContext context) async {
      var result = await Firestore.instance.collection('users').add({
        'email': user.email,
        'uid' : user.uid,
        'displayName': user.displayName,
        'photoUrl': user.photoUrl,
      
      }).then((value){
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacementNamed('/selectpic');
      }).catchError((e){
        print(e);
      });
      // print(result);
      // print(result.documentID);
     
    }
Future updateProfilePic(picUrl) async {
      var userInfo = new UserUpdateInfo();
      userInfo.photoUrl = picUrl;
      await FirebaseAuth.instance.currentUser().then((user) async {
         await user.updateProfile(userInfo);
         Firestore.instance.collection('/users')
         .where('uid',isEqualTo: user.uid)
         .getDocuments()
         .then((docs){
           Firestore.instance.document('/users/${docs.documents[0].documentID}')
           .updateData({'photoUrl':picUrl}).then((val){
             print('Updated');
           }).catchError((e){
             print(e);
           });
         }).catchError((e){
            print(e);
         });
      }).catchError((e){
        print(e);
      });

      
    }

  Future updateNickName(String newName) async {
    var userInfo = new UserUpdateInfo();
    userInfo.displayName = newName;

    FirebaseAuth.instance.currentUser().then((user) async{
      await user.updateProfile(userInfo);
      Firestore.instance.collection('/users').where('uid',isEqualTo:user.uid).getDocuments().then((docs){
          Firestore.instance.document('/users/${docs.documents[0].documentID}')
          .updateData({'displayName': newName}).then((val){
            print('updated');
          }).catchError((e){
              print(e);
          });
      }).catchError((e){
        print(e);
      });
    }).catchError((e){
      print(e);
    });
  }
  
  Future<void> updateUserData(String proffesion) async {
    var user = await FirebaseAuth.instance.currentUser();
    await Firestore.instance.collection('users').document(user.uid).setData(
      {'proffesion': proffesion,'useruid':user.uid}
    );
  }
  
  //  getdata() async {
  //    return Firestore.instance.collection('users').document('uid').snapshots();
  //  }



   String getphoto() { 
     String use;
      FirebaseAuth.instance.currentUser().then((user){
           use = user.photoUrl;
     });
     return use;
  }





















  // Future updateProffesion(String newProf) async {
  //   FirebaseAuth.instance.currentUser().then((user) async {
  //     Firestore.instance.collection('users').where('uid',isEqualTo: user.uid).getDocuments().then((docs){
  //       Firestore.instance.document('/users/${docs.documents[0].documentID}/proffesion')
  //       .updateData({'proffesion': newProf}).then((val){
  //         print('proffesion updated');
  //       }).catchError((e){
  //         print(e);
  //       });
  //     }).catchError((e){
  //       print(e);
  //     });
  //   }).catchError((e){
  //     print(e);
  //   });
    
    
  // }

  // updateProffesion(selectedDoc,newValues){
  //   FirebaseAuth.instance.currentUser().then((user){
  //     Firestore.instance.collection('users').document(user.uid)
  //   }).catchError((e){
  //     print(e);
  //   });
  //   // Firestore.instance.collection('testcrud').document(selectedDoc).updateData(newValues).catchError((e){
  //   //   print(e);
  //   // });
  // }
  //  bool isLoggedIn() {
  //   if(FirebaseAuth.instance.currentUser()!=null){
  //       return true;
  //   }
  //   else{
  //     return false;
  //   }
  // }

  //  Future<void> addData(proffesion) async {
  //   if(isLoggedIn()) {
  //     Firestore.instance.collection('testuser').add(proffesion).catchError((e){
  //         print(e);
  //     });
  //   }
  //   else{
  //     print('You need to be logged in');
  //   }
  // }
  // gettData() async {
  //   // QuerySnapshot qn = await Firestore.instance.collection('testcrud').getDocuments();
  //   // return  qn;
  //    return await Firestore.instance.collection('testuser').snapshots();
  // } 
  // updateData(selectedDoc,newValues){
  //   Firestore.instance.collection('testuser').document(selectedDoc).updateData(newValues).catchError((e){
  //     print(e);
  //   });
  // }
  
}

