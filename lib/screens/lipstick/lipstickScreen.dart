import 'package:flutter/material.dart';
import 'package:mybeautyadvisor/app_localizations.dart';
import 'package:mybeautyadvisor/components/defaultButton.dart';
import 'package:mybeautyadvisor/components/logoMBA.dart';
import 'package:mybeautyadvisor/constants/consts.dart';
import 'package:mybeautyadvisor/tools/myNavigator.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';


class LipstickScreen extends StatelessWidget {

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            Center(
              child: Card(
                elevation: 5,
                shadowColor: Colors.black54,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  padding: EdgeInsets.all(
                     getProportionateScreenWidth(20),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget> [
                        Text(
                          AppLocalizations.of(context).translate('lipstick_coming-soon'),
                          style: Theme.of(context).textTheme.headline2.copyWith(
                            color: Theme.of(context).disabledColor,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(30),
                        ),
                        DefaultButton(
                          text: AppLocalizations.of(context).translate('lipstick_ok'),
                          press: () => MyNavigator.goHome(context),
                        ),
                      ],
                    ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
