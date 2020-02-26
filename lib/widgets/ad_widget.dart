import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/managers/preference_services.dart';
import 'package:mobile/pages/settings_page/about_page.dart';
import 'package:mobile/widgets/card_header_widget.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:url_launcher/url_launcher.dart';


enum AdType{
  fel_elek,
  facebook
}

Widget showAd(BuildContext context, {bool show = true, bool showHeader = false}){
  if(PreferenceService.enabledAd && show){
    if(showHeader) return StickyHeader(
      header: CardHeaderWidget(text: locText(context, key: "ad"),),
      content: AdWidget(),
    );
    return AdWidget();
  }
  return Container();
}

class AdManager{
  AdManager();

  int currentWidgetListLength;
  List<int> adIndexList = [];

  Widget a(int index, Widget widget){
    if(adIndexList.contains(index)){
      return Column(
        children: <Widget>[
          widget,
          AdWidget()
        ],
      );
    }
    return widget;
  }

  List<Widget> insertAds(List<Widget> widgets, {int chance = 5}){
    for(int i = 0; i < widgets.length; i++){
      int r = Random().nextInt(chance);
      if(r == 0){
        widgets.insert(i, null);
      }
    }
  }

  static final List<bool> allowed = [];
}

class AdWidget extends StatefulWidget {

  static const String ad_fel_elek = "assets/images/fel_elek_ad_banner.png";
  static const String ad_facebook = "assets/images/facebook_ad_banner.png";

  double chance;

  int index;

  AdWidget.byChance({Key key, chance = 5}) : super(key: key){
    bool _show = false;

    print("bánat: 0: $chance");
    int r = Random().nextInt(chance);
    print("bánat: 01: ${r}");
    if(r == 0){
      print("bánat: 0");
      _show = true;
    }
    AdManager.allowed.add(_show);
    index = AdManager.allowed.length-1;
  }

  AdWidget({Key key, chance}) : super(key: key){
  }

  @override
  _AdWidgetState createState() => _AdWidgetState();
}

class _AdWidgetState extends State<AdWidget> {

  AdType adType;

  void chooseType(){
    int r = Random().nextInt(2);
    print("asdasdasdw3rtu: $r");
    if(r == 1){
      adType = AdType.fel_elek;
    }else{
      adType = AdType.facebook;
    }
  }

  String chooseImage(){
    if(adType == AdType.facebook){
      return AdWidget.ad_facebook;
    }else{
      return AdWidget.ad_fel_elek;
    }
  }

  String chooseUrl(){
    if(adType == AdType.facebook){
      return AboutPage.fb_site;
    }else{
      return "https://play.google.com/store/apps/details?id=com.hazizz.dusza2019";
    }
  }

  @override
  void initState() {
    chooseType();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Material(
      elevation: 5,
      clipBehavior: Clip.antiAliasWithSaveLayer,
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: <Widget>[
            Image.asset(
              chooseImage(),
              fit: BoxFit.fitWidth,
            ),
           /* Container(
              color: Colors.grey,
              child: Text("AD"),
            ),*/
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    print("awe1");
                    if (await canLaunch(chooseUrl())) {
                      await launch(chooseUrl());
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}