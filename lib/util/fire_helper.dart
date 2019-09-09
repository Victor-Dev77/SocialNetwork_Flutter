import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_social/view/my_material.dart';

class FireHelper {

  //AUTH
  final auth_instance = FirebaseAuth.instance;

  Future<FirebaseUser> signIn(String mail, String pwd) async {
    final FirebaseUser user = await auth_instance.signInWithEmailAndPassword(email: mail, password: pwd);
    return user;
  }

  Future<FirebaseUser> createAccount(String mail, String pwd, String name, String surname) async {
    final FirebaseUser user = await auth_instance.createUserWithEmailAndPassword(email: mail, password: pwd);
    // Créer mon user pour l'ajouter dans la bdd
    String uid = user.uid;
    List<dynamic> followers = [];
    List<dynamic> following = [uid];
    Map<String, dynamic> map = {
      keyName: name,
      keySurname: surname,
      keyImageUrl: "",
      keyFollowers: followers,
      keyFollowing: following,
      keyUid: uid,
    };
    addUser(uid, map);
    return user;
  }

  logOut() => auth_instance.signOut();



  //DATABASE
  static final data_instance = Firestore.instance;
  final fire_user = data_instance.collection("users");

  Stream<QuerySnapshot> postsFrom(String uid) => fire_user.document(uid).collection("posts").snapshots();

  addUser(String uid, Map<String, dynamic> map) {
    fire_user.document(uid).setData(map);
  }

  modifyUser(Map<String, dynamic> data) {
    fire_user.document(me.uid).updateData(data);
  }

  modifyPicture(File file) {
    StorageReference ref = storage_user.child(me.uid);
    addImage(file, ref).then((finalised) {
      Map<String, dynamic> data = {keyImageUrl: finalised};
      modifyUser(data);
    });
  }


  addPost(String uid, String text, File file) {
    int date = DateTime.now().millisecondsSinceEpoch.toInt();
    List<dynamic> likes = [];
    List<dynamic> comments = [];
    Map<String, dynamic> map = {
      keyUid: uid,
      keyLikes: likes,
      keyComments: comments,
      keyDate: date
    };
    if (text != null && text != "") {
      map[keyText] = text;
    }
    if (file != null) {
      StorageReference ref = storage_posts.child(uid).child(date.toString());
      addImage(file, ref).then((finalised) {
        String imageUrl = finalised;
        map[keyImageUrl] = imageUrl;
        fire_user.document(uid).collection("posts").document().setData(map);
      });
    } else {
      fire_user.document(uid).collection("posts").document().setData(map);
    }
  }


  //STORAGE
  static final storage_instance = FirebaseStorage.instance.ref();
  final storage_user = storage_instance.child("users");
  final storage_posts = storage_instance.child("posts");

  Future<String> addImage(File file, StorageReference ref) async {
    StorageUploadTask task = ref.putFile(file);
    StorageTaskSnapshot snapshot = await task.onComplete;
    String urlString = await snapshot.ref.getDownloadURL();
    return urlString;
  }

}