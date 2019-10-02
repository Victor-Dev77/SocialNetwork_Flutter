import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social/models/post.dart';
import 'package:flutter_social/models/user.dart';
import 'package:flutter_social/util/fire_helper.dart';
import 'package:flutter_social/view/my_material.dart';
import 'package:flutter_social/view/tiles/postTitle.dart';

class FeedPage extends StatefulWidget {

  String myId;
  FeedPage(this.myId);

  _FeedState createState() => _FeedState();

}

class _FeedState extends State<FeedPage> {

  StreamSubscription sub;
  List<Post> posts = [];
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    setupSub();
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
        headerSliverBuilder: (BuildContext build, bool scrolled) {
          return [MyAppBar(title: "Fil d'actualité", image: homeImage)];
        },
        body: ListView.builder(
            itemCount: posts.length,
            itemBuilder: (BuildContext context, int index) {
              Post post = posts[index];
              User user = users.singleWhere((u) => u.uid == post.userId);
              return PostTile(post: post, user: user, detail: false,);
            }
        )
    );
  }

  setupSub() {
    sub = FireHelper().fire_user.where(keyFollowers, arrayContains: widget.myId).snapshots().listen((datas) {
      getUsers(datas.documents);
      datas.documents.forEach((docs) {
        docs.reference.collection("posts").snapshots().listen((post) {
          setState(() {
            posts = getPosts(post.documents);
          });
        });
      });
    });
  }

  getUsers(List<DocumentSnapshot> userDocs) {
    List<User> myList = users;
    userDocs.forEach((u) {
      User user = User(u);
      if (myList.every((p) => p.uid != user.uid)) {
        myList.add(user);
      } else {
        User toBeChanged = myList.singleWhere((p) => p.uid == user.uid);
        myList.remove(toBeChanged);
        myList.add(user);
      }
    });
    setState(() {
      users = myList;
    });
  }

  List<Post> getPosts(List<DocumentSnapshot> postDocs) {
    List<Post> myList = posts;
    postDocs.forEach((p) {
      Post post = Post(p);
      if (myList.every((p) => p.documentID != post.documentID)) {
        myList.add(post);
      } else {
        Post toBeChanged = myList.singleWhere((p) => p.documentID == post.documentID);
        myList.remove(toBeChanged);
        myList.add(post);
      }
    });
    myList.sort((a, b) => b.date.compareTo(a.date));
    return myList;
  }


}

