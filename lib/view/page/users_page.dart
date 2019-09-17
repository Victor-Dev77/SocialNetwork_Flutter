import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social/models/user.dart';
import 'package:flutter_social/view/my_material.dart';
import 'package:flutter_social/util/fire_helper.dart';
import 'package:flutter_social/view/tiles/user_tile.dart';

class UsersPage extends StatefulWidget {

  _UsersState createState() => _UsersState();

}

class _UsersState extends State<UsersPage> {


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FireHelper().fire_user.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          List<DocumentSnapshot> documents = snapshot.data.documents;
          return NestedScrollView(
              headerSliverBuilder: (BuildContext build, bool scrolled) {
                return [MyAppBar(title: "Liste des utilisateurs", image: eventImage)];
              },
              body: ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    User user = User(documents[index]);
                    return UserTile(user);
                  }
              )
          );
        } else {
          return LoadingCenter();
        }
      },
    );
  }
}