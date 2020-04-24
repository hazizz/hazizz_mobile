import 'package:flutter/material.dart';
import 'dart:math';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/managers/preference_services.dart';
import 'package:mobile/pages/settings_page/about_page.dart';
import 'package:mobile/services/facebook_opener.dart';
import 'package:mobile/widgets/card_header_widget.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:url_launcher/url_launcher.dart';

enum AdType{
  fel_elek,
  facebook,
  giveaway,
  hazizz_meet
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
  static const String ad_giveaway = "assets/images/giveaway_ad_banner.png";
  static const String ad_hazizz_meet = "assets/images/hazizz_meet_ad_banner.png";

  double chance;
  int index;

  AdWidget.byChance({Key key, chance = 5}) : super(key: key){
    bool _show = false;

    int r = Random().nextInt(chance);

    if(r == 0){
      _show = true;
    }
    AdManager.allowed.add(_show);
    index = AdManager.allowed.length-1;
  }

  AdWidget({Key key, chance}) : super(key: key);

  @override
  _AdWidgetState createState() => _AdWidgetState();
}

class _AdWidgetState extends State<AdWidget> {

  AdType adType;

  void chooseType(){
    int r = Random().nextInt(4);
    if(r == 0){
      adType = AdType.fel_elek;
    }else if(r == 1){
      adType = AdType.facebook;
    }else{
      if(r == 2 && DateTime.now().isBefore(DateTime(2020, 04, 17, 23, 59))){
        adType = AdType.giveaway;
      }else if(r == 3
          && DateTime.now().isBefore(DateTime(2020, 04, 1, 23, 59))
          && DateTime.now().isAfter(DateTime(2020, 04, 1, 0, 0))
      ){
        adType = AdType.hazizz_meet;
      }
      else{
        int r2 = Random().nextInt(2);
        if(r2 == 0){
          adType = AdType.fel_elek;
        }else{
          adType = AdType.facebook;
        }
      }
    }
  }

  String chooseImage(){
    if(adType == AdType.facebook){
      return AdWidget.ad_facebook;
    }if(adType == AdType.fel_elek){
      return AdWidget.ad_fel_elek;
    }if(adType == AdType.giveaway){
      return AdWidget.ad_giveaway;
    }if(adType == AdType.hazizz_meet){
      return AdWidget.ad_hazizz_meet;
    }
  }

  String chooseUrl(){
    if(adType == AdType.facebook){
      return AboutPage.fb_site;
    }
    else{
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
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    if(adType == AdType.facebook
                    || adType == AdType.hazizz_meet
                    ){
                      openFacebookPage();
                      return;
                    }

                    String url;
                    if(adType == AdType.fel_elek){
                      url = "https://play.google.com/store/apps/details?id=com.hazizz.dusza2019";
                    }if(adType == AdType.giveaway){
                      url = "https://www.facebook.com/notes/h%C3%A1zizz/h%C3%A1zizz-nyerem%C3%A9nyj%C3%A1t%C3%A9k/489579875054324/";
                    }

                    if (await canLaunch(url)) {
                      await launch(url);
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