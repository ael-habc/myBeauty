import 'package:flutter/material.dart';
import 'package:mybeautyadvisor/routes.dart';
import 'package:mybeautyadvisor/tools/customPageRoute.dart';


class   MyNavigator
{
  // Gooooooo to:
  static void   goToHome(BuildContext context)             { Navigator.pushNamed(context, '/home');            }
  static void   goToGlamroom(BuildContext context)         { Navigator.pushNamed(context, '/glamroom');        }
  static void   goToFoundation(BuildContext context)       { Navigator.pushNamed(context, '/foundation');      }
  static void   goToLipstick(BuildContext context)         { Navigator.pushNamed(context, '/lipstick');        }
  static void   goToSignIn(BuildContext context)           { Navigator.pushNamed(context, '/sign_in');         }
  static void   goToSignUp(BuildContext context)           { Navigator.pushNamed(context, '/sign_up');         }
  static void   goToProfile(BuildContext context)          { Navigator.pushNamed(context, '/profile');         }
  static void   goToOnboarding(BuildContext context)       { Navigator.pushNamed(context, '/onboarding');      }
  static void   goToForgotPassword(BuildContext context)   { Navigator.pushNamed(context, '/forgot_password'); }
  static void   goToEditProfile(BuildContext context)      { Navigator.pushNamed(context, '/edit_profile');    }
  static void   goToChangePassword(BuildContext context)   { Navigator.pushNamed(context, '/change_password'); }
  static void   goToSettings(BuildContext context)         { Navigator.pushNamed(context, '/settings');        }
  static void   goToHelpSupport(BuildContext context)      { Navigator.pushNamed(context, '/help_support');    }
  static void   goToPickReference(BuildContext context)    { Navigator.pushNamed(context, '/pick_reference');  }


  // Gooooooo:
  static void   goHome(BuildContext context) {
    Navigator.push(
      context,
      CustomPageRoute(builder: routes['/home']),
    );
  }

  static void   goGlamroom(BuildContext context) {
    Navigator.push(
      context,
      CustomPageRoute(builder: routes['/glamroom']),
    );
  }

  static void   goFoundation(BuildContext context) {
    Navigator.push(
      context,
      CustomPageRoute(builder: routes['/foundation']),
    );
  }

  static void   goLipstick(BuildContext context) {
    Navigator.push(
      context,
      CustomPageRoute(builder: routes['/lipstick']),
    );
  } 

  static void   goSignIn(BuildContext context) {
    Navigator.push(
      context,
      CustomPageRoute(builder: routes['/sign_in']),
    );
  } 

  static void   goSignUp(BuildContext context) {
    Navigator.push(
      context,
      CustomPageRoute(builder: routes['/sign_up']),
    );
  } 

  static void   goForgotPassword(BuildContext context) {
    Navigator.push(
      context,
      CustomPageRoute(builder: routes['/forgot_password']),
    );
  }

  static void   goProfile(BuildContext context) {
    Navigator.push(
      context,
      CustomPageRoute(builder: routes['/profile']),
    );
  }

  static void   goOnboarding(BuildContext context) {
    Navigator.push(
      context,
      CustomPageRoute(builder: routes['/onboarding']),
    );
  }

  static void   goEditProfile(BuildContext context) {
    Navigator.push(
      context,
      CustomPageRoute(builder: routes['/edit_profile']),
    );
  }

  static void   goChangePassword(BuildContext context) {
    Navigator.push(
      context,
      CustomPageRoute(builder: routes['/change_password']),
    );
  }

  static void   goSettings(BuildContext context) {
    Navigator.push(
      context,
      CustomPageRoute(builder: routes['/settings']),
    );
  }

  static void   goHelpSupport(BuildContext context) {
    Navigator.push(
      context,
      CustomPageRoute(builder: routes['/help_support']),
    );
  }

  static void   goPickReference(BuildContext context) {
    Navigator.push(
      context,
      CustomPageRoute(builder: routes['/pick_reference']),
    );
  }

}
