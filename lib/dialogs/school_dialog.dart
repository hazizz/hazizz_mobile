import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:mobile/custom/hazizz_localizations.dart';
import 'dialog_collection.dart';

class SchoolDialog extends StatefulWidget {

  final Map<String, dynamic> data;
  final Function({String key, String value}) onPicked;

  SchoolDialog({@required this.onPicked, @required this.data});

  @override
  _SchoolDialog createState() => new _SchoolDialog();
}

class _SchoolDialog extends State<SchoolDialog> {

  List<String> keys;
  List<dynamic> values;

  List<String> searchKeys;

  Map searchData;

  _SchoolDialog();

  @override
  void initState() {
    keys = widget.data.keys.toList();
    values = widget.data.values.toList();

    searchKeys = keys;

    searchData = widget.data;

    super.initState();
  }
  
  TextEditingController searchController;

  final double width = 400;
  final double height = 500;

  final double searchBarHeight = 50;
  @override
  Widget build(BuildContext context) {

    var dialog = HazizzDialog(width: width, height: height,
      header: Container(
        height: searchBarHeight, width: width,
        color: Color.fromRGBO(230, 230, 230, 1),
        child:
          TextField(
            autofocus: true,
            style: TextStyle(fontSize: 20),
              onChanged: (String searchText){
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
                  hintText: localize(context, key: "search"),
                  prefixIcon: Icon(FontAwesomeIcons.search),
              )
          ),
    ),
    content: Container(
      height: height-searchBarHeight, width: width,
      child:
      Builder(
          builder: (BuildContext context1) {
            if(searchKeys.isNotEmpty){
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: searchKeys.length,
                itemBuilder: (BuildContext context2, int index) {
                  return GestureDetector(
                      onTap: () {
                        String tappedKey = searchKeys[index];
                        widget.onPicked(
                            key: tappedKey,
                            value: widget.data[tappedKey]
                        );
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 4, top: 0),
                        child: InkWell(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(searchKeys[index],
                                  style: TextStyle(
                                      fontSize: 16
                                  ),
                                ),
                                Divider()
                              ]
                          ),
                        ),
                      )
                  );
                },
              );
            }else{
              return Center(
                child: Text("no_school_with_that_name".localize(context),
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                )
              );
          }
          }
      ),
    ),
    actionButtons: Row(
      children:[ 
        FlatButton(
          child: Text("close".localize(context).toUpperCase()),
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.all(0),
        )
      ]
    ),
    );
    return dialog;
  }
}