import 'package:flutter/material.dart';


// layouts height & width that designer use
const double  kDesignHeight = 812.0;
const double  kDesignWidth = 375.0;


// Class that facilitate dealing with Screen Size using Media Query
class   SizeConfig
{
  static MediaQueryData   _mediaQueryData;
  static double           screenHeight;
  static double           screenWidth;
  static double           defaultSize;
  static Orientation      orientation;

  void  init(BuildContext context)
  {
    _mediaQueryData = MediaQuery.of(context);
    screenHeight = _mediaQueryData.size.height;
    screenWidth = _mediaQueryData.size.width;
    orientation = _mediaQueryData.orientation;
  }
}


// Get the proportionate Height as per screen size
double  getProportionateScreenHeight(double inputHeight)
{
  return (inputHeight / 812.0) * SizeConfig.screenHeight;
}


// Get the proportionate height as per screen size
double  getProportionateScreenWidth(double inputWidth)
{
  return (inputWidth / 375.0) * SizeConfig.screenWidth ;
}
