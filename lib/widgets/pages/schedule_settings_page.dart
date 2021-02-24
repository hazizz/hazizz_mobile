import 'package:flutter/material.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import '../hazizz_back_button.dart';

class ScheduleSettingsPage extends StatefulWidget {
	ScheduleSettingsPage({Key key}) : super(key: key);

	@override
	_ScheduleSettingsPageState createState()=> _ScheduleSettingsPageState();
}

class _ScheduleSettingsPageState extends State<ScheduleSettingsPage> {

	String scheduleType;

	@override
  void initState() {
    scheduleType = "kreta";
    super.initState();
  }

	@override
	Widget build(BuildContext context){

		return Scaffold(
			appBar: AppBar(
				leading: HazizzBackButton(),
				title: Text("schedule_settings".localize(context)),
			),
			body: Column(children: <Widget>[
				ListTile(
					title: Text("default_schedule_type".localize(context)),
					trailing: DropdownButton(
						value: scheduleType,
						onChanged: (c){
							setState(() {
							  scheduleType = c;
							});
						},
						items: [
							DropdownMenuItem(value: "kreta",
								child: Text("kreta".localize(context)),
							),
							DropdownMenuItem(value: "custom",
								child: Text("custom".localize(context)),
							),

						],
					),
				),
				RaisedButton(
					onPressed: ()=> Navigator.pushNamed(context, "/schedule/settings/edit"),
					child: Text("edit_custom_schedule".localize(context)),
				)
			]),


		);
	}
}