
import 'dart:io';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:mobile/custom/logcat/logcat-master/lib/logcat.dart';
import 'package:mobile/widgets/hazizz_back_button.dart';
import 'package:path_provider/path_provider.dart';

import 'package:mobile/custom/hazizz_app_info.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:flutter/material.dart';

class LogsPage extends StatefulWidget {

  String getTitle(BuildContext context){
    return locText(context, key: "logs");
  }


  LogsPage({Key key}) : super(key: key);

  @override
  _LogsPage createState() => _LogsPage();
}

class _LogsPage extends State<LogsPage> with AutomaticKeepAliveClientMixin {


  String logs = "none";
  File logFile;
  String filePath;

  @override
  void initState() {
    // widget.myGroupsBloc.dispatch(FetchData());


    Logcat.execute().then((String l){
      setState(() {
        logs = l;

        getTemporaryDirectory().then((directory){
          filePath = '${directory.path}/logs.txt';

          logFile = File(filePath);

          logFile.writeAsStringSync(logs);
        });
      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {


    return Hero(
      tag: "logs",
      child: Scaffold(
          appBar: AppBar(
            leading: HazizzBackButton(),
            title: Text(widget.getTitle(context)),
          ),
          body: Column(
            children: <Widget>[
              Text("length: ${logs.length.toString()} characters"),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Text(logs),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: RaisedButton(
                    child: Text(locText(context, key: "send_log_via_email")),
                    onPressed: () async {

                      if(logFile != null){
                        // final ByteData bytes = await rootBundle.load(logFile.path);
                        // await Share.file('Hazizz Mobile logs', 'hazizz_mobile_logs.txt', bytes.buffer.asUint8List(), 'text/txt', text: 'Hazizz Mobile logs');
                        final MailOptions mailOptions = MailOptions(

                          body: 'version: ${HazizzAppInfo().getInfo.version}\n buildNumber: ${HazizzAppInfo().getInfo.buildNumber}',
                          subject: 'Hazizz Mobile log',
                          recipients: ['hazizzvelunk@gmail.com'],
                          //  isHTML: true,
                          //  bccRecipients: ['other@example.com'],
                          // ccRecipients: ['third@example.com'],
                          attachments: [ filePath, ],
                        );

                        await FlutterMailer.send(mailOptions);

                      }
                    },
                  ),
                ),
              )
            ],
          )
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
