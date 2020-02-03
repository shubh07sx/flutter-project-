import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  Material myItems(IconData icon,String heading,int color,String route){
    return Material(
      color: Colors.white,
      elevation: 14.0,
      shadowColor: Color(0x802196F3),
      borderRadius: BorderRadius.circular(24.0),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                 
                   Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(heading,
                            style: TextStyle(
                            color: new Color(color),
                            fontSize: 20.0
                          )
                       )
                    ),

                    Material(
                      color: new Color(color),
                      borderRadius: BorderRadius.circular(24.0),
                      child: InkWell(
                        onTap: (){
                          Navigator.of(context).pushNamed(route);
                        },
                        child: Padding(
                        padding: const EdgeInsets.all(16.0),
                         child: Icon(
                          icon,
                          color: Colors.white,
                          size: 30.0,
                        ),
                        
                      ),
                    )
                  )
                  
                 
                ],
              )
            ],
          )
        )
      )
    );


  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text("Categories",
        style:  TextStyle(
          color: Colors.white,
        ),
       ),
     ),
     body: StaggeredGridView.count(
       crossAxisCount: 2,
       crossAxisSpacing: 12.0,
       mainAxisSpacing: 12.0,
       padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 8.0),
       children: <Widget>[
         myItems(Icons.movie,"Film",0xffed622b,"/films"),
         myItems(Icons.filter_vintage,"Fashion",0xff26cb3c,"/fashion"),
         myItems(Icons.music_note,"Music",0xffff3266,"/music"),
        //  myItems(Icons.graphic_eq,"TotalViews",0xffed622b),
        //  myItems(Icons.graphic_eq,"TotalViews",0xffed622b),
        //  myItems(Icons.graphic_eq,"TotalViews",0xffed622b),
       ],
       staggeredTiles: [
         StaggeredTile.extent(2,160.0),
         StaggeredTile.extent(2, 160.0),
         StaggeredTile.extent(2, 160.0),
       ],
     )
   );
  }
}