import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_hazizz/communication/ResponseHandler.dart';
import 'package:flutter_hazizz/communication/pojos/PojoError.dart';
import 'package:flutter_hazizz/communication/pojos/PojoTokens.dart';
import 'package:flutter_hazizz/communication/requests/RequestCollection.dart';
import 'package:flutter_hazizz/managers/TokenManager.dart';
import 'package:flutter_hazizz/managers/cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../RequestSender.dart';
import '../main.dart';

class LoginPage extends StatefulWidget {

  String _username;

  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> with SingleTickerProviderStateMixin{

  final TextEditingController _usernameTextEditingController = TextEditingController();
  final HashedTextEditingController _passwordTextEditingController = HashedTextEditingController();

  @override
  void initState() {


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // backgroundColor: widget.color,
      appBar: AppBar(
        title: new Text("Login"),
      ),

      body: //_children[_selectedIndex],
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      ListView(
        children: <Widget>[
          TextFormField(
            maxLines: 1,
            autofocus: false,
            controller: _usernameTextEditingController,
            decoration: InputDecoration(
              hintText: "",
              labelText: "Username",
            ),
            /*
            onSaved: (String value){
              widget._username = value;

              print("12345678");
            },
            */
          ),
          TextFormField(
            obscureText: true,
            maxLines: 1,
            autofocus: false,
            controller: _passwordTextEditingController,
            decoration: InputDecoration(
              labelText: "Password",
            ),
          ),

      ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                child: Text("Küldés"),
                onPressed: () async {
                  print("log: ${_passwordTextEditingController.text}");
                //  String asd = (sha256.convert(utf8.encode("")).toString();
                  Response response = await RequestSender().send(new CreateTokenWithPassword(
                      b_username: _usernameTextEditingController.text,
                      b_password: _passwordTextEditingController.text,
                      rh: new ResponseHandler(
                          onSuccessful: (Response response) async{
                            print("raw response is : ${response.data}" );
                            PojoTokens pojoTokens = PojoTokens.fromJson(jsonDecode(response.data));
                        //    SharedPreferences
                            InfoCache.setMyUsername(_usernameTextEditingController.text);
                            TokenManager.setToken(pojoTokens.token);
                            TokenManager.setRefreshToken(pojoTokens.refresh);

                            print("asdasd token: ${await TokenManager.getToken()}");
                            print("asdasd refresh: ${await TokenManager.getRefreshToken()}");

                            Navigator.push(context,MaterialPageRoute(builder: (context) => MyHomePage(title: "Main Page",)));


                          },
                          onError: (PojoError pojoError){

                            print("log: the annonymus functions work and the errorCode : ${pojoError.errorCode}");
                          }
                      )));



                },
              )
            ],
          ),

          Text("usernameTextEditingController.text"),
        ],


      )
    );
  }

}
