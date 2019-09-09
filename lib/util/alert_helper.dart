import 'package:flutter/material.dart';
import 'package:flutter_social/view/my_material.dart';
import 'package:flutter/cupertino.dart';

import 'fire_helper.dart';

class AlertHelper {

  Future<void> error(BuildContext context, String error) async {
    MyText title = MyText("Erreur", color: Colors.black,);
    MyText subtitle = MyText(error, color: Colors.black,);
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext ctx) {
          return (Theme.of(context).platform == TargetPlatform.iOS)
              ? CupertinoAlertDialog(
                title: title,
                content: subtitle,
                actions: <Widget>[close(ctx, "OK")],
              )
              : AlertDialog(
                title: title, 
                content: subtitle,
                actions: <Widget>[close(ctx, "OK")],
              );
        }
    );
  }

  Future<void> disconnect (BuildContext context) async {
    MyText title = MyText("Voulez-vous vous déconnecter ?", color: base,);
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return (Theme.of(context).platform == TargetPlatform.iOS)
            ? CupertinoAlertDialog(title: title, actions: <Widget>[close(ctx, "NON"), disconnectBtn(ctx)],)
            : AlertDialog(title: title, actions: <Widget>[close(ctx, "NON"), disconnectBtn(ctx)],);
      }
    );
  }

  Future<void> changeUserAlert(BuildContext context, {@required TextEditingController name, @required TextEditingController surname, @required TextEditingController desc}) async {
    MyTextField nameTF = MyTextField(controller: name, hint: me.name,);
    MyTextField surnameTF = MyTextField(controller: surname, hint: me.surname,);
    MyTextField descTF = MyTextField(controller: desc, hint: me.description ?? "Aucune description",);
    MyText title = MyText("Changer les données de l'utilisateur", color: pointer,);
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return (Theme.of(context).platform == TargetPlatform.iOS)
              ? CupertinoAlertDialog(
                  title: title,
                  content: Column(children: <Widget>[nameTF, surnameTF, descTF],),
                  actions: <Widget>[
                      close(ctx, "Annuler"),
                    FlatButton(
                      child: MyText("Valider", color: Colors.blue,),
                      onPressed: () {
                        Map<String, dynamic> data = {};
                        if (name.text != null && name.text != "")
                          data[keyName] = name.text;
                        if (surname.text != null && surname.text != "")
                          data[keySurname] = surname.text;
                        if (desc.text != null && desc.text != "")
                          data[keyDescription] = desc.text;
                        FireHelper().modifyUser(data);
                        Navigator.pop(context);
                      },
                    ),
                   ],)
              : AlertDialog(
                title: title,
                content: Column(children: <Widget>[nameTF, surnameTF, descTF],),
                actions: <Widget>[
                  close(ctx, "Annuler"),
                  FlatButton(
                    child: MyText("Valider", color: Colors.blue,),
                    onPressed: () {
                      Map<String, dynamic> data = {};
                      if (name.text != null && name.text != "")
                        data[keyName] = name.text;
                      if (surname.text != null && surname.text != "")
                        data[keySurname] = surname.text;
                      if (desc.text != null && desc.text != "")
                        data[keyDescription] = desc.text;
                      FireHelper().modifyUser(data);
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
        }
    );
  }

  FlatButton disconnectBtn (BuildContext ctx) {
    return FlatButton(
      onPressed: () {
        FireHelper().logOut();
        Navigator.pop(ctx);
      },
      child: MyText("OUI", color: Colors.blue,),
    );
  }

  FlatButton close(BuildContext ctx, String text) {
    return FlatButton(
      onPressed: (() => Navigator.pop(ctx)),
      child: MyText(text, color: pointer,),
    );
  }

}