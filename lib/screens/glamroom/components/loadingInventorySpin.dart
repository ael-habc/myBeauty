import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';



class LoadingInventorySpin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Loading Cub
    return Expanded(
      child: Center(
        child: SpinKitCircle(
          size: getProportionateScreenWidth(45),
          color: Theme.of(context).primaryColor,
        ),  
      ),
    );
  }
}