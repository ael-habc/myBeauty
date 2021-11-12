import 'package:flutter/material.dart';
import 'package:mybeautyadvisor/app_localizations.dart';
import 'package:mybeautyadvisor/components/bottomNavBar.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'package:mybeautyadvisor/providers/language.dart';
import 'package:mybeautyadvisor/providers/theme.dart';

import 'package:mybeautyadvisor/components/logoMBA.dart';
import 'package:mybeautyadvisor/constants/consts.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';
import 'components/settingsListItem.dart';


// Constants
//// Theme
const int     LIGHT = 0;
const int     DARK = 1;
//// Language
const int     AR = 0;
const int     FR = 1;
const int     ENG = 2;



class SettingsScreen extends StatelessWidget {

  // Get Language Index /////////////////////////////////////////////////
  int       languageIndex(LanguageProvider language) {
    if (language.appLocale == Locale('fr'))
      return FR;
    if (language.appLocale == Locale('en'))
      return ENG;
    return AR;
  }
  ///////////////////////////////////////////////////////////////////////


  @override
  Widget build(BuildContext context) {
    var       language = Provider.of<LanguageProvider>(context);
    var       theme = Provider.of<ThemeProvider>(context);
    Color     primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      //// App Bar
      appBar: AppBar(
        toolbarHeight: kToolBarHeight,
        // MBA Logo
        title: LogoMBA(),
      ),

      // Bottom Nav Bar
      bottomNavigationBar: BottomNavBar(selectedMenu: MenuState.account),

      //// Body
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ).copyWith(
          top: 30,
        ),
        child: ListView(
          children: <Widget>[
  
            //* Title Panel
            Text(
              AppLocalizations.of(context).translate('settings'),
              style: Theme.of(context).textTheme.headline1,
            ),
            SizedBox(height: getProportionateScreenHeight(40)),

            //* Buttons
            Column(
              children: <Widget>[

                Divider(),
                // Theme
                SettingsListItem(
                  text: AppLocalizations.of(context).translate('settings_theme'),
                  //* Switch Dark/Light Theme
                  childWidget: ToggleSwitch(
                    fontSize: 12,
                    minWidth: SizeConfig.screenWidth * 0.24,
                    initialLabelIndex: (theme.mode == ThemeMode.dark) ?
                      DARK :
                      LIGHT,
                    cornerRadius: 20.0,
                    activeFgColor: Colors.white,
                    inactiveBgColor: Colors.grey,
                    inactiveFgColor: Colors.white,
                    labels: [
                      AppLocalizations.of(context).translate('settings_theme_light'),
                      AppLocalizations.of(context).translate('settings_theme_dark'),
                    ],
                    icons: [
                      Icons.wb_sunny,
                      Icons.nights_stay,
                    ],
                    activeBgColors: [
                      [primaryColor],
                      [primaryColor],
                    ],
                    onToggle: (index) {
                      theme.toggleMode();
                    },
                    totalSwitches: 2,
                  ),
                ),
                Divider(),

                // Language
                SettingsListItem(
                  text: AppLocalizations.of(context).translate('settings_language'),
                  //* Switch Language
                  childWidget: ToggleSwitch(
                    fontSize: 12,
                    minWidth: SizeConfig.screenWidth * 0.16,
                    initialLabelIndex: languageIndex(language),
                    cornerRadius: 20.0,
                    activeFgColor: Colors.white,
                    inactiveBgColor: Colors.grey,
                    inactiveFgColor: Colors.white,
                    labels: [
                      'AR',
                      'FR',
                      'ENG',
                    ],
                    activeBgColors: [
                      [primaryColor],
                      [primaryColor],
                      [primaryColor],
                    ],
                    onToggle: (index) {
                      if (index == ENG)
                        language.changeLanguage(Locale('en'));
                      else if (index == FR)
                        language.changeLanguage(Locale('fr'));
                      else
                        language.changeLanguage(Locale('ar'));
                    },
                    totalSwitches: 3,
                  ),
                ),
                Divider(),

                // Version
                SettingsListItem(
                  text: AppLocalizations.of(context).translate('settings_version'),
                  // Show Version
                  childWidget: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      kAppStage + ' ' + kVersion,
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).disabledColor,
                      )
                    ),
                  ),
                ),
                Divider(),

              ],
            ),

          ],
        ),
      ),
    );
  }
}