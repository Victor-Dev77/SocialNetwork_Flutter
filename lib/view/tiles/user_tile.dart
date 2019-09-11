import 'package:flutter/material.dart';
import 'package:flutter_social/view/my_material.dart';
import 'package:flutter_social/models/user.dart';
import 'package:flutter_social/view/page/profil_page.dart';

class UserTile extends StatelessWidget {

  User user;
  UserTile(this.user);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext ctx) {
              return Scaffold(
                backgroundColor: base,
                body: SafeArea(child: ProfilPage(user)),
              );
            }
        ));
      },
      child: Container(
        color: Colors.transparent,
        margin: EdgeInsets.all(2.5),
        child: Card(
          color: white,
          elevation: 5.0,
          child: Container(
            padding: EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    PaddingWith(widget: ProfileImage(urlString: user.imageUrl, onPressed: null), left: 5.0, bottom: 5.0, top: 5.0, right: 5.0,),
                    PaddingWith(widget: MyText("${user.surname} ${user.name}", color: baseAccent,), left: 5.0, bottom: 5.0, top: 5.0, right: 5.0,),
                  ],
                ),
                (user.uid == me.uid) ? Container(width: 0.0,) : FollowButton(user: user),
              ],
            ),
          ),
        ),
      ),
    );
  }

}