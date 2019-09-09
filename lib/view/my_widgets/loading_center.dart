import 'package:flutter/material.dart';
import 'package:flutter_social/view/my_material.dart';

class LoadingCenter extends Center {

  LoadingCenter() : super(
    child: MyText("Chargement...", fontSize: 40.0, color: baseAccent,),
  );

}