import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/main_tab/main_tab_blocs.dart';
import 'package:mobile/blocs/other/custom_schedule_bloc.dart';
import 'package:mobile/managers/server_checker.dart';
import 'package:mobile/services/facebook_opener.dart';
import 'package:mobile/widgets/hazizz_back_button.dart';
import 'package:mobile/widgets/hyper_link.dart';
import 'package:mobile/widgets/listItems/class_item_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mobile/custom/hazizz_app_info.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:flutter/material.dart';

class ScheduleEditorPage extends StatefulWidget {
	String getTitle(BuildContext context){
		return localize(context, key: "about");
	}

	ScheduleEditorPage({Key key}) : super(key: key);

	@override
	_ScheduleEditorPage createState() => _ScheduleEditorPage();
}

class _ScheduleEditorPage extends State<ScheduleEditorPage> {

	_ScheduleEditorPage();



	@override
	void initState() {
		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
				appBar: AppBar(
					leading: HazizzBackButton(),
					title: Text(widget.getTitle(context)),
				),
				body: RefreshIndicator(

					onRefresh: (){
						MainTabBlocs().customScheduleBloc.add(CustomScheduleFetchEvent());
						return Future.value(true);
					},
					child: Stack(
							children: [
								ListView(),
								BlocBuilder(
									bloc: MainTabBlocs().customScheduleBloc,
									builder: (context, state){

										if(state is CustomScheduleLoadedState){
											return ListView.builder(itemBuilder: (context, index){
												return ClassItemWidget.custom(pojoCustomClass: state.customClasses[index]);
											});
										}

										return Center(child: Text("Nope"));


									},
								),
							]
					),
				),
				floatingActionButton: Column(
					mainAxisAlignment: MainAxisAlignment.end,
					children: [
						FloatingActionButton(
							heroTag: "add",
							child: Icon(FontAwesomeIcons.plus),
							onPressed: (){

							},
						),
						SizedBox(height: 10,),
						FloatingActionButton(
							heroTag: "save",
							child: Icon(FontAwesomeIcons.save),
							onPressed: (){

							},
						),
					],
				)
		);
	}
}
