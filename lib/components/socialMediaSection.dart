import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:mybeautyadvisor/components/buttonWithBorder.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';

import 'dart:io' show Platform;



class SocialMediaSection extends StatelessWidget {
  final Map<String, Function>   onPress;

  SocialMediaSection({
    @required   this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Google
          // ButtonWithBorder(
          //   height: 40,
          //   width: getProportionateScreenWidth(/*(Platform.isIOS) ? 57 : */77),
          //   color: Theme.of(context).primaryColorLight,
          //   childWidget: SvgPicture.asset("assets/icons/google.svg"),
          //   onPress: onPress['google'],
          // ),
          // Facebook
          ButtonWithBorder(
            height: 40,
            width: getProportionateScreenWidth(/*(Platform.isIOS) ? 57 : */77),
            color: Theme.of(context).primaryColorLight,
            childWidget: SvgPicture.asset("assets/icons/facebook.svg"),
            onPress: onPress['facebook'],
          ),
          // apple
          //if (Platform.isIOS)
          //  ButtonWithBorder(
          //    height: 40,
          //    width: getProportionateScreenWidth(57),
          //    color: Theme.of(context).primaryColorLight,
          //    childWidget:
          //      SvgPicture.asset("assets/icons/apple.svg"),
          //    onPress: onPress['apple'],
          //  ),
        ],
      ),
    );
  }
}