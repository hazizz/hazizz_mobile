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
import 'file:///C:/Users/Erik/Projects/apps/hazizz_mobile2/lib/managers/data_cache.dart';
import 'package:mobile/extension_methods/duration_extension.dart';

//region CustomSchedule bloc parts
//region CustomSchedule events
abstract class CustomScheduleEvent extends HEvent {
	CustomScheduleEvent([List props = const []]) : super(props);
}

class CustomScheduleFetchEvent extends CustomScheduleEvent {
	final int yearNumber;
	final int weekNumber;

	final bool retry;

	CustomScheduleFetchEvent({this.yearNumber, this.weekNumber, this.retry = false}) :  super([yearNumber, weekNumber]);
	@override
	String toString() => 'CustomScheduleFetchEvent';
	@override
	List<Object> get props => [yearNumber, weekNumber];
}

class CustomScheduleAddClassEvent extends CustomScheduleEvent {
	final String recurrenceRule;
	final String start;
  final String end;
	final bool wholeDay;
	final int periodNumber;
	final String title;
	final String description;
	final String host;
	final String location;

	CustomScheduleAddClassEvent({this.recurrenceRule, this.start, this.end, this.wholeDay = false, this.periodNumber,
		this.title, this.description, this.host, this.location});

	@override
	String toString() => 'CustomScheduleAddClassEvent';
	@override
	List<Object> get props => [recurrenceRule, start, end, wholeDay, periodNumber, title, description, host, location];
}

class CustomScheduleRemoveClassEvent extends CustomScheduleEvent {
	final int customClassId;

	CustomScheduleRemoveClassEvent({this.customClassId});

	@override
	String toString() => 'CustomScheduleRemoveClassEvent';
	@override
	List<Object> get props => [customClassId];
}

//endregion

//region CustomSchedule states
abstract class CustomScheduleState extends HState {
	CustomScheduleState([List props = const []]) : super(props);
}

class CustomScheduleInitialState extends CustomScheduleState {
	@override
	String toString() => 'CustomScheduleInitialState';
	List<Object> get props => null;
}

class CustomScheduleWaitingState extends CustomScheduleState {
	@override
	String toString() => 'CustomScheduleWaitingState';
	List<Object> get props => null;
}



class CustomScheduleLoadedState extends CustomScheduleState {
	final List<PojoCustomClass> customClasses;

	CustomScheduleLoadedState(this.customClasses) : assert(customClasses!= null);
	@override
	String toString() => 'CustomScheduleLoadedState';
	List<Object> get props => [customClasses, DateTime.now()];
}

class CustomScheduleLoadedCacheState extends CustomScheduleState {
	final List<PojoCustomClass> customClasses;

	CustomScheduleLoadedCacheState(this.customClasses) : assert(customClasses!= null);
	@override
	String toString() => 'CustomScheduleLoadedCacheState';
	List<Object> get props => [SelectedSessionBloc().selectedSession];

}

class CustomScheduleErrorState extends CustomScheduleState {
	final HazizzResponse hazizzResponse;
	CustomScheduleErrorState(this.hazizzResponse) : assert(hazizzResponse!= null), super([hazizzResponse]);

	@override
	String toString() => 'CustomScheduleErrorState';
	List<Object> get props => [hazizzResponse];

}


//endregion

//region CustomSchedule bloc
class CustomScheduleBloc extends Bloc<CustomScheduleEvent, CustomScheduleState> {

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

	CustomScheduleBloc(){
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

		//	MainTabBlocs().schedulesBloc.add(CustomScheduleFetchEvent(yearNumber: year, weekNumber: weekNumber));
	}

	void previousWeek(){
		fromCurrentWeek--;
		selectedDate = selectedDate.subtract(7.days);
		print("slected date: $selectedDate");

		int year = _getYear(selectedDate);
		int weekNumber = _getWeekNumber(selectedDate);

		//	MainTabBlocs().schedulesBloc.add(CustomScheduleFetchEvent(yearNumber: year, weekNumber: weekNumber));
	}

	@override
	CustomScheduleState get initialState => CustomScheduleInitialState();

	@override
	Stream<CustomScheduleState> mapEventToState(CustomScheduleEvent event) async* {
		if (event is CustomScheduleFetchEvent) {
			try {
				yield CustomScheduleWaitingState();

				currentDayIndex = todayIndex;

				HazizzLogger.printLog("event.yearNumber, event.weekNumber: ${event.yearNumber}, ${event.weekNumber}");

				/*
				if(currentWeekNumber == currentCurrentWeekNumber){
					DataCache dataCache = await loadCustomScheduleCache(year: currentYearNumber, weekNumber: currentWeekNumber);
					if(dataCache!= null){
						lastUpdated = dataCache.lastUpdated;
						classes = dataCache.data;

						yield CustomScheduleLoadedCacheState(classes ?? PojoCustomSchedules({}));
					}
				}
				*/

				HazizzResponse hazizzResponse = await getResponse(
						GetCustomSchedule(),
						useSecondaryOptions: event.retry
				);

				if(hazizzResponse.isSuccessful){
					List<PojoCustomClass> classes = hazizzResponse.convertedData;
					if(classes != null && classes.isNotEmpty){
						classes = hazizzResponse.convertedData;

						if(classes != null ){
							lastUpdated = DateTime.now();
							/*
							if(currentYearNumber == currentCurrentYearNumber && currentWeekNumber == currentCurrentWeekNumber) {
								saveCustomScheduleCache(classes, year: currentYearNumber, weekNumber: currentWeekNumber);
							}
							*/
							yield CustomScheduleLoadedState(classes);
						}

					}else{
						if(classes != null){
							yield CustomScheduleLoadedCacheState(classes);
						}
					}
				}
				else if(hazizzResponse.isError){

					if(hazizzResponse.dioError == noConnectionError){
						yield CustomScheduleErrorState(hazizzResponse);

						Connection.addConnectionOnlineListener((){
							this.add(CustomScheduleFetchEvent());
						},
								"schedule_fetch"
						);

					}
					/*
					else if(hazizzResponse.dioError.type == DioErrorType.CONNECT_TIMEOUT
							|| hazizzResponse.dioError.type == DioErrorType.RECEIVE_TIMEOUT) {
						_failedRequestCount++;
						if(_failedRequestCount <= 1) {
							this.add(CustomScheduleFetchEvent());
						}else{
							if(classes != null){
								yield CustomScheduleLoadedCacheState(classes);
							}
						}
					}else{
						yield CustomScheduleErrorState(hazizzResponse);
					}
					*/
				}
			} on Exception catch(e){
				HazizzLogger.printLog("log: Exception: ${e.toString()}");
			}
		}
		if(event is CustomScheduleAddClassEvent){
			HazizzResponse hazizzResponse = await getResponse(
				CreateCustomClass(
					recurrenceRule: event.recurrenceRule,
					start: event.start, end: event.end, wholeDay: event.wholeDay,
					periodNumber: event.periodNumber, title: event.title, description: event.description,
					host: event.host, location: event.location
				)
			);

			if(hazizzResponse.isSuccessful){

			}
			else if(hazizzResponse.isError){

			}
		}
		else if(event is CustomScheduleRemoveClassEvent){
			HazizzResponse hazizzResponse = await getResponse(
					DeleteCustomClass(customClassId: event.customClassId)
			);

			if(hazizzResponse.isSuccessful){

			}
			else if(hazizzResponse.isError){

			}
		}
	}

	void closeBloc(){
		scheduleEventBloc.close();
	}
}
//endregion
//endregion
