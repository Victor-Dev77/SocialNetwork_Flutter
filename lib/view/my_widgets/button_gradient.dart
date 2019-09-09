import 'package:flutter/material.dart';
import 'package:flutter_social/view/my_material.dart';

class ButtonGradient extends Card {
  ButtonGradient(
      {double elevation: 7.5,
      @required VoidCallback callback,
      double width: 300.0,
      double height: 50.0,
      @required String text})
      : super(
          elevation: elevation,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(height / 2)),
          child: Container(
            width: width,
            height: height,
            decoration: MyGradient(
                startColor: baseAccent,
                endColor: base,
                radius: height / 2,
                horizontal: true),
            child: FlatButton(
              onPressed: callback,
              child: MyText(text),
            ),
          ),
        );
}


