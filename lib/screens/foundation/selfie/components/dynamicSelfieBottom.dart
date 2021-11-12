import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mybeautyadvisor/app_localizations.dart';

import 'package:mybeautyadvisor/components/littleLoadingSpin.dart';
import 'package:mybeautyadvisor/constants/consts.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';

import 'package:mybeautyadvisor/components/iconMessage.dart';



class DynamicSelfieBottom extends StatelessWidget {
  final LoadingState      state;
  final Widget            childWidget;


  DynamicSelfieBottom({
    @required this.state,
    @required this.childWidget,
  });

  @override
  Widget build(BuildContext context) {
    Color   successColor = Theme.of(context).primaryColor;

    // Loading State
    if (state == LoadingState.loading)
      return LittleLoadingSpin();

    // Success State
    if (state == LoadingState.success)
      return Center(
        child: IconMessage(
          text: AppLocalizations.of(context).translate('take-picture_selfie_success'),
          width: SizeConfig.screenWidth * 0.75,
          iconData: CupertinoIcons.check_mark,
          color: successColor,
        ),
      );

    // Wrong State
    if (state == LoadingState.error)
      return Center(
        child: IconMessage(
          text: AppLocalizations.of(context).translate('take-picture_selfie_error'),
          width: SizeConfig.screenWidth * 0.75,
          iconData: Icons.error,
          color: Colors.red,
        ),
      );

    // Timeout State
    if (state == LoadingState.timeout)
      return Center(
        child: IconMessage(
          text: AppLocalizations.of(context).translate('timeout'),
          width: SizeConfig.screenWidth * 0.75,
          iconData: CupertinoIcons.timer,
          color: CupertinoColors.systemGrey,
        ),
      );

    return this.childWidget;
  }
}
