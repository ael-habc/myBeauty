import 'package:flutter/material.dart';
import 'package:mybeautyadvisor/app_localizations.dart';



class OptionalPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context).translate('sign-up_optional-text'),
            style: Theme.of(context).textTheme.bodyText1.copyWith(
              fontSize: 12,
            ),
          ),
          Text(
            AppLocalizations.of(context).translate('sign-up_optional-mark'),
            style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}