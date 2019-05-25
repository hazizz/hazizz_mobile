import 'package:flutter/material.dart';
import 'RequestSender.dart';
import 'CreateTokenWithPassword.dart';
import 'package:dio/dio.dart';
import 'communication/pojos/PojoTokens.dart';
import 'dart:convert';
import 'communication/pojos/ResponseHandler.dart';


class PlaceholderWidget extends StatefulWidget {
  final Color color;

  final String name1;

  final Text text1;


  PlaceholderWidget({Key key, this.color, this.name1, this.text1}) : super(key: key);

  @override
  _PlaceholderWidget createState() => _PlaceholderWidget();
}

class _PlaceholderWidget extends State<PlaceholderWidget> with SingleTickerProviderStateMixin{

  TabController _tabController;

  void _handleTabSelection() {
    setState(() {

    });
  }

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.color,
      appBar: AppBar(
        flexibleSpace: SafeArea(
          child: TabBar(controller: _tabController, tabs: [
            Tab(text: widget.name1, icon: Icon(Icons.add)),
            Tab(text: widget.name1, icon: Icon(Icons.edit))
          ])
        ),
      ),

      body: //_children[_selectedIndex],
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
       TabBarView(
              controller: _tabController,
              children: [
                FlatButton(
                    onPressed: () async{

                      print("ökör");
                      RequestSender requestSender = new RequestSender();
                      requestSender.asd();
                      print("log: 1111");
                      Response response = await requestSender.send(new CreateTokenWithPassword({"username" : "erik", "password" : "15E2B0D3C33891EBB0F1EF609EC419420C20E320CE94C65FBC8C3312448EB225"},
                                            new ResponseHandler(onResponse: (Response){
                                              print("");
                                            })));
                      print("log: 2222");

                      PojoTokens pojoTokens = PojoTokens.fromJson(jsonDecode(response.data));
                      print("log: 3333");
                      print("log: token : ${pojoTokens.token}");
                    },
                    child: null

                ),
                Icon(Icons.directions_transit),
              ]
        ),

    );
  }

}
