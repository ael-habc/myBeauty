import 'package:flutter/material.dart';


class IconText extends StatelessWidget {
  final IconData    iconData;
  final String      text;
  final Color       color;

  IconText({
    @required this.iconData,
    @required this.text,
    @required this.color
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Icon
          Icon(
            this.iconData,
            color: this.color,
            size: 12,
          ),
          // Space
          SizedBox(width: 10),
          // Text
          Text(
            this.text,
            style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: this.color,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}