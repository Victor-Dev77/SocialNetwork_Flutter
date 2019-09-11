import 'package:flutter/material.dart';
import 'package:flutter_social/util/fire_helper.dart';
import 'package:flutter_social/models/user.dart';
import 'package:flutter_social/view/my_material.dart';



class FollowButton extends FlatButton {

  FollowButton({@required User user}): super (
    child: MyText(me.following.contains(user.uid) ? "Ne plus suivre" : "Suivre", color: pointer,),
    onPressed: () {
      FireHelper().addFollow(user);
    }
  );

}

