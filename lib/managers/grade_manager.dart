import 'package:mobile/communication/pojos/PojoGrades.dart';
import 'file:///C:/Users/Erik/Projects/apps/hazizz_mobile2/lib/managers/cache_manager.dart';
import 'file:///C:/Users/Erik/Projects/apps/hazizz_mobile2/lib/managers/data_cache.dart';

class GradeManager{

	static void saveCache(PojoGrades grades){
		CacheManager.save("gradesCache", grades.toJson());
	}

	static Future<CacheData> loadCache() async {
		CacheData dataCache = await CacheManager.load("gradesCache");

		if(dataCache != null) {
			dataCache.setData(PojoGrades.fromJson(dataCache.json));
		}
		return dataCache;
	}

	static Future forgetCache() async {
		await CacheManager.forgetCache("gradesCache");
	}

}