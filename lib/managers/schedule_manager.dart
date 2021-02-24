import 'package:flutter/widgets.dart';
import 'package:mobile/communication/pojos/PojoSchedules.dart';
import 'file:///C:/Users/Erik/Projects/apps/hazizz_mobile2/lib/managers/cache_manager.dart';
import 'file:///C:/Users/Erik/Projects/apps/hazizz_mobile2/lib/managers/data_cache.dart';

class ScheduleManager{

	static void saveCache(PojoSchedules schedule, {@required int year, @required int weekNumber}){
		CacheManager.save("${year}_${weekNumber}_scheduleCache", schedule.toJson());// tasks.map((e) => e == null ? null : e.toJson())?.toList());
	}

	static Future<CacheData> loadCache({@required int year, @required int weekNumber}) async {
		CacheData dataCache = await CacheManager.load("${year}_${weekNumber}_scheduleCache");

		if(dataCache != null) {
			dataCache.setData(PojoSchedules.fromJson(dataCache.json));
		}
		return dataCache;
	}

	static Future forgetCache() async {
		await CacheManager.forgetCache("scheduleCache");
	}

}