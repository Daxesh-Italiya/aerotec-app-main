import 'package:flutter/foundation.dart';

class StandardChecklistItem {
  String name;
  bool yes;
  bool no;
  bool repair;
  bool remove;

  StandardChecklistItem({
    @required required this.name,
    @required required this.yes,
    @required required this.no,
    @required required this.repair,
    @required required this.remove,
  });
}
