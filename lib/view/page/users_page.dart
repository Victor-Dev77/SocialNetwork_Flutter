import 'package:flutter/material.dart';
import 'package:flutter_social/models/user.dart';
import 'package:flutter_social/view/my_material.dart';

class UsersPage extends StatefulWidget {

  _UsersState createState() => _UsersState();

}

class _UsersState extends State<UsersPage> {


  @override
  Widget build(BuildContext context) {
    return Center(
      child: MyText("User"),
    );
  }
}