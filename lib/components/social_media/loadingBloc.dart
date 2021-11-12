import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:mybeautyadvisor/tools/sizeConfig.dart';



class LoadingSpin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight,
      child: Center(
        child: SpinKitCircle(
          color: Theme.of(context).primaryColor,
          size: SizeConfig.screenWidth * 0.2,
        ),
      ),
    );
  }
}