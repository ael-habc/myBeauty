import 'package:flutter/material.dart';

import 'package:mybeautyadvisor/app_localizations.dart';
import 'package:mybeautyadvisor/components/defaultButton.dart';
import 'package:mybeautyadvisor/components/logo.dart';
import 'package:mybeautyadvisor/tools/myNavigator.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';




class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[

              //// Logo
              // ignore: missing_required_param
              Logo(
                height: SizeConfig.screenWidth * 0.42,
              ),

              // Buttons
              Column(
                children: <Widget>[
                  //* SignIn
                  DefaultButton(
                    text: AppLocalizations.of(context).translate('sign_in'),
                    width: SizeConfig.screenWidth * 0.7,
                    padding: 10,
                    fontSize: 20,
                    press: () {
                      // Go to SignIn
                      MyNavigator.goSignIn(context);
                    },
                  ),

                  //* Empty Space
                  SizedBox(height: 26),
            
                  //* SignUp
                  Container(
                    width: SizeConfig.screenWidth * 0.7,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                        side: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 1.5,
                        ),
                      ),
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          AppLocalizations.of(context).translate('sign_up'),
                          style: Theme.of(context).textTheme.headline2.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      onPressed: () {
                        // Go to Register
                        MyNavigator.goSignUp(context);
                      },
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}