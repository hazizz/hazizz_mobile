import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:mobile/blocs/kreta/selected_session_bloc.dart';
import 'package:mobile/blocs/main_tab/main_tab_blocs.dart';
import 'package:mobile/blocs/other/request_event.dart';
import 'package:mobile/blocs/other/response_states.dart';
import 'package:mobile/communication/connection.dart';
import 'package:mobile/communication/custom_response_errors.dart';
import 'package:mobile/communication/pojos/PojoSession.dart';
import 'package:mobile/communication/pojos/pojo_custom_class.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/blocs/kreta/schedule_event_bloc.dart';
import 'package:mobile/services/selected_session_helper.dart';
import 'package:mobile/storage/caches/data_cache.dart';
import 'package:mobile/extension_methods/duration_extension.dart';

//region CustomScheduleEditor bloc parts
//region CustomScheduleEditor events
abstract class CustomScheduleEditorEvent extends HEvent {
	CustomScheduleEditorEvent([List props = const []]) : super(props);
}

class CustomScheduleEditorFetchEvent extends CustomScheduleEditorEvent {
	final int yearNumber;
	final int weekNumber;

	final bool retry;

	CustomScheduleEditorFetchEvent({this.yearNumber, this.weekNumber, this.retry = false}) :  super([yearNumber, weekNumber]);
	@override
	String toString() => 'CustomScheduleEditorFetchEvent';
	@override
	List<Object> get props => [yearNumber, weekNumber];
}

class CustomScheduleEditorSetSessionEvent extends CustomScheduleEditorEvent {
	final DateTime dateTime;
	CustomScheduleEditorSetSessionEvent({this.dateTime}) :  super([dateTime]);
	@override
	String toString() => 'CustomScheduleEditorSetSessionEvent';
	List<Object> get props => [dateTime];
}
//endregion

//region CustomScheduleEditor states
abstract class CustomScheduleEditorState extends HState {
	CustomScheduleEditorState([List props = const []]) : super(props);
}

class CustomScheduleEditorInitialState extends CustomScheduleEditorState {
	@override
	String toString() => 'CustomScheduleEditorInitialState';
	List<Object> get props => null;
}

class CustomScheduleEditorWaitingState extends CustomScheduleEditorState {
	@override
	String toString() => 'CustomScheduleEditorWaitingState';
	List<Object> get props => null;
}



class CustomScheduleEditorLoadedState extends CustomScheduleEditorState {
	final List<PojoCustomClass> customClasses;

	CustomScheduleEditorLoadedState(this.customClasses) : assert(customClasses!= null);
	@override
	String toString() => 'CustomScheduleEditorLoadedState';
	List<Object> get props => [customClasses, DateTime.now()];
}

class CustomScheduleEditorLoadedCacheState extends CustomScheduleEditorState {
	final List<PojoCustomClass> customClasses;

	CustomScheduleEditorLoadedCacheState(this.customClasses) : assert(customClasses!= null);
	@override
	String toString() => 'CustomScheduleEditorLoadedCacheState';
	List<Object> get props => [SelectedSessionBloc().selectedSession];

}

class CustomScheduleEditorErrorState extends CustomScheduleEditorState {
	final HazizzResponse hazizzResponse;
	CustomScheduleEditorErrorState(this.hazizzResponse) : assert(hazizzResponse!= null), super([hazizzResponse]);

	@override
	String toString() => 'CustomScheduleEditorErrorState';
	List<Object> get props => [hazizzResponse];

}


//endregion

//region CustomScheduleEditor bloc
class CustomScheduleEditorBloc extends Bloc<CustomScheduleEditorEvent, CustomScheduleEditorState> {

	List<PojoSession> failedSessions = [];

	final ScheduleEventBloc scheduleEventBloc = ScheduleEventBloc();

//	int currentYearNumber = DateTime.now().year;
	int currentWeekNumber = 0;

	int currentCurrentWeekNumber;
//	int currentCurrentYearNumber;

//	DateTime currentWeekMonday = DateTime(0, 0, 0, 0, 0);
//	DateTime currentWeekSunday = DateTime(0, 0, 0, 0, 0);


	DateTime nowDate;

	DateTime selectedDate;

	CustomScheduleEditorBloc(){
		nowDate = DateTime.now();
		nowDate = nowDate.subtract(Duration(days: nowDate.weekday-1));

		selectedDate = nowDate;

		currentDayIndex = todayIndex;



	//	currentCurrentWeekNumber = _getWeekNumber(nowDate);

	//	currentCurrentYearNumber = nowDate.year;
		currentWeekNumber = currentCurrentWeekNumber;
	//	currentYearNumber = currentCurrentYearNumber;
	}

	DateTime lastUpdated = DateTime(0, 0, 0, 0, 0);

	PojoCustomClass customClasses;

	final int todayIndex = DateTime.now().weekday-1;
	int currentDayIndex;
	int fromCurrentWeek = 0;

	int _getYear(DateTime dateTime){
		return dateTime.year;
	}

	int _getWeekNumber(DateTime date){
		int dayOfYear = int.parse(DateFormat("D").format(date));
		return  ((dayOfYear - date.weekday + 10) / 7).floor();
	}


	bool get selectedWeekIsCurrent => fromCurrentWeek == 0;
	bool get selectedWeekIsPrevious => fromCurrentWeek == -1;
	bool get selectedWeekIsNext =>  fromCurrentWeek == 1;


	void nextWeek(){
		fromCurrentWeek++;
		selectedDate = selectedDate.add(7.days);

		int year = _getYear(selectedDate);
		int weekNumber = _getWeekNumber(selectedDate);

	//	MainTabBlocs().schedulesBloc.add(CustomScheduleEditorFetchEvent(yearNumber: year, weekNumber: weekNumber));
	}


	void previousWeek(){
		fromCurrentWeek--;
		selectedDate = selectedDate.subtract(7.days);
		print("slected date: $selectedDate");

		int year = _getYear(selectedDate);
		int weekNumber = _getWeekNumber(selectedDate);

	//	MainTabBlocs().schedulesBloc.add(CustomScheduleEditorFetchEvent(yearNumber: year, weekNumber: weekNumber));
	}

	@override
	CustomScheduleEditorState get initialState => CustomScheduleEditorInitialState();

	@override
	Stream<CustomScheduleEditorState> mapEventToState(CustomScheduleEditorEvent event) async* {
		if (event is CustomScheduleEditorFetchEvent) {
			try {

				yield CustomScheduleEditorWaitingState();

				currentDayIndex = todayIndex;

				HazizzLogger.printLog("event.yearNumber, event.weekNumber: ${event.yearNumber}, ${event.weekNumber}");

				/*
				if(currentWeekNumber == currentCurrentWeekNumber){
					DataCache dataCache = await loadCustomScheduleEditorCache(year: currentYearNumber, weekNumber: currentWeekNumber);
					if(dataCache!= null){
						lastUpdated = dataCache.lastUpdated;
						classes = dataCache.data;

						yield CustomScheduleEditorLoadedCacheState(classes ?? PojoCustomScheduleEditors({}));
					}
				}
				*/

				HazizzResponse hazizzResponse = await getResponse(
						GetCustomSchedule(),
						useSecondaryOptions: event.retry
				);

				if(hazizzResponse.isSuccessful){
					failedSessions = getFailedSessionsFromHeader(hazizzResponse.response.headers);

					List<PojoCustomClass> classes = hazizzResponse.convertedData;
					if(classes != null && classes.isNotEmpty){
						classes = hazizzResponse.convertedData;

						if(classes != null ){
							lastUpdated = DateTime.now();
							/*
							if(currentYearNumber == currentCurrentYearNumber && currentWeekNumber == currentCurrentWeekNumber) {
								saveCustomScheduleEditorCache(classes, year: currentYearNumber, weekNumber: currentWeekNumber);
							}
							*/
							yield CustomScheduleEditorLoadedState(classes);
						}

					}else{
						if(classes != null){
							yield CustomScheduleEditorLoadedCacheState(classes);

						}
					}
				}
				else if(hazizzResponse.isError){

					if(hazizzResponse.dioError == noConnectionError){
						yield CustomScheduleEditorErrorState(hazizzResponse);

						Connection.addConnectionOnlineListener((){
							this.add(CustomScheduleEditorFetchEvent());
						},
								"schedule_fetch"
						);

					}
					/*
					else if(hazizzResponse.dioError.type == DioErrorType.CONNECT_TIMEOUT
							|| hazizzResponse.dioError.type == DioErrorType.RECEIVE_TIMEOUT) {
						_failedRequestCount++;
						if(_failedRequestCount <= 1) {
							this.add(CustomScheduleEditorFetchEvent());
						}else{
							if(classes != null){
								yield CustomScheduleEditorLoadedCacheState(classes);
							}
						}
					}else{
						yield CustomScheduleEditorErrorState(hazizzResponse);
					}
					*/
				}
			} on Exception catch(e){
				HazizzLogger.printLog("log: Exception: ${e.toString()}");
			}
		}
	}

	void closeBloc(){
		scheduleEventBloc.close();
	}
}
//endregion
//endregion
