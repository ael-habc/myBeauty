import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:mybeautyadvisor/app_localizations.dart';
import 'package:mybeautyadvisor/models/User.dart';

import 'package:mybeautyadvisor/providers/user.dart';
import 'package:mybeautyadvisor/providers/auth.dart';

import 'package:mybeautyadvisor/screens/first_page/FirstScreen.dart';

import 'package:mybeautyadvisor/components/bottomNavBar.dart';
import 'package:mybeautyadvisor/components/darkLightSwitch.dart';
import 'package:mybeautyadvisor/components/logoMBA.dart';

import 'package:mybeautyadvisor/constants/consts.dart';
import 'package:mybeautyadvisor/tools/myNavigator.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';

import 'components/welcomePanel.dart';
import 'components/categoryCard.dart';





class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var             auth = Provider.of<AuthProvider>(context);

    // User not logged In
    if (auth.loggedInStatus != Status.LoggedIn)
      return FirstScreen();

    // User logged In (HOME)
    return LoggedScreen();
  }
}



class LoggedScreen extends StatefulWidget {
  @override
  _LoggedScreenState createState() => _LoggedScreenState();
}

class _LoggedScreenState extends State<LoggedScreen> {

  @override
  Widget build(BuildContext context) {
    User                  user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      // MBA App bar
      appBar: AppBar(
        toolbarHeight: kToolBarHeight,
        //* Redirect HOME
        title: LogoMBA(),
        //* Remove the previous button
        leading: Text(""),
        //* Theme Setting
        actions: <Widget> [
          DarkLightSwitch(),
        ],
      ),

      // Bottom Nav Bar
      bottomNavigationBar: BottomNavBar(selectedMenu: MenuState.home),

      // Body
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 30),
          child: Column(
            children: <Widget> [

              //// Welcome Panel
              WelcomePanel(
                greeting: AppLocalizations.of(context).translate('home_greeting'),
                headline: AppLocalizations.of(context).translate('home_headline'),
                username: user.name,
              ),
    
              //// White Space
              SizedBox(
                height: getProportionateScreenHeight(40),
              ),

              ///// Carousel
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget> [
                    GestureDetector(
                      child: CategoryCard(
                        imgPath: kImgFoundation,
                        title: AppLocalizations.of(context).translate('category_foundation'),
                      ),
                      onTap: () {
                        MyNavigator.goFoundation(context);
                      },
                    ),
                    // GestureDetector(
                    //   child: CategoryCard(
                    //     imgPath: kImgLipstick,
                    //     title: AppLocalizations.of(context).translate('category_lipstick'),
                    //   ),
                    //   onTap: () {
                    //     MyNavigator.goLipstick(context);
                    //   },
                    // ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}