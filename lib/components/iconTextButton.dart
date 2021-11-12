import 'package:flutter/material.dart';
import 'package:mybeautyadvisor/constants/consts.dart';


class IconTextButton extends StatelessWidget {
  final Function    press;
  final IconData    iconData;
  final double      width;
  final double      margin;
  final double      padding;
  final String      text;
  final Color       textColor;
  final Color       color;
  final double      fontSize;

  const IconTextButton({
    Key key,
    @required   this.iconData,
    @required   this.press,
    @required   this.text,
                this.width,
                this.margin = 0,
                this.padding = 6,
                this.color = kPrimaryColor,
                this.textColor = Colors.white,
                this.fontSize = 16,
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
        color: this.color,
        onPressed: this.press,
        child: Padding(
          padding: EdgeInsets.all(this.padding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                this.iconData,
                color: this.textColor,
                size: this.fontSize * 1.2,
              ),
              SizedBox(width: 10),
              Text(
                text,
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                  fontSize: this.fontSize,
                  color: this.textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}