import 'dart:convert';


Iterable getIterable(dynamic data) => 
    PojoConverter.getIterable(data);

class PojoConverter{

 // T first<T>(List<T> ts) {
  static Iterable getIterable(dynamic data){
    return jsonDecode(data).cast<Map<String, dynamic>>();
  }

}