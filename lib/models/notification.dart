import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_social/view/my_material.dart';
import 'package:flutter_social/util/date_helper.dart';

class Notif {

  String text, date, userId, type;
  DocumentReference ref, notifRef;
  bool seen;

  Notif(DocumentSnapshot snap) {
    notifRef = snap.reference;
    Map<String, dynamic> map = snap.data;
    text = map[keyText];
    date = DateHelper().myDate(map[keyDate]);
    userId = map[keyUid];
    ref = map[keyRef];
    seen = map[keySeen];
    type = map[keyType];
  }

}