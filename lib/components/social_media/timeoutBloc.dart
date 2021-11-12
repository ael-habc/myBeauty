import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mybeautyadvisor/app_localizations.dart';
import 'package:mybeautyadvisor/components/defaultButton.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';



class TimeoutBloc extends StatelessWidget {
  final Function    retryFunction;

  TimeoutBloc({
    @required this.retryFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                width: SizeConfig.screenWidth * 0.8,
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[

                    //// Icon
                    Icon(
                      CupertinoIcons.timer,
                      color: Theme.of(context).disabledColor,
                      size: 70,
                    ),

                    //// Empty Space
                    SizedBox(height: 40),

                    //// Message
                    Text(
                      AppLocalizations.of(context).translate('timeout'),
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).disabledColor,
                      ),
                    ),

                    //// Empty Space
                    SizedBox(height: 40),

                    //* Retry Button
                    DefaultButton(
                      text: AppLocalizations.of(context).translate('retry'),
                      width: SizeConfig.screenWidth * 0.3,
                      press: this.retryFunction,
                    ),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}