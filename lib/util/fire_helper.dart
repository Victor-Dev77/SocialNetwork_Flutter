import 'dart:io';

//import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_social/models/post.dart';
import 'package:flutter_social/models/user.dart';
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
    List<dynamic> followers = [uid];
    List<dynamic> following = [];
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
  final fire_notif = data_instance.collection("notifications");

  Stream<QuerySnapshot> postsFrom(String uid) => fire_user.document(uid).collection("posts").snapshots();

  addNotification(String from, String to, String text, DocumentReference ref, String type) {
    Map<String, dynamic> map = {
      keyUid: from,
      keyText: text,
      keyType: type,
      keyRef: ref,
      keySeen: false,
      keyDate: DateTime.now().millisecondsSinceEpoch.toInt()
    };
    fire_notif.document(to).collection("singleNotif").add(map);
  }

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

  addFollow(User other) {
    if (me.following.contains(other.uid)) {
      me.ref.updateData({keyFollowing: FieldValue.arrayRemove([other.uid])});
      other.ref.updateData({keyFollowers: FieldValue.arrayRemove([me.uid])});
    } else {
      me.ref.updateData({keyFollowing: FieldValue.arrayUnion([other.uid])});
      other.ref.updateData({keyFollowers: FieldValue.arrayUnion([me.uid])});
      addNotification(me.uid, other.uid, "${me.surname} a commencé à vous suivre", me.ref, keyFollowers);
    }
  }

  addLike(Post post) {
    if (post.likes.contains(me.uid)) {
      post.ref.updateData({keyLikes: FieldValue.arrayRemove([me.uid])});
    } else {
      post.ref.updateData({keyLikes: FieldValue.arrayUnion([me.uid])});
      addNotification(me.uid, post.userId, "${me.surname} a aimé votre post", post.ref, keyLikes);
    }
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
  
  addComment(DocumentReference ref, String text, String postOwner) {
    Map<dynamic, dynamic> map = {
      keyUid: me.uid,
      keyText: text,
      keyDate: DateTime.now().millisecondsSinceEpoch.toInt()
    };
    ref.updateData({keyComments: FieldValue.arrayUnion([map])});
    addNotification(me.uid, postOwner, "${me.surname} a commenté votre post", ref, keyComments);
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