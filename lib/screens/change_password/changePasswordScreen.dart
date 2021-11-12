import 'package:flutter/material.dart';

import 'package:mybeautyadvisor/app_localizations.dart';
import 'package:mybeautyadvisor/components/bottomNavBar.dart';
import 'package:mybeautyadvisor/components/logoMBA.dart';
import 'package:mybeautyadvisor/constants/consts.dart';
import 'package:mybeautyadvisor/tools/myNavigator.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';

import 'components/passwordsForm.dart';



class ChangePasswordScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        // MBA App bar
        appBar: AppBar(
          toolbarHeight: kToolBarHeight,
          title: LogoMBA(),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              //* Go to Home
              MyNavigator.goHome(context);
            },
          ),
        ),
  
        // Bottom Nav Bar
        bottomNavigationBar: BottomNavBar(selectedMenu: MenuState.account),

        body: SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(40),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      //// Welcome Panel 
                      Text(
                        AppLocalizations.of(context).translate('change-password'),
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      SizedBox(height: getProportionateScreenHeight(60)),

                      //// Sign in Form
                      PasswordsForm(),

                    ],
                  ),
                ),
              ),
            ),
          ),
      ),
    );
  }
}
