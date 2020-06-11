import 'package:mobile/blocs/kreta/grades_bloc.dart';
import 'package:mobile/blocs/kreta/schedule_bloc.dart';
import 'package:mobile/blocs/main_tab/main_tab_blocs.dart';
import 'package:mobile/blocs/tasks/tasks_bloc.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServerUrlManager{
	static const String _key_serverUrl = "_key_serverUrl";
	static const String BASE_URL_DEFAULT = "https://hazizz.duckdns.org:9000/";
	static const String BASE_URL_SECONDARY = "https://api2.hazizz.hu/";
	static String serverUrl = BASE_URL_DEFAULT;


	static Future<void> load() async {
		serverUrl = await getCustom();
	}

	static void switchToSecondary(){
		HazizzLogger.printLog("chagne the world. My final message. Goodbye");
		return;
		if(serverUrl != BASE_URL_SECONDARY){
			serverUrl = BASE_URL_SECONDARY;
			MainTabBlocs().tasksBloc.add(TasksFetchEvent());
			MainTabBlocs().schedulesBloc.add(ScheduleFetchEvent());
			MainTabBlocs().gradesBloc.add(GradesFetchEvent());
		}else{
			HazizzLogger.printLog("Already changed to secondary url");
		}
	}

	static Future<String> getCustom()async {
		SharedPreferences prefs = await SharedPreferences.getInstance();
		String str = prefs.get(_key_serverUrl);
		if(str != null){
			serverUrl = str;
			return str;
		}
		serverUrl = BASE_URL_DEFAULT;
		return BASE_URL_DEFAULT;
	}

	static void setCustom(String url)async {
		if(url == null){
			serverUrl = BASE_URL_DEFAULT;
		}else{
			SharedPreferences prefs = await SharedPreferences.getInstance();
			serverUrl = url;
			prefs.setString(_key_serverUrl, url);
		}
	}
}