import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FlutterErrorDetailItemWidget extends StatefulWidget {
	final FlutterErrorDetails flutterErrorDetails;
	
	final int index;

	FlutterErrorDetailItemWidget({Key key, @required this.flutterErrorDetails, @required this.index}) : super(key: key);

	@override
	_FlutterErrorDetailItemWidgetState createState()=> _FlutterErrorDetailItemWidgetState();
}

class _FlutterErrorDetailItemWidgetState extends State<FlutterErrorDetailItemWidget> {
	ExpandableController expandableController = ExpandableController();

	@override
	Widget build(BuildContext context){
		return Padding(
		  padding: const EdgeInsets.all(0),
		  child: Card(
				color: Colors.grey,
		    child: ExpandablePanel(
		    	controller: expandableController,
		    	header: Container(
					//	color: Colors.grey,
		    	  child: Row(
		    	  	children: <Widget>[
		    	  		Padding(
		    	  		  padding: const EdgeInsets.only(right: 8, left: 4),
		    	  		  child: Text((widget.index+1).toString(), style: TextStyle(fontSize: 36),),
		    	  		),

		    	  		Expanded(child: Text(widget.flutterErrorDetails.exceptionAsString())),
		    	  	],
		    	  ),
		    	),
		    //	collapsed: Text(widget.flutterErrorDetails.exceptionAsString()),
		    	expanded: Container(

						decoration: new BoxDecoration(
							borderRadius: BorderRadius.only(
								bottomLeft: Radius.circular(4),
								bottomRight: Radius.circular(4)
							),
							color: Theme.of(context).dialogBackgroundColor,
						),
		    	  /*RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),*/
		    	  child: Padding(
		    	    padding: const EdgeInsets.only(left: 4, right:4),
		    	    child: Column(
							children: <Widget>[
								Text(widget.flutterErrorDetails.stack.toString(),
									style: TextStyle(fontSize: 12),
								),
							/*	Row(
									mainAxisAlignment: MainAxisAlignment.end,
									children: <Widget>[
										IconButton(
											icon: Icon(FontAwesomeIcons.share),
											onPressed: (){

											},
										)
									],
								)
								*/
							],
						)
		    	  ),
		    	),
		      theme: ExpandableThemeData(

		    		hasIcon: true
		    	),

		    //	tapHeaderToExpand: true,
		    //	hasIcon: true,
		    ),
		  ),
		);
		return Container(
			child: Text(widget.flutterErrorDetails.stack.toString()),
		);
	}
	
	@override
  void dispose() {
    expandableController.dispose();
    super.dispose();
  }
}