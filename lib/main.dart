import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'controller/main_app_controller.dart';
import 'controller/log_controller.dart';
import 'package:flutter_social/view/my_material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Social',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        canvasColor: Colors.transparent,
        primaryColor: base,
        accentColor: baseAccent,
      ),
      home: _handleAuth(),
      debugShowCheckedModeBanner: false,
    );
  }

  // Vérifier si utilisateur est login ou non
  Widget _handleAuth(){
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        return (!snapshot.hasData) ? LogController() : MainAppController(snapshot.data.uid);
      },
    );
  }
}

// Supprime la class Home Page car home de MyApp lance _handleAuth qui lance LogController ou MainAppController