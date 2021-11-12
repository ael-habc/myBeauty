import 'package:flutter/material.dart';
import 'package:mybeautyadvisor/app_localizations.dart';



class MatchsEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Container(
          child: Text(
            AppLocalizations.of(context).translate('empty'),
            style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: Theme.of(context).disabledColor,
              fontSize: 25,
            ),
          ),
        ),
      ),
    );
  }
}