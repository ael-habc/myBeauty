import 'package:flutter/material.dart';
import 'package:mybeautyadvisor/constants/consts.dart';


class IconMessage extends StatelessWidget {
  final IconData    iconData;
  final double      width;
  final double      margin;
  final double      padding;
  final String      text;
  final Color       color;
  final double      fontSize;

  const IconMessage({
    Key key,
    @required   this.iconData,
    @required   this.text,
                this.margin = 0,
                this.padding = 6,
                this.width = double.infinity,
                this.color = kPrimaryColor,
                this.fontSize = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      margin: EdgeInsets.symmetric(vertical: this.margin),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: this.color,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(this.padding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              this.iconData,
              color: this.color,
              size: this.fontSize * 1.2,
            ),
            SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                fontSize: this.fontSize,
                color: this.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}