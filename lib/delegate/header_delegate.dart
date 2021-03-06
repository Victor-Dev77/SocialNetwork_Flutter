import 'package:flutter/material.dart';
import 'package:flutter_social/view/my_material.dart';
import 'package:flutter_social/models/user.dart';


class MyHeader extends SliverPersistentHeaderDelegate {

  User user;
  VoidCallback callback;
  bool scrolled;

  MyHeader({@required this.user, @required this.callback, @required this.scrolled});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.0),
      padding: EdgeInsets.all(10.0),
      color: baseAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          (scrolled) ? Container(
            width: 0.0,
            height: 0.0,
          ) : element(context, "${user.surname} ${user.name}"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ProfileImage(urlString: user.imageUrl, onPressed: null),
              element(context, (user.description == null ? ("Aucune description") : user.description)),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 1.0,
            color: base,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              InkWell(child: MyText("Followers: ${user.followers.length - 1}"),),
              InkWell(child: MyText("Following: ${user.following.length}"),),
            ],
          ),
        ],
      ),
    );
  }

  Widget element(BuildContext context, String text) {
    if (user.uid == me.uid) {
      return InkWell(
        onTap: callback,
        child: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.25),
          child: MyText(text),
        ),
      );
    } else {
      return Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.25),
        child: MyText(text),
      );
    }
  }

  @override double get maxExtent => (scrolled) ? 150.0 : 200.0;

  @override double get minExtent => (scrolled) ? 150.0 : 200.0;

  @override bool shouldRebuild(MyHeader oldDelegate) => scrolled != oldDelegate.scrolled || user != oldDelegate.user;



}