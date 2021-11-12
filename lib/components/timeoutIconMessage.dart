import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mybeautyadvisor/app_localizations.dart';


class TimeoutIconMessage extends StatelessWidget {
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
            CupertinoIcons.timer,
            color: Colors.grey,
            size: 16,
          ),
          //* Space
          SizedBox(width: 8),
          //* Message
          Text(
            AppLocalizations.of(context).translate('timeout'),
            style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}