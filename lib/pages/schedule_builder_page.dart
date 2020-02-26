import 'package:flutter/material.dart';
import 'package:mobile/communication/pojos/PojoClass.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/widgets/hazizz_back_button.dart';

class ScheduleBuilderPage extends StatefulWidget {
  ScheduleBuilderPage({Key key}) : super(key: key);

  @override
  _ScheduleBuilderPageState createState() => _ScheduleBuilderPageState();
}

class _ScheduleBuilderPageState extends State<ScheduleBuilderPage> {

  List<PojoClass> classes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: HazizzBackButton(),
        title: Text(locText(context, key: "schedule_editor")),
      ),

      body: ListView.builder(
        //  physics:  BouncingScrollPhysics(),
        cacheExtent: 100000000,
        addAutomaticKeepAlives: true,
        itemCount: classes.length+1,
        itemBuilder: (BuildContext context, int index) {

          return Container();
        }
    ),
    );
  }
}