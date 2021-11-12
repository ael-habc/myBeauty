import 'package:flutter/material.dart';



class ButtonWithBorder extends StatelessWidget {
  final Widget    childWidget;
  final Function  onPress;
  final double    height;
  final double    width;
  final Color     color;

  ButtonWithBorder({
    @required   this.height,
    @required   this.width,
    @required   this.onPress,
    @required   this.childWidget,
    @required   this.color,
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: this.onPress,
      child: Container(
        width: this.width,
        height: this.height,
        padding: EdgeInsets.all(9),
        decoration: BoxDecoration(
          border: Border.all(
            color: this.color,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(13),
        ),
        child: this.childWidget,
      ),
    );
  }
}
