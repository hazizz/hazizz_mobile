

// TODO rework this
class CacheData{
  DateTime lastUpdated;
  var json;

  dynamic data;

  Iterable iter;

  CacheData({ this.lastUpdated, this.json});

  CacheData.fromList({ this.lastUpdated, this.iter});

  setData(dynamic data){
    this.data = data;
  }
}


