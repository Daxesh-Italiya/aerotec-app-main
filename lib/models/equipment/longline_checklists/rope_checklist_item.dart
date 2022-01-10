import 'package:flutter/foundation.dart';

class RopeChecklistItem {
  String name;
  bool yes;
  bool no;
  bool repair;
  bool replace;

  RopeChecklistItem({
    @required required this.name,
    @required required this.yes,
    @required required this.no,
    @required required this.repair,
    @required required this.replace
  });

}
