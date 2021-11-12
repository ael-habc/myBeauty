import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mybeautyadvisor/app_localizations.dart';

import 'package:mybeautyadvisor/tools/sizeConfig.dart';
import 'package:mybeautyadvisor/components/logo.dart';

import 'components/signInForm.dart';




class SignInScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(40),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    //// Logo
                    // ignore: missing_required_param
                    Logo(
                      height: SizeConfig.screenHeight * 0.12,
                    ),
                    // Empty Space
                    SizedBox(
                      height: getProportionateScreenHeight(25)
                    ),

                    //// Welcome Panel 
                    Text(
                      AppLocalizations.of(context).translate('sign-in_headline'),
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    Text(
                      AppLocalizations.of(context).translate('sign-in_message'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    SizedBox(height: getProportionateScreenHeight(60)),

                    //// Sign in Form
                    SignInForm(),

                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}