import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mybeautyadvisor/app_localizations.dart';
import 'package:mybeautyadvisor/components/defaultButton.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';



class ErrorBloc extends StatelessWidget {
  final String      message;
  final Function    backFunction;

  ErrorBloc({
    @required this.message,
    @required this.backFunction,
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

                    //// Message
                    Text(
                      this.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),

                    //// Empty Space
                    SizedBox(height: 40),

                    //// Go back button
                    DefaultButton(
                      text: AppLocalizations.of(context).translate('back'),
                      press: this.backFunction,
                    )

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