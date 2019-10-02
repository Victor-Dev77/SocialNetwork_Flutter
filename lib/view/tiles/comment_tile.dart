import 'package:flutter/material.dart';
import 'package:flutter_social/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_social/util/fire_helper.dart';
import 'package:flutter_social/view/my_material.dart';
import 'package:flutter_social/models/comment.dart';

class CommentTile extends StatelessWidget {

  Comment comment;

  CommentTile(this.comment);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FireHelper().fire_user.document(comment.userId).snapshots(),
      builder: (BuildContext ctx, AsyncSnapshot<DocumentSnapshot> snap) {
        if (snap.hasData) {
          User user = User(snap.data);
          return Container(
            color: white,
            margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        ProfileImage(urlString: user.imageUrl, onPressed: null, size: 15.0,),
                        MyText("${user.surname} ${user.name}", color: base,),
                      ],
                    ),
                    MyText(comment.date, color: pointer,)
                  ],
                ),
                MyText(comment.text, color: baseAccent,),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

}