import 'package:flutter_social/view/my_material.dart';
import 'package:flutter_social/util/date_helper.dart';

class Comment {
  String userId, text, date;

  Comment(Map<dynamic, dynamic> map) {
    userId = map[keyUid];
    text = map[keyText];
    date = DateHelper().myDate(map[keyDate]);
  }
}