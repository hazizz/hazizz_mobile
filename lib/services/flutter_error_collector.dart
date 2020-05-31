import 'package:flutter/foundation.dart';
import 'package:mobile/blocs/other/flush_bloc.dart';

class FlutterErrorCollector{

	static List<FlutterErrorDetails> errorDetailList = [];

	static void add(FlutterErrorDetails flutterErrorDetails){
		FlushBloc().add(FlushFlutterErrorEvent(flutterErrorDetails));
		errorDetailList.add(flutterErrorDetails);
	}

}