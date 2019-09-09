import 'package:flutter/material.dart';
import 'loading_center.dart';

class LoadingScaffold extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: LoadingCenter()
      ),
    );
  }
}