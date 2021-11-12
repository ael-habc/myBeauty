import 'package:flutter/material.dart';



class ProfilImageBorder extends StatelessWidget {
  final Widget    childWidget;
  final double    radius;

  ProfilImageBorder({
    @required this.childWidget,
              this.radius = 90,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: this.radius,
      backgroundColor: Theme.of(context).primaryColor,
      child: this.childWidget,
    );
  }
}
