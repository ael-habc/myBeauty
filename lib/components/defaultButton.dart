import 'package:flutter/material.dart';
import 'package:mybeautyadvisor/constants/consts.dart';



class DefaultButton extends StatelessWidget {
  final Function    press;
  final double      fontSize;
  final double      padding;
  final double      margin;
  final double      width;
  final String      text;
  final Color       color;

  const DefaultButton({
    Key key,
    @required   this.text,
    @required   this.press,
                this.width,
                this.margin = 0,
                this.padding = 6,
                this.fontSize = 16,
                this.color = kPrimaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      margin: EdgeInsets.symmetric(vertical: this.margin),
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(this.fontSize - 3),
        ),
        color: color,
        onPressed: press,
        child: Padding(
          padding: EdgeInsets.all(this.padding),
          child: Text(
            text,
            style: Theme.of(context).textTheme.headline2.copyWith(
              fontSize: this.fontSize,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}