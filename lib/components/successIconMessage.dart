import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class SuccessIconMessage extends StatelessWidget {
  final String    message;

  SuccessIconMessage({ @required this.message });

  @override
  Widget build(BuildContext context) {
    Color   successColor = Theme.of(context).primaryColor;

    return Container(
      margin: EdgeInsets.only(top: 14),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //* Exclamation Icon
          Icon(
            CupertinoIcons.check_mark,
            color: successColor,
            size: 15,
          ),
          //* Space
          SizedBox(width: 8),
          //* Message
          Text(
            this.message,
            style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: successColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}