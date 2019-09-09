import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_social/view/my_material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_social/util/fire_helper.dart';

class NewPost extends StatefulWidget {

  _NewPostState createState() => _NewPostState();

}

class _NewPostState extends State<NewPost> {

  TextEditingController _controller;
  File imageTaken;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: base,
      height: MediaQuery.of(context).size.height * 0.75,
      child: Container(
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))
        ),
        child: InkWell(
          onTap: (() => FocusScope.of(context).requestFocus(FocusNode())),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              PaddingWith(
                widget: MyText("Écrivez quelque chose...", color: baseAccent, fontSize: 30.0,),
                top: 25.0,
              ),
              PaddingWith(widget: Container(width: MediaQuery.of(context).size.width, height: 1.0, color: baseAccent,)),
              PaddingWith(
                widget: MyTextField(controller: _controller, hint: "Exprimez-vous", icon: writeIcon,),
                top: 25.0,
                right: 25.0,
                left: 25.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      IconButton(icon: camIcon, onPressed: (() => takePicture(ImageSource.camera))),
                      IconButton(icon: libraryIcon, onPressed: (() => takePicture(ImageSource.gallery))),
                    ],
                  ),
                  Container(
                    width: 75.0,
                    height: 75.0,
                    child: (imageTaken == null) ? MyText("Aucune image", fontSize: 13.0, color: baseAccent,) : Image.file(imageTaken),
                  ),
                ],
              ),
              ButtonGradient(callback: sendToFirebase, text: "Envoyer"),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> takePicture(ImageSource source) async {
    File image = await ImagePicker.pickImage(source: source, maxWidth: 500.0, maxHeight: 500.0);
    setState(() {
      imageTaken = image;
    });
  }

  sendToFirebase() {
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.pop(context);
    if(imageTaken != null || (_controller.text != null && _controller.text != "")) {
      FireHelper().addPost(me.uid, _controller.text, imageTaken);
    }
  }

}