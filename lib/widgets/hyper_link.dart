import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

class Hyperlink extends StatelessWidget {
  final String _url;
  final Text _text;

  Hyperlink(this._url, this._text);

  _launchURL() async {
    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      throw 'Could not launch $_url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: _text,
      onTap: _launchURL,
    );
  }
}