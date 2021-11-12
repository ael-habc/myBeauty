import 'package:flutter/material.dart';
import 'package:mybeautyadvisor/app_localizations.dart';


class EmptyInventory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Text(
          AppLocalizations.of(context).translate('empty'),
          style: TextStyle(
            fontSize: 35,
            color: Theme.of(context).disabledColor,
          ),
        ),
      ),
    );
  }
}
