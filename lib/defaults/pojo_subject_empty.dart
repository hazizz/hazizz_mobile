import 'package:flutter/widgets.dart';
import 'package:mobile/communication/pojos/PojoSubject.dart';

import 'package:mobile/custom/hazizz_localizations.dart';

PojoSubject getEmptyPojoSubject(BuildContext context){
  return PojoSubject(0, locText(context, key: "without_subject"), false, null, false);
}