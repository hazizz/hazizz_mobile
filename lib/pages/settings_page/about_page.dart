import 'package:flutter_svg/svg.dart';
import 'package:googleapis/drive/v2.dart';
import 'package:mobile/managers/server_checker.dart';
import 'package:mobile/services/facebook_opener.dart';
import 'package:mobile/widgets/hazizz_back_button.dart';
import 'package:mobile/widgets/hyper_link.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:mobile/custom/hazizz_app_info.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:flutter/material.dart';


class AboutPage extends StatefulWidget {

  static final String version = HazizzAppInfo().getInfo.version;
  static const String website = "https://hazizz.hu";
  static const String fb_site = "https://www.facebook.com/hazizzvelunk/";
  static const String tw_site = "https://twitter.com/hazizzvelunk";
  static const String dc_site = "https://discord.gg/TABMV3M";
  static const String gh_site = "https://github.com/hazizz";

  String getTitle(BuildContext context){
    return locText(context, key: "about");
  }


  AboutPage({Key key}) : super(key: key);

  @override
  _AboutPage createState() => _AboutPage();
}

class _AboutPage extends State<AboutPage> {

  bool gatewayServerIsOnline = true;
  bool authServerIsOnline = true;
  bool hazizzServerIsOnline = true;
  bool theraServerIsOnline = true;

  int kretaRequestsInLastHour;
  double kretaSuccessRate;


  _AboutPage();

  void _map(){
    gatewayServerIsOnline = ServerChecker.gatewayOnline;
    authServerIsOnline = ServerChecker.authOnline;
    hazizzServerIsOnline = ServerChecker.hazizzOnline;
    theraServerIsOnline = ServerChecker.theraOnline;

    kretaRequestsInLastHour = ServerChecker.kretaRequestsInLastHour;
    kretaSuccessRate = ServerChecker.kretaSuccessRate;
  }

  Future<void> fetch() async {
    _map();
    await ServerChecker.checkAll(notifyFlush: false).then((val){
      if(mounted){
        setState(() {
          _map();
        });
      }
    });
  }

  @override
  void initState() {

    fetch();
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
          body: RefreshIndicator(
            onRefresh: () => fetch(),
            child: ListView(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(top: 18.0, bottom: 8, left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("${locText(context, key: "version")}:", style: TextStyle(fontSize: 17),),
                        Text(AboutPage.version, style: TextStyle(fontSize: 17))
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
                    child: Column(
                      children: <Widget>[
                        Row(
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
                        ),
                        if(kretaRequestsInLastHour != null || kretaSuccessRate != null) SizedBox(height: 8,),
                        kretaRequestsInLastHour != null ? Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: <Widget>[
                              Text("${locText(context, key: "kreta_requests_in_last_hour")}: ", style: TextStyle(fontSize: 15),),
                              Text(kretaRequestsInLastHour.toString(), style: TextStyle(fontSize: 15))
                            ],
                          ),
                        ) : Container(),
                        kretaSuccessRate != null ?Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("${locText(context, key: "kreta_success_rate")}: ", style: TextStyle(fontSize: 15),),
                              Text("${(kretaSuccessRate * 100).round()}%" , style: TextStyle(fontSize: 15))
                            ],
                          ),
                        ) : Container()
                      ],
                    )
                ),
                Divider(),

                Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 12, left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("${locText(context, key: "website")}:", style: TextStyle(fontSize: 17),),
                        Hyperlink(AboutPage.website, Text(AboutPage.website, style: TextStyle(color: Colors.blueAccent, fontSize: 17, decoration: TextDecoration.underline),))
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
                          openFacebookPage();
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
                          if (await canLaunch(AboutPage.tw_site)) {
                            await launch(AboutPage.tw_site);
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
                          if (await canLaunch(AboutPage.dc_site)) {
                            await launch(AboutPage.dc_site);
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
                          if (await canLaunch(AboutPage.gh_site)) {
                            await launch(AboutPage.gh_site);
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
              ],
            )
          )
      ),
    );
  }
}
