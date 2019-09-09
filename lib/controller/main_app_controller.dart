import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_social/view/my_material.dart';
import 'package:flutter_social/util/fire_helper.dart';
import 'package:flutter_social/models/user.dart';
import 'package:flutter_social/view/page/feed_page.dart';
import 'package:flutter_social/view/page/new_post_page.dart';
import 'package:flutter_social/view/page/notif_page.dart';
import 'package:flutter_social/view/page/profil_page.dart';
import 'package:flutter_social/view/page/users_page.dart';

class MainAppController extends StatefulWidget {

  String uid;
  MainAppController(this.uid);

  _MainState createState() => _MainState();
}

class _MainState extends State<MainAppController> {

  StreamSubscription streamListener;
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  int index = 0;

  @override
  void initState() {
    super.initState();
    // Créer une souscription au stream
    streamListener = FireHelper().fire_user.document(widget.uid).snapshots().listen((document) {
      setState(() {
        me = User(document);

      });
    });
  }

  @override
  void dispose() {
    // Arrete le stream
    streamListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (me == null)
        ? LoadingScaffold()
        : Scaffold(
            key: _globalKey,
            backgroundColor: base,
            bottomNavigationBar: BottomBar(
                items: [
                  BarItem(icon: homeIcon, onPressed: (() => buttonSelected(0)), selected: index == 0),
                  BarItem(icon: friendsIcon, onPressed: (() => buttonSelected(1)), selected: index == 1),
                  Container(width: 0.0, height: 0.0,),
                  BarItem(icon: notifIcon, onPressed: (() => buttonSelected(2)), selected: index == 2),
                  BarItem(icon: profilIcon, onPressed: (() => buttonSelected(3)), selected: index == 3),
                ],
            ),
            body: showPage(),
            floatingActionButton: FloatingActionButton(onPressed: write, child: writeIcon, backgroundColor: pointer,),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        );
  }

  write() {
    _globalKey.currentState.showBottomSheet((builder) => NewPost());
  }

  buttonSelected(int index) {
    setState(() {
      this.index = index;
    });
  }

  Widget showPage() {
    switch(index) {
      case 0: return FeedPage();
      case 1: return UsersPage();
      case 2: return NotifPage();
      default: return ProfilPage(me);
    }
  }

}