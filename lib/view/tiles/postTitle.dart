import 'package:flutter/material.dart';
import 'package:flutter_social/models/post.dart';
import 'package:flutter_social/models/user.dart';
import 'package:flutter_social/view/my_material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PostTile extends StatelessWidget {
  final Post post;
  final User user;
  final bool detail;

  PostTile(
      {@required Post this.post,
      @required User this.user,
      bool this.detail: false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.0),
      child: Card(
        elevation: 5.0,
        child: PaddingWith(
          top: 10.0, left: 10.0, right: 10.0, bottom: 10.0,
            widget: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ProfileImage(urlString: user.imageUrl, onPressed: null),
                Column(
                  children: <Widget>[
                    MyText(
                      "${user.surname} ${user.name}",
                      color: baseAccent,
                    ),
                    MyText(
                      "${post.date}",
                      color: pointer,
                    ),
                  ],
                ),
              ],
            ),
            (post.imageUrl != null && post.imageUrl != "")
              ? PaddingWith(widget: Container(width: MediaQuery.of(context).size.width, height: 1.0, color: baseAccent,),)
            : Container(height: 0.0,),
            (post.imageUrl != null && post.imageUrl != "")
              ? PaddingWith(widget: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  image: DecorationImage(image: CachedNetworkImageProvider(post.imageUrl), fit: BoxFit.cover),),
            )) : Container(height: 0.0,),
            (post.text != null && post.text != "")
             ? PaddingWith(widget: Container(width: MediaQuery.of(context).size.width, height: 1.0, color: baseAccent,),)
             : Container(height: 0.0,),
            (post.text != null && post.text != "")
             ? PaddingWith(widget: MyText(post.text, color: baseAccent,))
                : Container(height: 0.0,),
            PaddingWith(widget: Container(width: MediaQuery.of(context).size.width, height: 1.0, color: baseAccent,),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(icon: (post.likes.contains(me.uid) ? likeFull : likeEmpty), onPressed: null,),
                MyText(post.likes.length.toString(), color: baseAccent,),
                IconButton(icon: msgIcon, onPressed: null,),
                MyText(post.comments.length.toString(), color: baseAccent,),
              ],
            ),
          ],
        )),
      ),
    );
  }
}
