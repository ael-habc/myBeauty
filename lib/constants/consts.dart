import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';



// Loading Status
enum LoadingState   { none, loading, success, error, timeout, noInternet }

// Bottom Nav Bar constants
enum MenuState      { home, glamroom, account, none }


// Design Constants
//// Radius of social media buttons
double    kSocialMediaRadius = getProportionateScreenWidth(36);
//// Toolbar Height
double    kToolBarHeight = getProportionateScreenHeight(100);


// Colors:
//// Pallete
const     kPalePinkColor =            Color(0xFFFFCCCC);
const     kFuzzyWuzzyColor =          Color(0xFFD96464);
const     kSmokyBlackColor =          Color(0xFF211611);
const     kBlastBronzeColor =         Color(0xFFA76D60);
const     kBloodRedColor =            Color(0xFF601700);
//// None Avatar
const     kNoAvatarColor =            kBlastBronzeColor;
//// Border
const     kInputBorderColor =         CupertinoColors.systemGrey;
const     kImageBorderColor =         Color(0xFFF2F2F2);
const     kImageBackgroundColor =     Colors.white; 
//// Light
const     kBgColor =                  Color(0xFFFDFDFD);
const     kPrimaryColor =             kFuzzyWuzzyColor;
const     kPrimaryLightColor =        kPalePinkColor;
const     kSecondaryColor =           kBloodRedColor;
const     kSecondaryLightColor =      kBlastBronzeColor;
const     kTextColor =                Colors.black87;
const     kAppbarColor =              kBgColor;
const     kBottomNavbarColor =        Colors.white;
const     kCardColor =                Colors.white;
const     kHintColor =                CupertinoColors.systemGrey;

const     kPrimaryGradientColor =     LinearGradient(
  begin: Alignment.topCenter ,
  end: Alignment.bottomCenter,
  colors: [
    Colors.white,
    kPrimaryLightColor,
  ],
);

//// Dark
const     kDarkBgColor =              Color(0xFF202020);
const     kDarkPrimaryColor =         kPrimaryLightColor;
const     kDarkPrimaryLightColor =    kPrimaryColor;
const     kDarkSecondaryColor =       kSecondaryLightColor;
const     kDarkSecondaryLightColor =  kSecondaryColor;
const     kDarkTextColor =            Colors.white70;
const     kDarkAppbarColor =          kDarkBgColor;
const     kDarkBottomNavbarColor =    kSmokyBlackColor;
const     kDarkCardColor =            Color(0xFF1F1F1F);
const     kDarkHintColor =            Colors.white70;


// Fonts
const     kFontTitle =                "BodoniModa";
const     kFontSubTitle =             "Barlow";


// Animation
const     kAnimationDuration =        Duration(milliseconds: 300);


// Themes
//// LIGHT
ThemeData   lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: kBgColor,
  backgroundColor: kSecondaryLightColor,
  primaryColor: kPrimaryColor,
  primaryColorLight: kPrimaryLightColor,
  accentColor: kSecondaryColor,
  shadowColor: Colors.black87,
  disabledColor: CupertinoColors.systemGrey,
  cardColor: kCardColor,
  buttonColor: kPrimaryColor,
  cursorColor: Colors.pink[100],
  bottomAppBarColor: kBottomNavbarColor,
  hintColor: kHintColor,
  appBarTheme: AppBarTheme(
    elevation: 0,
    centerTitle: true,
    color: kAppbarColor,
    iconTheme: IconThemeData(
      color: kPrimaryColor,
    ),
  ),
  fontFamily: kFontTitle,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: kPrimaryLightColor,
  ),
  textTheme: TextTheme(
    // Title Style
    headline1: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: kTextColor,
        height: 1.6
    ),
    // Subtitle Style
    headline2: TextStyle(
      fontSize: 24,
      fontFamily: kFontSubTitle,
      color: kTextColor,
      height: 1.4,
    ),
    // Normal Text
    bodyText1: TextStyle(
      fontSize: 14,
      fontFamily: kFontSubTitle,
      color: kTextColor,
      height: 1.6,
    ),
    // Normal Text
    bodyText2: TextStyle(
      fontSize: 14,
      fontFamily: kFontSubTitle,
      color: kTextColor,
      height: 1.6,
    ),
  ),
);


//// DARK
ThemeData   darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: kDarkBgColor,
  backgroundColor: kDarkAppbarColor,
  primaryColor: kDarkPrimaryColor,
  primaryColorLight: kDarkPrimaryLightColor,
  accentColor: kDarkSecondaryLightColor,
  shadowColor: Colors.white10,
  disabledColor: Colors.white70,
  cardColor: kDarkCardColor,
  buttonColor: kDarkPrimaryColor,
  cursorColor: Colors.pink[100],
  bottomAppBarColor: kDarkBottomNavbarColor,
  hintColor: kDarkHintColor,
  appBarTheme: AppBarTheme(
    elevation: 0,
    centerTitle: true,
    color: kDarkAppbarColor,
    iconTheme: IconThemeData(
      color: kDarkPrimaryColor,
    ),
  ),
  fontFamily: kFontTitle,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: kDarkPrimaryLightColor,
  ),
  textTheme: TextTheme(
    // Title Style
    headline1: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: kDarkTextColor,
        height: 1.6        
    ),
    // Subtitle Style
    headline2: TextStyle(
      fontSize: 24,
      fontFamily: kFontSubTitle,
      color: kDarkTextColor,
      height: 1.4,
    ),
    // Normal Text
    bodyText1: TextStyle(
      fontSize: 14,
      fontFamily: kFontSubTitle,
      color: kDarkTextColor,
      height: 1.6,
    ),
    // Normal Text
    bodyText2: TextStyle(
      fontSize: 14,
      fontFamily: kFontSubTitle,
      color: kDarkTextColor,
      height: 1.6,
    ),
  ),
);


// Text Style
const TextStyle     otpTextStyle = TextStyle(
  fontSize: 23,
  fontWeight: FontWeight.bold,
);


// Phone Norm
const int     PHONE_NBR_MIN_LEN = 6;
const int     PHONE_NBR_MAX_LEN = 15;


// Time
const int     kTimeOutMatch = 20;
const int     kTimeFeelAlgo = 7;
const int     kTimeNpsShow =  10;
const int     kTimeLoading =  5;
const int     kTimeResult =   3;
const int     kTimeOut =      10;
const int     kSplashSleep =  4;


// Distance
const double      kPopUpBottom = 20;


// Keys
const String      keySmartlookAPI =       '1629d6d667baad71d0e0f7092f8f43eb876dfe62';
const String      obelouchHolyPower =     '+96vPnOfhmn9tddIQhJ1AauPYNU=';


// Images
//// Not found placeholder
const String      kImgLargeNotFound =     'https://cosmecode.com/images/products/large/3551.jpg';
const String      kImgThumbNotFound =     'https://cosmecode.com/images/products/thumb/3551.jpg';
//// Foundation Lipstick
const String      kImgFoundation =        'assets/images/homeFoundation.png';
const String      kImgLipstick =          'assets/images/homeLipstick.png';


// Constants
const double      kDefaultRate = 30;


// Version
const String      kAppStage = "alpha";
const String      kVersion =  "0.2";
