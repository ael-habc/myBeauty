import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mybeautyadvisor/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:mybeautyadvisor/providers/user.dart';

import 'package:mybeautyadvisor/constants/consts.dart';
import 'package:mybeautyadvisor/components/logoMBA.dart';
import 'package:mybeautyadvisor/components/bottomNavBar.dart';

import 'components/inventory.dart';



class GlamroomScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // MBA App bar
      appBar: AppBar(
        toolbarHeight: kToolBarHeight,
        title: LogoMBA(),
      ),

      // Bottom Nav Bar
      bottomNavigationBar: BottomNavBar(selectedMenu: MenuState.glamroom),

      // Body
      body: SafeArea(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //* Welcome Panel
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ).copyWith(
                  top: 30,
                ),
                child: Text(
                  AppLocalizations.of(context).translate('glamroom_headline'),
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  AppLocalizations.of(context).translate('glamroom_title'),
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
              //* Inventory
              Inventory(
                user: Provider.of<UserProvider>(context).user,
              ),
            ],
          ),
        ),
    );
  }
}