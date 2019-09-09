import 'package:flutter/material.dart';
import 'constants.dart';


class BottomBar extends BottomAppBar {

  BottomBar({@required List<Widget> items}) : super(
    color: baseAccent,
    shape: CircularNotchedRectangle(),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: items,
    ),
  );

}