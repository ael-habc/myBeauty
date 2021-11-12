import 'package:flutter/material.dart';
// Screens
import 'screens/forgot_password/forgotPasswordScreen.dart';
import 'screens/change_password/changePasswordScreen.dart';
import 'screens/foundation/pick_reference/pickReferenceScreen.dart';
import 'screens/foundation/foundationScreen.dart';
import 'screens/edit_profile/editProfileScreen.dart';
import 'screens/help_support/helpSupportScreen.dart';
import 'screens/onboarding/onboardingScreen.dart';
import 'screens/first_page/firstScreen.dart';
import 'screens/settings/settingsScreen.dart';
import 'screens/lipstick/lipstickScreen.dart';
import 'screens/glamroom/glamroomScreen.dart';
import 'screens/profil/profilScreen.dart';
import 'screens/sign_up/SignUpScreen.dart';
import 'screens/sign_in/SignInScreen.dart';
import 'screens/home/homeScreen.dart';



// Routes in the App
var   routes = <String, WidgetBuilder> {
  "/home":              (BuildContext context) => HomeScreen(),
  "/glamroom":          (BuildContext context) => GlamroomScreen(),
  "/lipstick":          (BuildContext context) => LipstickScreen(),
  "/foundation":        (BuildContext context) => FoundationScreen(),
  "/profile":           (BuildContext context) => ProfilScreen(),
  "/sign_in":           (BuildContext context) => SignInScreen(),
  "/sign_up":           (BuildContext context) => SignUpScreen(),
  "/settings":          (BuildContext context) => SettingsScreen(),
  "/first_page":        (BuildContext context) => FirstScreen(),
  "/onboarding":        (BuildContext context) => OnboardingScreen(),
  "/edit_profile":      (BuildContext context) => EditProfileScreen(),
  "/help_support":      (BuildContext context) => HelpSupportScreen(),
  "/forgot_password":   (BuildContext context) => ForgotPasswordScreen(),
  "/change_password":   (BuildContext context) => ChangePasswordScreen(),
  "/pick_reference":    (BuildContext context) => PickReferenceScreen(),
};
