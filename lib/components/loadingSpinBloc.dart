import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';


class LoadingSpinBloc extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: SpinKitFoldingCube(
          color: Theme.of(context).primaryColor,
          size: getProportionateScreenWidth(42),
        ),
      ),
    );
  }
}