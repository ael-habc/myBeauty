import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:mybeautyadvisor/tools/sizeConfig.dart';




// Border Radius Constant
double    kRadius = getProportionateScreenWidth(160);


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Theme.of(context).primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[

                // Up Section
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      border: Border.all(
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(kRadius),
                        bottomRight: Radius.circular(kRadius),
                      ),
                    ),
                    //// Logo:
                    child: Center(
                      child: Container(
                        width: kRadius,
                        child: Image.asset(
                          ( Theme.of(context).brightness == Brightness.light ) ?
                            "assets/images/logo.png" :
                            "assets/images/logo_white.png",
                          semanticLabel: 'Cosmecode',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),
  
                // Loading Component
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        //// Spin
                        SpinKitPumpingHeart(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          size: getProportionateScreenWidth(40),
                        ),
                        //// Loading
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            "Loading ...",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              ],
            ),
        ),
    );
  }
}