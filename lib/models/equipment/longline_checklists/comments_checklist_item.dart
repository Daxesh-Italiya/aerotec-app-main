import 'package:flutter/foundation.dart';

class CommentsChecklistItem {
  String name;
  bool yes;
  bool no;
  bool repair;
  bool remove;
  String comments;

  CommentsChecklistItem({
    @required required this.name,
    @required required this.yes,
    @required required this.no,
    @required required this.repair,
    @required required this.remove,
    @required required this.comments,
  });
}
