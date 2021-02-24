import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/main_tab/main_tab_blocs.dart';
import 'package:mobile/blocs/other/custom_schedule_bloc.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/managers/server_checker.dart';
import 'package:mobile/services/facebook_opener.dart';
import 'package:mobile/widgets/hazizz_back_button.dart';
import 'package:mobile/widgets/hyper_link.dart';
import 'package:mobile/widgets/listItems/class_item_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mobile/custom/hazizz_app_info.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:flutter/material.dart';

import 'main_pages/main_schedules_tab_page.dart';

class ScheduleEditorPage extends StatefulWidget {
	ScheduleEditorPage({Key key}) : super(key: key);

	@override
	_ScheduleEditorPage createState() => _ScheduleEditorPage();
}

class _ScheduleEditorPage extends State<ScheduleEditorPage> with TickerProviderStateMixin{

	TabController _tabController;
	List<SchedulesTabPage> _tabList = [];


	_ScheduleEditorPage();

	List<BottomNavigationBarItem> bottomNavBarItems = [];

	@override
	void initState() {
		_tabController = TabController(vsync: this, length: _tabList.length, initialIndex: MainTabBlocs().schedulesBloc.todayIndex);

		super.initState();
	}

	@override
	void dispose() {
		_tabController?.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
				appBar: AppBar(
					leading: HazizzBackButton(),
					title: Text("my_schedule".localize(context)),
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

										return Center(child: Text("Még nincs custom órád"));
									},
								),
							]
					),
				),
				bottomNavigationBar: Container(
						color: Theme.of(context).primaryColorDark,
						child: BottomNavigationBar(
								currentIndex: MainTabBlocs().schedulesBloc.currentDayIndex,
								onTap: (int index){
									setState(() {
										MainTabBlocs().schedulesBloc.currentDayIndex = index;
										HazizzLogger.printLog("currentDayIndex: ${MainTabBlocs().schedulesBloc.currentDayIndex}");
										_tabController.animateTo(index);
										HazizzLogger.printLog("_tabController.index: ${_tabController.index}");
									});
								},
								items: bottomNavBarItems
						)
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
