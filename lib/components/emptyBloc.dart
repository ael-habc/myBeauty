import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mybeautyadvisor/app_localizations.dart';
import 'package:mybeautyadvisor/components/defaultButton.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';



class EmptyBloc extends StatelessWidget {
  final String      message;

  EmptyBloc({
    @required this.message,
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

              //* Empty Message
              Text(
                this.message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                  fontSize: 22,
                ),
              ),

              //* Go back Button
              DefaultButton(
                text: AppLocalizations.of(context).translate('back'),
                color: Theme.of(context).disabledColor,
                width: SizeConfig.screenWidth * 0.4,
                press: () {
                  // Go back
                  Navigator.of(context).pop();
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}