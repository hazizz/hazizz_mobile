import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _keyLangCode = "key_langCode";

String locText2({@required BuildContext context, String key, List<String> args}){
  return AppLocalizations.of(context).tr(key,args: args);
}

String locTextPlural({@required BuildContext context, String key,@required String value}){
  return AppLocalizations.of(context).plural(key, value);
}

Future<Locale> getPreferredLocal2() async{
  String preferredLangCode = (await getPreferredLangCode2());
  print("log: preferredLangCode:  ${preferredLangCode}");
  if(preferredLangCode != null) {
    return Locale(preferredLangCode);
  }
  return null;
}

Locale getLocal(BuildContext context) {
  if(Localizations.localeOf(context).languageCode == "en") {
    return Locale("en");
  }else if(Localizations.localeOf(context).languageCode == "hu") {
    return Locale("hu");
  }
  return Locale("en");

}

Future<String> getPreferredLangCode2() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String langCode = prefs.getString(_keyLangCode);
  return langCode;
}

Future<void> setPreferredLangCode2(String langCode) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(_keyLangCode, langCode);
  return;
}

