import 'package:package_info/package_info.dart';

class HazizzAppInfo{

  static final HazizzAppInfo _singleton = new HazizzAppInfo._internal();
  factory HazizzAppInfo() {
    return _singleton;
  }
  HazizzAppInfo._internal();

  PackageInfo _packageInfo;
  
  
  PackageInfo get getInfo{
    if(_packageInfo != null){
      return _packageInfo;
    }
    throw Exception("packageInfo was not initalized");
  }
  
  Future<void> initalize() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

}