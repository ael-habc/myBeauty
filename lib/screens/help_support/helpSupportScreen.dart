import 'package:flutter/material.dart';
import 'package:mybeautyadvisor/app_localizations.dart';
import 'package:mybeautyadvisor/components/logoMBA.dart';
import 'package:mybeautyadvisor/constants/consts.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';
import 'components/helpSupportForm.dart';



class HelpSupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // MBA App bar
      appBar: AppBar(
        toolbarHeight: kToolBarHeight,
        title: LogoMBA(),
      ),

      // Body
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20
          ).copyWith(
            top: 30,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget> [
              
                //// Help & Support Panel
                Text(
                  AppLocalizations.of(context).translate('help-support'),
                  style: Theme.of(context).textTheme.headline1,
                ),
                SizedBox(height: 10),
                Text(
                  AppLocalizations.of(context).translate('help-support_description'),
                  style: Theme.of(context).textTheme.headline2.copyWith(
                    fontSize: 17,
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(60),
                ),

                //// Form Fields
                HelpSupportForm(),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
