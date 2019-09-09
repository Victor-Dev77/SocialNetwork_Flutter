import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_social/view/my_material.dart';

class Post {

  DocumentReference ref;
  String documentID, id, text, userId, imageUrl;
  int date;
  List<dynamic> likes;
  List<dynamic> comments;

  Post(DocumentSnapshot snapshot) {
    ref = snapshot.reference;
    documentID = snapshot.documentID;
    Map<String, dynamic> map = snapshot.data;
    id = map[keyPostId];
    text = map[keyText];
    userId = map[keyUid];
    imageUrl = map[keyImageUrl];
    date = map[keyDate];
    likes = map[keyLikes];
    comments = map[keyComments];
  }


  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      keyPostId: id,
      keyUid: userId,
      keyDate: date,
      keyLikes: likes,
      keyComments: comments
    };
    if (text != null) {
      map[keyText] = text;
    }
    if (imageUrl != null) {
      map[keyImageUrl] = imageUrl;
    }
    return map;
  }


}