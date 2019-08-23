import 'package:flutter/widgets.dart';
import 'package:mobile/communication/pojos/PojoSubject.dart';

import '../hazizz_localizations.dart';

PojoSubject getEmptyPojoSubject(BuildContext context){
  return PojoSubject(0, locText(context, key: "without_subject"));
}