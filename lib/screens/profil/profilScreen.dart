import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:provider/provider.dart';

import 'package:mybeautyadvisor/app_localizations.dart';

import 'package:mybeautyadvisor/providers/auth.dart';
import 'package:mybeautyadvisor/providers/user.dart';

import 'package:mybeautyadvisor/components/profilImageBorder.dart';
import 'package:mybeautyadvisor/components/profilImageEmpty.dart';
import 'package:mybeautyadvisor/components/profilListItem.dart';
import 'package:mybeautyadvisor/components/bottomNavBar.dart';

import 'package:mybeautyadvisor/constants/consts.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';
import 'package:mybeautyadvisor/tools/myNavigator.dart';

import 'components/profilHeader.dart';





class ProfilScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var     auth = Provider.of<AuthProvider>(context);
    var     user = Provider.of<UserProvider>(context).user;


    // Share With friend fonctionality //////////////////////////////////////////////////
    Future<void>    share() async {
      await FlutterShare.share(
        title: AppLocalizations.of(context).translate('share-title'),
        text: "My beauty adviser!",
        linkUrl: 'https://cosmecode.com/',
        chooserTitle: AppLocalizations.of(context).translate('share-chooserTitle'),
      );
    }
    /////////////////////////////////////////////////////////////////////////////////////


    return Scaffold(
      // Bottom Nav Bar
      bottomNavigationBar: BottomNavBar(selectedMenu: MenuState.account),

      // Body
      body: SafeArea(
        child: Column(
          children: <Widget>[

            //// Profil Header
            ProfilHeader(
              //* User Elegent profil (1 letter)
              imageWidget: ProfilImageBorder(
                childWidget: ProfilImageEmpty(
                  userName: user.name,
                ),
              ),
              //* Infos
              email: user.email,
              name: user.name
            ),

            //// Empty Space
            SizedBox(height: getProportionateScreenHeight(20)),

            //// Buttons
            Expanded(
              child: ListView(
                children: <Widget> [
                  //// Edit Profile
                  ProfilListItem(
                    icon: CupertinoIcons.pencil,
                    text: AppLocalizations.of(context).translate('edit-profil'),
                    onTap: () => MyNavigator.goEditProfile(context),
                  ),
                  //// Settings
                  ProfilListItem(
                    icon: CupertinoIcons.settings_solid,
                    text: AppLocalizations.of(context).translate('settings'),
                    onTap: () => MyNavigator.goSettings(context),
                  ),
                  //// Share with friends
                  ProfilListItem(
                    icon: CupertinoIcons.arrowshape_turn_up_right,
                    text: AppLocalizations.of(context).translate('share'),
                    onTap: share,
                  ),
                  //// help and Support
                  ProfilListItem(
                    icon: CupertinoIcons.question_circle,
                    text: AppLocalizations.of(context).translate('help-support'),
                    onTap: () => MyNavigator.goHelpSupport(context),
                  ),
                  //// Logout
                  // ProfilListItem(
                  //   icon: Icons.logout,
                  //   text: AppLocalizations.of(context).translate('logout'),
                  //   isButton: false,
                  //   onTap: () async {
                  //     //* Logout from APP Auth
                  //     auth.logout();
                  //     //* [Go Home] Pop until the first page of the app
                  //     Navigator.of(context).popUntil((route) => route.isFirst);
                  //   },
                  // ),

                ],
              ),
            )
              
          ],
        ),
      ),
    );
  }
}