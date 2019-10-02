import 'package:flutter/material.dart';
import 'package:flutter_social/util/fire_helper.dart';
import 'package:flutter_social/models/user.dart';
import 'package:flutter_social/view/my_material.dart';



class FollowButton extends IconButton {
  FollowButton({@required User user}): super (
    icon: me.following.contains(user.uid) ? unfollowIcon : followIcon,
    onPressed: () {
      FireHelper().addFollow(user);
    }
  );

}

