import 'package:mobile/services/flutter_error_collector.dart';
import 'package:mobile/widgets/hazizz_back_button.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:flutter/material.dart';
import 'package:mobile/widgets/listItems/flutter_error_detail_item_widget.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:mobile/extension_methods/duration_extension.dart';

class CaughtExceptionsPage extends StatefulWidget {
	final FlutterErrorDetails flutterErrorDetails;
	CaughtExceptionsPage({Key key, this.flutterErrorDetails}) : super(key: key);

	@override
	_FlutterErrorPage createState() => _FlutterErrorPage();
}

class _FlutterErrorPage extends State<CaughtExceptionsPage> {

	final ItemScrollController itemScrollController = ItemScrollController();
	final ItemPositionsListener itemPositionListener = ItemPositionsListener.create();

	@override
	void initState() {
		if(widget.flutterErrorDetails != null && FlutterErrorCollector.errorDetailList.isNotEmpty){
			try{
				int index = FlutterErrorCollector.errorDetailList.indexOf(widget.flutterErrorDetails);
				itemScrollController.scrollTo(index: index, duration: 400.milliseconds);
			}catch(e){}
		}
		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
				appBar: AppBar(
					leading: HazizzBackButton(),
					title: Text("caught_exceptions".localize(context)),
				),
				body: FlutterErrorCollector.errorDetailList.isNotEmpty
					? ScrollablePositionedList.builder(
							itemScrollController: itemScrollController,
							itemPositionsListener: itemPositionListener,
							itemCount: FlutterErrorCollector.errorDetailList.length,
							itemBuilder: (context, index){
								return FlutterErrorDetailItemWidget(flutterErrorDetails: FlutterErrorCollector.errorDetailList[index], index: index,);
							},
						)
					: Center(child: Text("No exception caught"))
		);
	}
}
