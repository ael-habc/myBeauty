import 'package:flutter/material.dart';
import 'package:mybeautyadvisor/app_localizations.dart';
import 'package:mybeautyadvisor/tools/myNavigator.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';



class NoAccountText extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context).translate('sign-in_no_account'),
            style: Theme.of(context).textTheme.bodyText2.copyWith(
              fontSize: getProportionateScreenWidth(16)
            ),
          ),
          GestureDetector(
            onTap: () {
              MyNavigator.goSignUp(context);
            },
            child: Text(
              AppLocalizations.of(context).translate('sign_up'),
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                color: Theme.of(context).primaryColor,
                fontSize: getProportionateScreenWidth(15),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}