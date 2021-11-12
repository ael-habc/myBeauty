import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mybeautyadvisor/constants/consts.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';

class SignLoadingSpin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenWidth(70),
      ),
      child: SpinKitFoldingCube(
        color: kPrimaryColor,
        size: getProportionateScreenWidth(42),
      ),
    );
  }
}