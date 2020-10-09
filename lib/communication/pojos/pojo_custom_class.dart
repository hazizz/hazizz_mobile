import 'package:meta/meta.dart';
import 'dart:convert';

class PojoCustomClass {
	PojoCustomClass({
		@required this.id,
		@required this.recurrenceRule,
		@required this.start,
		@required this.end,
		@required this.wholeDay,
		@required this.periodNumber,
		@required this.title,
		@required this.description,
		@required this.host,
		@required this.location,
	});

	final int id;
	final String recurrenceRule;
	final String start;
	final String end;
	final bool wholeDay;
	final int periodNumber;
	final String title;
	final String description;
	final String host;
	final String location;

	factory PojoCustomClass.fromRawJson(String str) => PojoCustomClass.fromJson(json.decode(str));

	String toRawJson() => json.encode(toJson());

	factory PojoCustomClass.fromJson(Map<String, dynamic> json) => PojoCustomClass(
		id: json["id"],
		recurrenceRule: json["recurrenceRule"],
		start: json["start"],
		end: json["end"],
		wholeDay: json["wholeDay"],
		periodNumber: json["periodNumber"],
		title: json["title"],
		description: json["description"],
		host: json["host"],
		location: json["location"],
	);

	Map<String, dynamic> toJson() => {
		"id": id,
		"recurrenceRule": recurrenceRule,
		"start": start,
		"end": end,
		"wholeDay": wholeDay,
		"periodNumber": periodNumber,
		"title": title,
		"description": description,
		"host": host,
		"location": location,
	};
}