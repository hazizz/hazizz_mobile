import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
Future<void> openFacebookPage() async {
  String fbProtocolUrl;
  if (Platform.isIOS) {
    fbProtocolUrl = 'fb://profile/249412582404389';
  } else {
    fbProtocolUrl = 'fb://page/249412582404389';
  }
  const String fallbackUrl = "https://www.facebook.com/hazizzvelunk";
  try {
    bool launched = await launch(fbProtocolUrl, forceSafariVC: false);

    if (!launched) {
      await launch(fallbackUrl, forceSafariVC: false);
    }
  } catch (e) {
    await launch(fallbackUrl, forceSafariVC: false);
  }
}