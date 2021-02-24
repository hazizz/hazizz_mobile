import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'file:///C:/Users/Erik/Projects/apps/hazizz_mobile2/lib/managers/cache_manager.dart';
import 'file:///C:/Users/Erik/Projects/apps/hazizz_mobile2/lib/managers/data_cache.dart';

class TaskManager{

	static void saveCache(List<PojoTask> tasks){
		CacheManager.save("tasksCache", tasks.map((e) => e == null ? null : e.toJson())?.toList());
	}

	static Future<CacheData> loadCache() async {
		CacheData dataCache = await CacheManager.loadList("tasksCache");

		if(dataCache != null) {
			dataCache.setData(
					dataCache.iter.map<PojoTask>((json) => PojoTask.fromJson(json))
							.toList());
		}
		return dataCache;
	}

	static Future forgetCache() async {
		await CacheManager.forgetCache("tasksCache");
	}

}