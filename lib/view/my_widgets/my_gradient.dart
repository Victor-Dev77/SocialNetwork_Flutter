import 'package:flutter/material.dart';

class MyGradient extends BoxDecoration {

  static final FractionalOffset begin = FractionalOffset(0.0, 0.0);
  static final FractionalOffset endHorizontal = FractionalOffset(1.0, 0.0);
  static final FractionalOffset endVertical = FractionalOffset(0.0, 1.0);

  MyGradient(
      {@required Color startColor,
      @required Color endColor,
      bool horizontal: false,
      double radius: 0.0}) : super(
        gradient: LinearGradient(
            colors: [startColor, endColor],
            begin: begin,
            end: (horizontal) ? endHorizontal : endVertical,
            tileMode: TileMode.clamp,
        ),
        borderRadius: BorderRadius.all(Radius.circular(radius)));
}
