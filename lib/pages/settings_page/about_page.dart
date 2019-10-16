
import 'package:flutter_svg/svg.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/widgets/hazizz_back_button.dart';
import 'package:mobile/widgets/hyper_link.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:mobile/custom/hazizz_app_info.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:flutter/material.dart';
import 'package:mobile/blocs/other/settings_bloc.dart';

import 'package:mobile/communication/request_sender.dart';


class AboutPage extends StatefulWidget {

  String getTitle(BuildContext context){
    return locText(context, key: "about");
  }

  StartPageItemPickerBloc startPageItemPickerBloc = new StartPageItemPickerBloc();

  AboutPage({Key key}) : super(key: key);

  @override
  _AboutPage createState() => _AboutPage();
}

class _AboutPage extends State<AboutPage> with AutomaticKeepAliveClientMixin {

  String version = HazizzAppInfo().getInfo.version;

  String website = "https://hazizz.github.io/";

  bool gatewayServerIsOnline = true;
  bool authServerIsOnline = true;
  bool hazizzServerIsOnline = true;
  bool theraServerIsOnline = true;

  String fb_site = "https://www.facebook.com/hazizzvelunk/";
  String tw_site = "https://twitter.com/Hzizz1";
  String dc_site = "https://discord.gg/TABMV3M";
  String gh_site = "https://github.com/hazizz";

  _AboutPage();

  @override
  void initState() {
    // widget.myGroupsBloc.dispatch(FetchData());

    RequestSender().getResponse(PingGatewayServer()).then((hazizzResponse){
      if(hazizzResponse != null && !hazizzResponse.isSuccessful){
        setState(() {
          gatewayServerIsOnline = false;
        });
      }
    });
    RequestSender().getResponse(PingAuthServer()).then((hazizzResponse){
      if(hazizzResponse != null && !hazizzResponse.isSuccessful){
        setState(() {
          authServerIsOnline = false;
        });
      }
    });
    RequestSender().getResponse(PingHazizzServer()).then((hazizzResponse){
      if(hazizzResponse != null && !hazizzResponse.isSuccessful){
        setState(() {
          hazizzServerIsOnline = false;
        });
      }
    });
    RequestSender().getResponse(PingTheraServer()).then((hazizzResponse){
      if(hazizzResponse != null && !hazizzResponse.isSuccessful){
        setState(() {
          theraServerIsOnline = false;
        });
      }
    });

    super.initState();
  }

  Widget isOnlineWidget(){
    return Text(locText(context, key: "online"), style: TextStyle(color: Colors.green, fontSize: 17),);
  }

  Widget isOfflineWidget(){
    return Text(locText(context, key: "offline"), style: TextStyle(color: Colors.red, fontSize: 17),);
  }


  @override
  Widget build(BuildContext context) {
   return Hero(
      tag: "about",
      child: Scaffold(
          appBar: AppBar(
            leading: HazizzBackButton(),
            title: Text(widget.getTitle(context)),
          ),
          body: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 18.0, bottom: 8, left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("${locText(context, key: "version")}:", style: TextStyle(fontSize: 17),),
                      Text(version)
                    ],
                  )
                ),

                Divider(),

                Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("${locText(context, key: "website")}:", style: TextStyle(fontSize: 17),),
                        Hyperlink(website, Text(website, style: TextStyle(color: Colors.blueAccent, fontSize: 17, decoration: TextDecoration.underline),))
                      ],
                    )
                ),
                Divider(),

                Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("${locText(context, key: "gateway_server")}:", style: TextStyle(fontSize: 17),),
                        Builder(
                          builder: (context){
                            if(gatewayServerIsOnline){
                              return isOnlineWidget();
                            }
                            return isOfflineWidget();
                          },
                        )
                      ],
                    )
                ),

                Divider(),

                Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("${locText(context, key: "auth_server")}:", style: TextStyle(fontSize: 17),),
                        Builder(
                          builder: (context){
                            if(authServerIsOnline){
                              return isOnlineWidget();
                            }
                            return isOfflineWidget();
                          },
                        )
                      ],
                    )
                ),
                Divider(),
                Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("${locText(context, key: "hazizz_server")}:", style: TextStyle(fontSize: 17),),
                        Builder(
                          builder: (context){
                            if(hazizzServerIsOnline){
                              return isOnlineWidget();
                            }
                            return isOfflineWidget();
                          },
                        )
                      ],
                    )
                ),
                Divider(),
                Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("${locText(context, key: "thera_server")}:", style: TextStyle(fontSize: 17),),
                        Builder(
                          builder: (context){
                            if(theraServerIsOnline){
                              return isOnlineWidget();
                            }
                            return isOfflineWidget();
                          },
                        )
                      ],
                    )
                ),
                Divider(),


                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          if (await canLaunch(fb_site)) {
                            await launch(fb_site);
                          }
                        },
                        child: Container(
                          child: SvgPicture.asset(
                            "assets/icons/facebook.svg",
                            height: 40,
                            width: 40,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (await canLaunch(tw_site)) {
                            await launch(tw_site);
                          }
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          child: SvgPicture.asset(
                            "assets/icons/twitter.svg",
                            fit: BoxFit.fitHeight,

                            height: 40,
                            width: 40,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (await canLaunch(dc_site)) {
                            await launch(dc_site);
                          }
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          child: SvgPicture.asset(
                            "assets/icons/discord.svg",
                            fit: BoxFit.fitHeight,

                            height: 40,
                            width: 40,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (await canLaunch(gh_site)) {
                            await launch(gh_site);
                          }
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          child: SvgPicture.asset(
                            "assets/icons/github.svg",
                            fit: BoxFit.fitHeight,

                            height: 40,
                            width: 40,
                          ),
                        ),
                      ),


                    ],
                  ),
                )
              ]
            ),
          )
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;


}
