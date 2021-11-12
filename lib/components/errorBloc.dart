import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mybeautyadvisor/app_localizations.dart';
import 'package:mybeautyadvisor/components/defaultButton.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';



class ErrorBloc extends StatelessWidget {
  final String      message;
  final Function    retryFunction;

  ErrorBloc({
    @required this.message,
    @required this.retryFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: getProportionateScreenWidth(20),
            horizontal: getProportionateScreenWidth(40),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[

              //* Error Message
              Column(
                children: <Widget>[
                  //// Icon
                  Icon(
                    CupertinoIcons.exclamationmark_octagon_fill,
                    color: Colors.red,
                    size: 32,
                  ),
                  //// Empty Space
                  SizedBox(
                    height: getProportionateScreenHeight(20),
                  ),
                  //// Message
                  Text(
                    this.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),

              //* Retry Button
              DefaultButton(
                text: AppLocalizations.of(context).translate('retry'),
                width: SizeConfig.screenWidth * 0.5,
                press: this.retryFunction,
              ),

            ],
          ),
        ),
      ),
    );
  }
}