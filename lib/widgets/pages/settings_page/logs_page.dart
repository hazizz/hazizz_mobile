import 'dart:io';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:logcat/logcat.dart';
import 'package:mobile/widgets/hazizz_back_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mobile/custom/hazizz_app_info.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:flutter/material.dart';

class LogsPage extends StatefulWidget {
  LogsPage({Key key}) : super(key: key);

  @override
  _LogsPage createState() => _LogsPage();
}

class _LogsPage extends State<LogsPage> {

  String logs = "none";
  File logFile;
  String filePath;

  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    Logcat.execute().then((String l){
      setState(() {
        logs = l;
        getTemporaryDirectory().then((directory){
          filePath = '${directory.path}/hazizz_logs.txt';

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
            title: Text("logs".localize(context)),
          ),
          body: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(controller: controller,
                  minLines: 1,
                  maxLines: 3,
                  decoration:  InputDecoration(
                    labelText: "tell_us_what_happened".localize(context),
                  ),
                ),
              ),
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
                    child: Text(localize(context, key: "send_log_via_email")),
                    onPressed: () async {

                      if(logFile != null){
                        final MailOptions mailOptions = MailOptions(
                          body: 'version: web\nbuildNumber: ${HazizzAppInfo().getInfo.buildNumber}\nstory: ${controller.text}',
                          subject: 'Hazizz Mobile log',
                          recipients: ['hazizzvelunk@gmail.com'],
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
}
