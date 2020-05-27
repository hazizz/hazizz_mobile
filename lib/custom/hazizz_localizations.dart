import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/services/firebase_analytics.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'hazizz_logger.dart';

const _keyLangCode = "key_langCode";

extension LocTextExtension on String{
  String localize(BuildContext context, {List<String> args}){
    return HazizzLocalizations.of(context)?.translate(this, args: args);
  }
}

String localize(BuildContext context, {@required String key, List<String> args}){
  return HazizzLocalizations.of(context)?.translate(key, args: args);
}

Future<String> localizeWithoutContext({@required String key, List<String> args}) async {
  return await HazizzLocalizationsNoContext.translate(key, args: args);
}

Future<Locale> getPreferredLocale() async{
  String preferredLangCode = (await getPreferredLangCode());
  HazizzLogger.printLog("preferredLangCode:  ${preferredLangCode}");
  if(preferredLangCode != null) {
    return Locale(preferredLangCode,);
  }
  return null;//Locale("en", "EN");
}

setPreferredLocale(Locale preferredLocale) async{
  String preferredLangCode = preferredLocale.languageCode;
  if(preferredLangCode != null) {
    setPreferredLangCode(preferredLangCode);
  }
}

Future<String> getPreferredLangCode() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String langCode = prefs.getString(_keyLangCode);
  if(langCode == null) {
    langCode = "en";
  }
  return langCode;
}

Future<void> setPreferredLangCode(String langCode) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(_keyLangCode, langCode);
  return;
}

Future<String> getPreferredCountryCode() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String langCode = prefs.getString(_keyLangCode);
  if(langCode == null) {
    if(langCode == "en"){
      return "EN";
    }else if(langCode == "hu"){
      return "HU";
    }
  }
  return null;
}

List<Locale> supportedLocals = [Locale('en', "EN"), Locale('hu', "HU")];

List<Locale> getSupportedLocals() {
  return supportedLocals;
}

class HazizzLocalizationsNoContext{

  static Map<String, String> localizedStrings;

  static Future<bool> load() async {
    // Load the language JSON file from the "lang" folder
    String preferredLangCode = await getPreferredLangCode();
    String preferredCountryCode = await getPreferredCountryCode();
    String jsonString =
    await rootBundle.loadString('assets/langs/$preferredLangCode-$preferredCountryCode.json');

    Map<String, dynamic> jsonMap = json.decode(jsonString);

    localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  // This method will be called from every widget which needs a localized text
  static Future<String> translate(String key, {@required List<String> args }) async {

    String nullCheckAndReturn(String text){
      if(text == null){
        HazizzLogger.printLog("Error translating text for key \"" + key + "\"");
        FirebaseAnalyticsManager.logTranslationError(key: key, arguments: args, translatedText: text);
        return "ERROR: KEY NOT FOUND";
      }
      return text;
    }

    if(localizedStrings == null){
      await load();
    }

    String text = localizedStrings[key];
    if(args == null) {
      return nullCheckAndReturn(text);
    }

    try{
      for(int i = 0; i < args.length; i++) {
        text = text.replaceFirst(RegExp('{}'), args[i]);
      }
    }catch(e){
      FirebaseAnalyticsManager.logTranslationError(key: key, arguments: args, translatedText: text);
    }

    return nullCheckAndReturn(text);
  }
}

class HazizzLocalizations {
  Locale locale;

  HazizzLocalizations(this.locale);

  static HazizzLocalizations of(BuildContext context) {
    return Localizations.of<HazizzLocalizations>(context, HazizzLocalizations);
  }

  Map<String, String> _localizedStrings;

  Future<bool> load(Locale l) async {
    locale = l;
    String jsonString = await rootBundle.loadString('assets/langs/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  String translate(String key, {@required List<String> args }) {
    String nullCheckAndReturn(String text){
      if(text == null){
        HazizzLogger.printLog("Error translating text for key \"" + key + "\"");
        FirebaseAnalyticsManager.logTranslationError(key: key, arguments: args, translatedText: text);
        return "ERROR: KEY NOT FOUND";
      }
      return text;
    }

    String text = _localizedStrings[key];

    if(args == null) {
      return nullCheckAndReturn(text);
    }

    try{
      for(int i = 0; i < args.length; i++) {
        text = text.replaceFirst(RegExp('{}'), args[i]);
      }
    }catch(e){
      FirebaseAnalyticsManager.logTranslationError(key: key, arguments: args, translatedText: text);
    }
    return nullCheckAndReturn(text);
  }

  static const LocalizationsDelegate<HazizzLocalizations> delegate =
  _HazizzLocalizationsDelegate();

}

class _HazizzLocalizationsDelegate
    extends LocalizationsDelegate<HazizzLocalizations> {
  const _HazizzLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'hu'].contains(locale.languageCode);
  }

  @override
  Future<HazizzLocalizations> load(Locale locale) async {
    HazizzLocalizations localizations = new HazizzLocalizations(locale);
    await localizations.load(locale);
    return localizations;
  }

  @override
  bool shouldReload(_HazizzLocalizationsDelegate old) => false;
}