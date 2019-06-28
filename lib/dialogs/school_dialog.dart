
import 'package:flutter/material.dart';


class SchoolDialog extends StatefulWidget {

  final Map data;
  final Function({String key, String value}) onPicked;


  SchoolDialog({@required this.onPicked, @required this.data});

  @override
  _SchoolDialog createState() => new _SchoolDialog();
}

class _SchoolDialog extends State<SchoolDialog> {

 // final Function({String key, String value}) onPicked;
 // final Map data;

  List<String> keys;
  List<dynamic> values;

  List<String> searchKeys;

  Map searchData;

  _SchoolDialog(){
  }

  @override
  void initState() {
    keys = widget.data.keys.toList();
    values = widget.data.values.toList();

    searchKeys = keys;

    searchData = widget.data;

    super.initState();
    
  }
  

  TextEditingController searchController;

  final double width = 300;
  final double height = 500;

  final double searchBarHeight = 50;
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        // title: new Text("Alert Dialog title"),
        children: [Container(
          height: height,
          width: width,
          child: Column( 
            children: [
              Container(
                height: searchBarHeight, width: width,
                child: 
              TextField(
                onChanged: (String searchText){
               //   List<String> searchKeys = keys;
                    
                  List<String> nextSearchKeys = List();
                  for(String s in keys){
                      if(s.toLowerCase().contains(searchText.toLowerCase())){
                        nextSearchKeys.add(s);
                      }
                  }
                  setState((){
                    searchKeys = nextSearchKeys;
                  });
                },
                controller: searchController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25.0)))
                )
              ),
          ),
          Container(
            height: height-searchBarHeight, width: width,
            child:
              ListView.builder(
                itemCount: searchKeys.length,
                itemBuilder: (BuildContext context, int index){
                  return GestureDetector(
                      onTap: (){
                        String tappedKey = searchKeys[index];
                        widget.onPicked(
                          key: tappedKey,
                          value: widget.data[tappedKey]
                        );
                        Navigator.of(context).pop();

                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 4, top: 4, bottom: 4),
                        child: InkWell(
                          child: Text(searchKeys[index],
                            style: TextStyle(
                                fontSize: 18
                            ),
                          ),
                        ),
                      )
                  );
                },
              ), 
          ),
            ]
          )
        ),
        ],
      );
  }
}