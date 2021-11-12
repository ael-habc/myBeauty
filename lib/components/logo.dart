import 'package:flutter/material.dart';



class Logo extends StatelessWidget {
  final double      height;
  final double      padding;

  Logo({
    @required this.height,
              this.padding = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(this.padding),
      height: this.height,
      child:
        ( Theme.of(context).brightness == Brightness.light ) ?
          Image.asset("assets/images/logo.png") :
          Image.asset("assets/images/logo_white.png"),
    );
  }
}