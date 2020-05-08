import 'dart:convert';

Iterable getIterable(dynamic data){
  return jsonDecode(data).cast<Map<String, dynamic>>();
}
