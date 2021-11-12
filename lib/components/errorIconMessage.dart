import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class ErrorIconMessage extends StatelessWidget {
  final String    message;

  ErrorIconMessage({ @required this.message });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 14),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //* Exclamation Icon
          Icon(
            CupertinoIcons.exclamationmark_octagon,
            color: Colors.red,
            size: 15,
          ),
          //* Space
          SizedBox(width: 8),
          //* Message
          Text(
            this.message,
            style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: Colors.red,
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