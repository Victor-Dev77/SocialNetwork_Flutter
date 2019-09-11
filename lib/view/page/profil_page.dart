import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_social/models/post.dart';
import 'package:flutter_social/models/user.dart';
import 'package:flutter_social/util/alert_helper.dart';
import 'package:flutter_social/view/my_material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_social/util/fire_helper.dart';
import 'package:flutter_social/delegate/header_delegate.dart';
import 'package:flutter_social/view/tiles/postTitle.dart';
import 'package:image_picker/image_picker.dart';

class ProfilPage extends StatefulWidget {

  User user;

  ProfilPage(this.user);

  _ProfilState createState() => _ProfilState();

}

class _ProfilState extends State<ProfilPage> {

  bool _isMe = false;
  ScrollController controller;
  TextEditingController _name, _surname, _desc;
  double expanded = 200.0;
  bool get _showTitle {
    return controller.hasClients && controller.offset > expanded - kToolbarHeight;
  }
  StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    _isMe = (widget.user.uid == me.uid);
    controller =  ScrollController()..addListener(() {
      setState(() {

      });
    });
    _name = TextEditingController();
    _surname = TextEditingController();
    _desc = TextEditingController();
    subscription = FireHelper().fire_user.document(widget.user.uid).snapshots().listen((data) {
      setState(() {
        widget.user = User(data);
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    _name.dispose();
    _surname.dispose();
    _desc.dispose();
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FireHelper().postsFrom(widget.user.uid),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return LoadingCenter();
        } else {
          List<DocumentSnapshot> documents = snapshot.data.documents;
          return CustomScrollView(
             controller: controller,
             slivers: <Widget>[
               SliverAppBar(
                 pinned: true,
                 expandedHeight: expanded,
                 actions: <Widget>[
                   (_isMe)
                    ? IconButton(icon: settingsIcon, color: pointer, onPressed: () => AlertHelper().disconnect(context),)
                       : FollowButton(user: widget.user),

                 ],
                 flexibleSpace: FlexibleSpaceBar(
                   title: _showTitle ? MyText(widget.user.surname + " " + widget.user.name) : MyText(""),
                   background: Container(
                     decoration: BoxDecoration(
                       image: DecorationImage(image: profileImage, fit: BoxFit.cover),
                     ),
                     child: Center(
                       child: ProfileImage(urlString: widget.user.imageUrl, size: 75.0, onPressed: changeUser),
                     ),
                   ),
                 ),
               ),
               SliverPersistentHeader(
                 pinned: true,
                 delegate: MyHeader(user: widget.user, callback: changeFields, scrolled: _showTitle),
               ),
               SliverList(
                 delegate: SliverChildBuilderDelegate((BuildContext context, index) {
                    if (index == documents.length) {
                      return ListTile(title: MyText("Fin de liste"),);
                    }
                    if (index > documents.length) {
                      return null;
                    }
                    Post post = Post(documents[index]);
                    return PostTile(post: post, user: widget.user,);
                 }),
               ),
             ],
          );
        }
      },
    );
  }


  void changeFields() {
    AlertHelper().changeUserAlert(context, name: _name, surname: _surname, desc: _desc);
  }

  void changeUser() {
    if (widget.user.uid == me.uid) {
      showModalBottomSheet(context: context, builder: (BuildContext ctx) {
        return Container(
          color: Colors.transparent,
          child: Card(
            elevation: 5.0,
            margin: EdgeInsets.all(7.5),
            child: Container(
              color: base,
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  MyText("Modification de la photo de profil"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(icon: camIcon, onPressed: () {
                        takePicture(ImageSource.camera);
                        Navigator.pop(ctx);
                      }),
                      IconButton(icon: libraryIcon, onPressed: () {
                        takePicture(ImageSource.gallery);
                        Navigator.pop(ctx);
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      });
    }
  }

  Future<void> takePicture(ImageSource source) async {
    File file = await ImagePicker.pickImage(source: source, maxHeight: 300.0, maxWidth: 300.0);
    FireHelper().modifyPicture(file);
  }

  validate() {

  }

}
