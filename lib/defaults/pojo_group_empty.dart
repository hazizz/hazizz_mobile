import 'package:flutter/widgets.dart';
import 'package:mobile/communication/pojos/PojoGroup.dart';

import '../hazizz_localizations.dart';

PojoGroup getEmptyPojoGroup(BuildContext context){
  return PojoGroup(0, locText(context, key: "without_group"), null, null, 0);
}