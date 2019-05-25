import 'package:flutter/material.dart';
import 'RequestSender.dart';
import 'communication/pojos/PojoError.dart';
import 'communication/requests/RequestCollection.dart';
import 'package:dio/dio.dart';
import 'communication/pojos/PojoTokens.dart';
import 'dart:convert';
import 'communication/ResponseHandler.dart';


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
                      print("log: 1111");
                      Response response = await requestSender.send(new CreateTokenWithPassword(b_username: "erik", b_password: "15E2B0D3C33891EBB0F1EF609EC419420C20E320CE94C65FBC8C3312448EB225",
                                                rh: new ResponseHandler(
                                                    onSuccessful: (Response response){
                                                      print("raw response is : ${response.data}" );
                                                      PojoTokens pojoTokens = PojoTokens.fromJson(jsonDecode(response.data));
                                                      print("log: 3333");
                                                      print("log: token : ${pojoTokens.token}");
                                                    },
                                                    onError: (PojoError pojoError){

                                                      print("log: the annonymus functions work and the errorCode : ${pojoError.errorCode}");
                                                    }
                                                )));
                      print("log: 2222");


                    },
                    child: null

                ),
                Icon(Icons.directions_transit),
              ]
        ),

    );
  }

}
