import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _keyLangCode = "key_langCode";

String locText(BuildContext context, {@required String key, List<String> args}){
  return HazizzLocalizations.of(context).translate(key, args: args);
}

String locTextFromList(BuildContext context, {@required String key, @required int index}){
  return HazizzLocalizations.of(context).translateFromList(key: key, index: index);
}

getPreferredLocal() async{
  String preferredLangCode = (await getPreferredLangCode());
  print("log: preferredLangCode:  ${preferredLangCode}");
  if(preferredLangCode != null) {
    return Locale(preferredLangCode);
  }
  return null;
}

Future<String> getPreferredLangCode() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String langCode = prefs.getString(_keyLangCode);
  return langCode;
}

Future<void> setPreferredLangCode(String langCode) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(_keyLangCode, langCode);
  return;
}

class HazizzLocalizations {


  final Locale locale;

  HazizzLocalizations(this.locale);

  // Helper method to keep the code in the widgets concise
  // Localizations are accessed using an InheritedWidget "of" syntax
  static HazizzLocalizations of(BuildContext context) {
    return Localizations.of<HazizzLocalizations>(context, HazizzLocalizations);
  }

  Map<String, String> _localizedStrings;

  Future<bool> load() async {
    // Load the language JSON file from the "lang" folder
    String jsonString =
    await rootBundle.loadString('assets/langs/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  // This method will be called from every widget which needs a localized text
  String translate(String key, {@required List<String> args }) {
    String text = _localizedStrings[key];
    if(args == null) {
      return text;
    }

    for(int i = 0; i < args.length; i++) {
      text.replaceFirst(RegExp('{}'), args[i]);
    }
    return text;
  }

  String translateFromList({@required String key, @required int index}) {
    Map jsonList = jsonDecode(_localizedStrings[key]);
   // List asd = jsonList.map((i)=>i).toList();
    List<String> textList = jsonDecode(_localizedStrings[key]);
    String text = textList[index];
    /*
    jsonMap.map(
            (k, e) => MapEntry(
          k,
          (e as List)
              ?.map((e) => e == null
              ? null
              : e
              ?.toList()),
        );
            */
    return text;
  }

  // Static member to have a simple access to the delegate from the MaterialApp
  static const LocalizationsDelegate<HazizzLocalizations> delegate =
  _HazizzLocalizationsDelegate();

}

// LocalizationsDelegate is a factory for a set of localized resources
// In this case, the localized strings will be gotten in an AppLocalizations object
class _HazizzLocalizationsDelegate
    extends LocalizationsDelegate<HazizzLocalizations> {
  // This delegate instance will never change (it doesn't even have fields!)
  // It can provide a constant constructor.
  const _HazizzLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Include all of your supported language codes here
    return ['en', 'hu'].contains(locale.languageCode);
  }

  @override
  Future<HazizzLocalizations> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs
    HazizzLocalizations localizations = new HazizzLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_HazizzLocalizationsDelegate old) => false;
}