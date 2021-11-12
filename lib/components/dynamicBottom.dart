import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mybeautyadvisor/components/littleLoadingSpin.dart';
import 'package:mybeautyadvisor/constants/consts.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';

import 'iconMessage.dart';



class DynamicButtom extends StatelessWidget {
  final LoadingState      state;
  final Widget            childWidget;
  final String            textSuccess;
  final String            textError;

  DynamicButtom({
    @required this.state,
    @required this.childWidget,
    @required this.textSuccess,
    @required this.textError
  });

  @override
  Widget build(BuildContext context) {
    Color   successColor = Theme.of(context).primaryColor;

    // Loading State
    if (state == LoadingState.loading)
      return LittleLoadingSpin();

    // Success State
    if (state == LoadingState.success)
      return IconMessage(
        text: textSuccess,
        width: SizeConfig.screenWidth * 0.7,
        iconData: CupertinoIcons.check_mark,
        color: successColor,
      );

    // Wrong State
    if (state == LoadingState.error)
      return IconMessage(
        text: textError,
        width: SizeConfig.screenWidth * 0.7,
        iconData: Icons.error,
        color: Colors.red,
      );
    
    return this.childWidget;
  }
}
