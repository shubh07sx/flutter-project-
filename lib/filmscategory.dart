import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'grouped_button.dart';


import 'package:flutter/material.dart';

class FilmPage extends StatefulWidget {
  @override
  _FilmPageState createState() => _FilmPageState();
}

class _FilmPageState extends State<FilmPage> {

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: Text("Films Category",
        style:  TextStyle(
          color: Colors.white,
        ),
      )),
      
      body: RadioButtonGroup(
        labels: <String>[
          "Direct",
          "Cinematograph",
          "Edit",
          "Write",
          "Act",
          "Make Up",
          "Set",
          "Sound",
          "Graphic Design",
          "Buisness"
        ],
         onSelected: (String selected) {
           FirebaseAuth.instance.currentUser().then((user){
            Firestore.instance.collection('film').document(user.uid).setData(
              {'subcat': selected , 'name': user.displayName,'email': user.email,'photo': user.photoUrl,'uid': user.uid}
            );
             var route = new MaterialPageRoute(
                  builder: (BuildContext context) =>
                      new NextfilmPage(value: selected,username: user.displayName,email:user.email,photo: user.photoUrl),

            );
             Navigator.of(context).push(route);
           });
          
           
         }
      )
    );
  }
}
class NextfilmPage extends StatefulWidget {
  final String value;
  final String username;
  final String email;
  final String photo;
  final String uid;

  NextfilmPage({Key key, this.value,this.username,this.email,this.photo,this.uid}) : super(key: key);
  @override
  _NextfilmPageState createState() => _NextfilmPageState();
}

class _NextfilmPageState extends State<NextfilmPage> {
  var profpic = 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQL3964IjJHoLSLZ4iXOa9TPZcLzq7IKyFuzIXcaYlUwHg_61TV';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Colors.black12,
        title: Text("Film Category List",
        style: TextStyle(
          color: Colors.white,
          fontStyle: FontStyle.italic,
        )
        ),
      ),
      body: _FilmList(),
    );
  }
  Widget _FilmList() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('film').where('subcat', isEqualTo: widget.value).snapshots(),
       builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
        // print(temp);
        if(snapshot.hasError)
        {
            return new Text("Error:${snapshot.error}");
        }
        switch(snapshot.connectionState){
          case ConnectionState.waiting: return new Text("Loading.....");
          default: 
            return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document){
                  return new ListTile(
                    onLongPress:() {
                      var route = new MaterialPageRoute(
                        builder: (BuildContext context) => new UserprofPage(val: document['subcat'],username: document['name'],email:document['email'],photo:document['photo'],uid: document['uid']),
                        
                      );
                      
                      Navigator.of(context).push(route);
                     
                    } ,
                    title: new Text(document['name'],
                    style: new TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18.9,
                      ),
                    ),
                    subtitle: new Text("Field:- ${document['subcat']},Email:-${document['email']}",
                    style: new TextStyle(
                          color: Colors.lightBlueAccent,
                          fontSize: 13.4,
                          fontStyle: FontStyle.italic,
                     )
                    ),
                      leading: new CircleAvatar(
                     radius: 30.0,
                     backgroundColor: Colors.transparent,
                     backgroundImage:
                        NetworkImage(document['photo']??profpic),
                ),
                // onLongPress: () {
                //   Navigator.of(context).push('separProfPage');
                // },
                  trailing: Icon(
                        Icons.chat,
                         color: Colors.blue,
                        ),
                  onTap: () {
                  Navigator.of(context).pushNamed('/chat');
                  //  FirebaseAuth.instance.currentUser().then((user){
                  //     Firestore.instance.collection('users').document(user.uid).collection('friends').add(
                  //       {
                  //         'friendname': document['name'],
                  //         'status': "Dont know",
                  //         'sendername': user.displayName,
                  //       }
                  //     );
                  //  });
                  //  print("added");
                  },
                );
                Expanded(
                  child: Divider(),
                );
              }).toList(),
            );
        }
      } 
    );
  }
}
class UserprofPage extends StatefulWidget {
  final String val;
  final String username;
  final String email;
  final String photo;
  final String uid;
   UserprofPage({Key key, this.val,this.username,this.email,this.photo,this.uid}) : super(key: key);
  @override
  _UserprofPageState createState() => _UserprofPageState();
}

class _UserprofPageState extends State<UserprofPage> {
   var city = "...";
  var bio = "...";

  @override void initState() {
    super.initState();
    initUserState();
   
  }
  Future<void> initUserState() async {
    var user = await FirebaseAuth.instance.currentUser();
    var snap = await Firestore.instance.collection('city').document(widget.uid).get();
    var data = snap.data;
    var snap1 = await Firestore.instance.collection('bio').document(widget.uid).get();
    var data1 = snap1.data;
     setState(() {
       city = data['city'];
       bio = data1['bio'];
    });
  }
  var profpic = 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQL3964IjJHoLSLZ4iXOa9TPZcLzq7IKyFuzIXcaYlUwHg_61TV';
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
                            image: NetworkImage(widget.photo??"https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQL3964IjJHoLSLZ4iXOa9TPZcLzq7IKyFuzIXcaYlUwHg_61TV"),
                            fit: BoxFit.cover
                          ),
                        ),
                      ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.0,right:20.0,top:20.0),
                        child: Text(
                         widget.username,
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
                          widget.email,
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
                                    "SanFrancisco, USA",
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
                                   widget.val,
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
                      // Padding(
                      //   padding: EdgeInsets.only(left: 20.0,right:240.0,top:20.0),
                      //   child: AnimatedContainer(
                      //     duration: Duration(milliseconds: 1000),
                      //     height: 40.0,
                      //     width: 100.0,
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(20.0),
                      //       color: toggleValue ? Colors.greenAccent[100]: Colors.redAccent[100].withOpacity(0.5)
                      //     ),
                      //     child: Stack(
                      //       children: <Widget>[
                      //         AnimatedPositioned(
                      //           duration: Duration(milliseconds: 1000),
                      //           curve: Curves.easeIn,
                      //           top: 3.0,
                      //           left: toggleValue ? 60.0 : 0.0,
                      //           right: toggleValue ? 0.0 : 60.0,
                      //           child: InkWell(
                      //             onTap: toggleButton,
                      //             child: AnimatedSwitcher(
                      //               duration: Duration(milliseconds: 1000),
                      //               transitionBuilder: (Widget child,Animation<double> animation){
                      //                 return RotationTransition(
                      //                   child: child,
                      //                   turns: animation
                      //                 );
                      //               },
                      //               child: toggleValue ? Icon(Icons.check_circle,color: Colors.green,size: 35.0,
                      //               key: UniqueKey()
                      //               ) : Icon(Icons.remove_circle_outline,color: Colors.red,size: 35.0,
                      //               key: UniqueKey()
                      //               ) 
                      //             ),
                      //           )
                      //         )
                      //       ],
                      //     )
                      //   )
                      // ),
                    ],
                  )
                ],
            )
      );
  }
//   Widget _individualPage() {
//     var profpic = 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQL3964IjJHoLSLZ4iXOa9TPZcLzq7IKyFuzIXcaYlUwHg_61TV';
//     return StreamBuilder<QuerySnapshot>(
//       stream: Firestore.instance.collection('film').where('subcat', isEqualTo: widget.val).snapshots(),
//       builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
//           if(snapshot.hasError)
//         {
//             return new Text("Error:${snapshot.error}");
//         }
//         switch(snapshot.connectionState){
//           case ConnectionState.waiting: return new Text("Loading.....");
//           default: 
//             return new ListView(
            
//             );
//         }
//       }
//     );
//   }
// }


// class separProfPage extends StatefulWidget {
//   @override
//   _separProfPageState createState() => _separProfPageState();
// }

// class _separProfPageState extends State<separProfPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _separateProf(),
//     );
//   }
//   Widget _separateProf() {
//       return StreamBuilder<QuerySnapshot>(
//       stream: Firestore.instance.collection('film').where('subcat', isEqualTo: widget.value).snapshots(),
//        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
//         // print(temp);
//         if(snapshot.hasError)
//         {
//             return new Text("Error:${snapshot.error}");
//         }
//         switch(snapshot.connectionState){
//           case ConnectionState.waiting: return new Text("Loading.....");
//           default: 
//             return new ListView(
//               children: snapshot.data.documents.map((DocumentSnapshot document){
//                   return new ListTile(
//                     title: new Text(document['name'],
//                     style: new TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 18.9,
//                       ),
//                     ),
//                     subtitle: new Text("Field:- ${document['subcat']},Email:-${document['email']}",
//                     style: new TextStyle(
//                           color: Colors.lightBlueAccent,
//                           fontSize: 13.4,
//                           fontStyle: FontStyle.italic,
//                      )
//                     ),
//                       leading: new CircleAvatar(
//                      radius: 30.0,
//                      backgroundColor: Colors.transparent,
//                      backgroundImage:
//                         NetworkImage(document['photo']??profpic),
//                 ),
//                   trailing: Icon(
//                         Icons.person_add,
//                          color: Colors.blue,
//                         ),
//                   onTap: () {},
//                 );
//                 Expanded(
//                   child: Divider(),
//                 );
//               }).toList(),
//             );
//         }
//       } 
//     );
//   }
// }
















//   final List<String> labels;

//   /// Specifies which boxes to be automatically check.
//   /// Every element must match a label.
//   /// This is useful for clearing all selections (set it to []).
//   /// If this is non-null, then the user must handle updating this list; otherwise, the state of the CheckboxGroup won't change.
//   final List<String> checked;

//   /// Specifies which boxes should be disabled.
//   /// If this is non-null, no boxes will be disabled.
//   /// The strings passed to this must match the labels.
//   final List<String> disabled;

//   /// Called when the value of the CheckboxGroup changes.
//   final void Function(bool isChecked, String label, int index) onChange;

//   /// Called when the user makes a selection.
//   final void Function(List<String> selected) onSelected;

//   /// The style to use for the labels.
//   final TextStyle labelStyle;

//   /// Specifies the orientation to display elements.
//   final GroupedButtonsOrientation orientation;

//   /// Called when needed to build a CheckboxGroup element.
//   final Widget Function(Checkbox checkBox, Text label, int index) itemBuilder;

//   //THESE FIELDS ARE FOR THE CHECKBOX

//   /// The color to use when a Checkbox is checked.
//   final Color activeColor;

//   /// The color to use for the check icon when a Checkbox is checked.
//   final Color checkColor;

//   /// If true the checkbox's value can be true, false, or null.
//   final bool tristate;


//   //SPACING STUFF

//   /// Empty space in which to inset the CheckboxGroup.
//   final EdgeInsetsGeometry padding;

//   /// Empty space surrounding the CheckboxGroup.
//   final EdgeInsetsGeometry margin;

//   FilmPage({
//     Key key,
//     @required this.labels,
//     this.checked,
//     this.disabled,
//     this.onChange,
//     this.onSelected,
//     this.labelStyle = const TextStyle(),
//     this.activeColor, //defaults to toggleableActiveColor,
//     this.checkColor = const Color(0xFFFFFFFF),
//     this.tristate = false,
//     this.orientation = GroupedButtonsOrientation.VERTICAL,
//     this.itemBuilder,
//     this.padding = const EdgeInsets.all(0.0),
//     this.margin = const EdgeInsets.all(0.0),
//   }) : super(key: key);


  
//   @override
//   _FilmPageState createState() => _FilmPageState();
// }

// class _FilmPageState extends State<FilmPage> {


//   List<String> _selected = [];

//   @override
//   void initState(){
//     super.initState();

//     //set the selected to the checked (if not null)
//     _selected = widget.checked ?? [];

//   }

//   @override
//   Widget build(BuildContext context) {

//     //set the selected to the checked (if not null)
//     if(widget.checked != null){
//       _selected = [];
//      _selected.addAll(widget.checked); //use add all to prevent a shallow copy
//     }


//     List<Widget> content = [];

//     for(int i = 0; i < widget.labels.length; i++){

//       Checkbox cb = Checkbox(
//                       value: _selected.contains(widget.labels.elementAt(i)),
//                       onChanged: (widget.disabled != null && widget.disabled.contains(widget.labels.elementAt(i))) ? null :
//                                     (bool isChecked) => onChanged(isChecked, i),
//                       checkColor: widget.checkColor,
//                       activeColor: widget.activeColor ?? Theme.of(context).toggleableActiveColor,
//                       tristate: widget.tristate,
//                     );

//       Text t = Text(
//         widget.labels.elementAt(i),
//         style: (widget.disabled != null && widget.disabled.contains(widget.labels.elementAt(i))) ?
//                   widget.labelStyle.apply(color: Theme.of(context).disabledColor) :
//                   widget.labelStyle
//       );



//       //use user defined method to build
//       if(widget.itemBuilder != null)
//         content.add(widget.itemBuilder(cb, t, i));
//       else{ //otherwise, use predefined method of building

//         //vertical orientation means Column with Row inside
//         if(widget.orientation == GroupedButtonsOrientation.VERTICAL){

//           content.add(Row(children: <Widget>[
//             SizedBox(width: 12.0),
//             cb,
//             SizedBox(width: 12.0),
//             t,
//           ]));

//         }else{ //horizontal orientation means Row with Column inside

//           content.add(Column(children: <Widget>[
//             cb,
//             SizedBox(width: 12.0),
//             t,
//           ]));

//         }

//       }
//     }

//     return Container(
//       padding: widget.padding,
//       margin: widget.margin,
//       child: widget.orientation == GroupedButtonsOrientation.VERTICAL ? Column(children: content) : Row(children: content),
//     );
//   }


//   void onChanged(bool isChecked, int i){
//     bool isAlreadyContained = _selected.contains(widget.labels.elementAt(i));

//     if(mounted){
//       setState(() {
//         if(!isChecked && isAlreadyContained){
//           _selected.remove(widget.labels.elementAt(i));
//         }else if(isChecked && !isAlreadyContained){
//           _selected.add(widget.labels.elementAt(i));
//         }

//         if(widget.onChange != null) widget.onChange(isChecked, widget.labels.elementAt(i), i);
//         if(widget.onSelected != null) widget.onSelected(_selected);
//       });
//     }
//   }

  // final String label;
  // final bool value;
  // final ValueChanged<bool> onChanged;
  // final TextStyle labelStyle;

  // const _FilmPageState (
  //     {Key key, this.label, this.value, this.onChanged, this.labelStyle})
  //     : super(key: key);

  // @override
  // Widget build(BuildContext context) {
  //   return InkWell(
  //     onTap: () {
  //       onChanged(!value);
  //     },
  //     child: Container(
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         children: <Widget>[
  //           Checkbox(
  //               materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  //               value: value,
  //               onChanged: onChanged,
  //               activeColor: Theme.of(context).primaryColor),
  //           Text(label, style: labelStyle),
  //         ],
  //       ),
  //     ),
  //   );
  // }




  // bool _value = false;
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text("Circle CheckBox"),
  //     ),
  //     body: Center(
  //         child: InkWell(
  //       onTap: () {
  //         setState(() {
  //           _value = !_value;
  //         });
  //       },
  //       child: Container(
  //         decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
  //         child: Padding(
  //           padding: const EdgeInsets.all(10.0),
  //           child: _value
  //               ? Icon(
  //                   Icons.check,
  //                   size: 30.0,
  //                   color: Colors.white,
  //                 )
  //               : Icon(
  //                   Icons.check_box_outline_blank,
  //                   size: 30.0,
  //                   color: Colors.blue,
  //                 ),
  //         ),
  //       ),
  //     )),
  //   );
  // }
}