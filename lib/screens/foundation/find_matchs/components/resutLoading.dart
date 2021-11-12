import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mybeautyadvisor/app_localizations.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';



class ResultLoading extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
          child: Padding(
            padding: EdgeInsets.all(
              getProportionateScreenWidth(30),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [

              // Loading Cub
              SpinKitFoldingCube(
                size: getProportionateScreenWidth(50),
                color: Theme.of(context).primaryColor,
              ),

              // Space
              SizedBox(height: SizeConfig.screenHeight * 0.15),

              // Animated Text
              SizedBox(
                height: SizeConfig.screenHeight * 0.2,
                child: DefaultTextStyle(
                  style: Theme.of(context).textTheme.headline1.copyWith(
                    fontSize: 20,
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      FadeAnimatedText(
                        AppLocalizations.of(context).translate('matchs_loading1'),
                        textAlign: TextAlign.center,
                      ),
                      FadeAnimatedText(
                        AppLocalizations.of(context).translate('matchs_loading2'),
                        textAlign: TextAlign.center,
                      ),
                      FadeAnimatedText(
                        AppLocalizations.of(context).translate('matchs_loading3'),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

            ],
        ),
          ),
      ),
    );
  }
}