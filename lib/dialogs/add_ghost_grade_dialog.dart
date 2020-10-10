/*Future<bool> showAddGradeDialog(context) async {
	double width = 280;
	double height = 90;

	int groupValue = 100;

	HazizzDialog h = HazizzDialog(
			header:
			Container(
					width: width,
					color: Theme.of(context).primaryColor,
					child: Padding(
						padding: const EdgeInsets.all(4.0),
						child: Text(localize(context, key: "add_grade"), style: TextStyle(fontSize: 22),),
					)
			),
			content: Container(
				child: Wrap(
					children: <Widget>[
						Column(
							children: <Widget>[
								Text(),
								Radio(
									value: 100,
									groupValue: groupValue,
									onChanged: (int val){

									},
								)
							],
						)
					],
				),
			),
			actionButtons:
			Row(
				mainAxisAlignment: MainAxisAlignment.end,
				children: <Widget>[
					FlatButton(
							child: Center(
								child: Text(
									localize(context, key: "add").toUpperCase(),
								),
							),
							onPressed: () {
								Navigator.of(context).pop();
							},
							color: Colors.transparent
					),
				],
			), height: height,width: width);
	return showDialog(context: context, barrierDismissible: true,
			builder: (BuildContext context) {
				return h;
			}
	);
}
*/
import 'package:mobile/extension_methods/duration_extension.dart';
import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/communication/pojos/PojoGrade.dart';
import 'package:mobile/enums/grade_type_enum.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'dialog_collection.dart';

class AddGradeDialog extends StatefulWidget {
	final String subject;

	AddGradeDialog({Key key, @required this.subject}) : super(key: key);

	@override
	_AddGradeDialog createState() => new _AddGradeDialog();
}

class _AddGradeDialog extends State<AddGradeDialog> {

	static const double width = 280;
	static const double height = 170;

	int groupValueWeight = 100;

	int currentGrade = 5;

	@override
	Widget build(BuildContext context) {
		return Stack(
		  children: <Widget>[
		  	Center(
		  	  child: Animator(
						tween: Tween<Offset>(begin: Offset(60, -height/2+45),  end: Offset(60, -MediaQuery.of(context).size.height/2 )),
						duration: 2000.milliseconds,
						cycles: 1,
						builder: (BuildContext context, AnimatorState animatorState, Widget child){
							return Transform.translate(
									offset: animatorState.value,
									child: Animator(
										tween: Tween<double>(begin:1, end: 0),
										duration: 2000.milliseconds,
										cycles: 1,
										builder: (BuildContext context2, AnimatorState animatorState2, Widget child2){
											return Opacity(
												opacity: animatorState2.value,
												child: Icon(FontAwesomeIcons.ghost, size: 60,)
											);
										},
									)
							);
						}
					),
				),
		    HazizzDialog(
		    		header:
		    		Container(
							width: width,
							color: Theme.of(context).primaryColor,
							child: Center(
								child: Padding(
								  padding: const EdgeInsets.only(top: 1, bottom:2),
								  child: Text(localize(context, key: "add_grade"), style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),),
								),
							)
		    		),
		    		content: Container(
		    			child: Column(
								crossAxisAlignment: CrossAxisAlignment.center,
		    				children: <Widget>[
									Row(
										mainAxisAlignment: MainAxisAlignment.center,
									  children: <Widget>[
									    Text("grade".localize(context) + ":  "),
		    					DropdownButton(
		    						value: currentGrade,
		    						onChanged: (value){
		    							setState(() {
		    								currentGrade = value;
		    							});
		    						},
		    						items: [
		    							DropdownMenuItem(child: Text("5", style: TextStyle(fontSize: 20),), value: 5),
		    							DropdownMenuItem(child: Text("4", style: TextStyle(fontSize: 20)), value: 4),
		    							DropdownMenuItem(child: Text("3", style: TextStyle(fontSize: 20)), value: 3),
		    							DropdownMenuItem(child: Text("2", style: TextStyle(fontSize: 20)), value: 2),
		    							DropdownMenuItem(child: Text("1", style: TextStyle(fontSize: 20)), value: 1),
		    						],
		    					),
									  ],
									),
		    					Text("weight".localize(context) + ":"),
									Wrap(
		    						children: <Widget>[
		    							Column(
		    								children: <Widget>[
		    									Text("50%"),
		    									Radio(
		    										value: 50,
		    										groupValue: groupValueWeight,
		    										onChanged: (int val){
		    											setState(() {
		    												groupValueWeight = val;
		    											});
		    										},
		    									),
		    								],
		    							),
		    							Column(
		    							  children: <Widget>[
		    							    Text("100%"),
		    							    Radio(
		    							    	value: 100,
		    							    	groupValue: groupValueWeight,
		    							    	onChanged: (int val){
		    							    		setState(() {
		    							    			groupValueWeight = val;
		    							    		});
		    							    	},
		    							    ),
		    							  ],
		    							),
		    							Column(
		    							  children: <Widget>[
		    							    Text("150%"),
		    							    Radio(
		    							    	value: 150,
		    							    	groupValue: groupValueWeight,
		    							    	onChanged: (int val){
		    							    		setState(() {
		    							    			groupValueWeight = val;
		    							    		});
		    							    	},
		    							    ),
		    							  ],
		    							),
		    							Column(
		    							  children: <Widget>[
		    							    Text("200%"),
		    							    Radio(
		    							    	value: 200,
		    							    	groupValue: groupValueWeight,
		    							    	onChanged: (int val){
		    							    		setState(() {
		    							    			groupValueWeight = val;
		    							    		});
		    							    	},
		    							    ),
		    							  ],
		    							),
		    							Column(
		    							  children: <Widget>[
		    							    Text("300%"),
		    							    Radio(
		    							    	value: 300,
		    							    	groupValue: groupValueWeight,
		    							    	onChanged: (int val){
		    							    		setState(() {
		    							    			groupValueWeight = val;
		    							    		});
		    							    	},
		    							    ),
		    							  ],
		    							)
		    						],
		    					)
		    				],
		    			)
		    		),
		    		actionButtons:
		    		Row(
		    			mainAxisAlignment: MainAxisAlignment.end,
		    			children: <Widget>[
		    				FlatButton(
		    						child: Center(
		    							child: Text(
		    								localize(context, key: "close").toUpperCase(), style: TextStyle(color: Colors.red),
		    							),
		    						),
		    						onPressed: () {
		    							Navigator.of(context).pop();
		    						},
		    						color: Colors.transparent
		    				),
		    				FlatButton(
		    						child: Center(
		    							child: Text(
		    								localize(context, key: "add").toUpperCase(),
		    							),
		    						),
		    						onPressed: () {
		    							Navigator.of(context).pop(
		    									PojoGrade(creationDate: DateTime.now(), date: DateTime.now(),
		    										grade: currentGrade.toString(), weight: groupValueWeight, subject: widget.subject,
		    										gradeType: GradeTypeEnum.MIDYEAR, topic: "ghost_grade".localize(context), accountId: "ghost"
		    									)
		    							);
		    						},
		    						color: Colors.transparent
		    				),
		    			],
		    		), height: height,width: width),
		  ],
		);
	}
}