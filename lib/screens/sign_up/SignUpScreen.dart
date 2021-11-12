import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import 'package:mybeautyadvisor/app_localizations.dart';

import 'package:mybeautyadvisor/providers/auth.dart';
import 'package:mybeautyadvisor/providers/user.dart';

import 'package:mybeautyadvisor/models/UserInfos.dart';
import 'package:mybeautyadvisor/models/User.dart';

import 'package:mybeautyadvisor/components/defaultButton.dart';
import 'package:mybeautyadvisor/components/socialMediaSection.dart';
import 'package:mybeautyadvisor/components/keyboard.dart';
import 'package:mybeautyadvisor/components/logo.dart';

import 'package:mybeautyadvisor/components/social_media/errorBloc.dart';
import 'package:mybeautyadvisor/components/social_media/successBloc.dart';
import 'package:mybeautyadvisor/components/social_media/loadingBloc.dart';
import 'package:mybeautyadvisor/components/social_media/timeoutBloc.dart';

import 'package:mybeautyadvisor/constants/inputDecorations.dart';
import 'package:mybeautyadvisor/constants/consts.dart';

import 'package:mybeautyadvisor/tools/myNavigator.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';
import 'package:mybeautyadvisor/tools/myLib.dart';

import 'components/completeProfileForm.dart';
import 'components/yesAccountText.dart';

import 'dart:convert';
import 'dart:async';
import 'dart:io';

// Pading constant
double kViewPadding = getProportionateScreenWidth(40);

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Key
  final _formKey = GlobalKey<FormState>();
  // Password Obscure
  bool _isPassObscure = true;
  // Variables
  UserInfos _userInfos = UserInfos();
  String email;
  String password;
  String confirm;
  // Checks
  LoadingState socialMediaStatus = LoadingState.none;
  // Focus node
  FocusNode passwordFocusNode;
  FocusNode confirmFocusNode;
  // Errors
  Map<String, String> errors = {
    'email': '',
    'password': '',
    'confirm_password': '',
  };
  // Page Index
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    passwordFocusNode = FocusNode();
    confirmFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    passwordFocusNode.dispose();
    confirmFocusNode.dispose();
  }

  // Go back function    /////////////////////////////////////////////////////////////////
  void goBack() {
    setState(() {
      socialMediaStatus = LoadingState.none;
    });
  }
  ////////////////////////////////////////////////////////////////////////////////////////

  // Obscure function    /////////////////////////////////////////////////////////////////
  void _togglePasswordView() {
    setState(() {
      _isPassObscure = !_isPassObscure;
    });
  }
  ////////////////////////////////////////////////////////////////////////////////////////

  // Save Infos and go to the next stack
  void saveInfos() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      KeyboardUtil.hideKeyboard(context);
      // Go to Complete Infos
      setState(() {
        _userInfos.setEmail(email);
        _userInfos.setPassword(password);
        _pageIndex++;
      });
    }
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    // register function  ////////////////////////////////////////////////////////////////////////
    void register(String email, String password, String name) async {
      try {
        //* Check Connexion
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          // register function
          Future<Map<String, dynamic>> result =
              auth.register(capitalize(name), null, email, password);

          result.then((response) async {
            if (response['status']) {
              //* Set Success State
              setState(() {
                socialMediaStatus = LoadingState.success;
              });
              //* Set User
              User user = response['user'];
              Provider.of<UserProvider>(context, listen: false).setUser(user);
              // After amount of time go to =====> Onboarding
              Timer(Duration(seconds: kTimeResult), () {
                MyNavigator.goOnboarding(context);
              });
            } else {
              setState(() {
                socialMediaStatus = LoadingState.error;
              });
              //* Sign out google account
              try {
                await GoogleSignIn().disconnect();
              } on Exception catch (e) {
                print("No google account to signout");
              }
              //* Signout facebook account
              try {
                await FacebookLogin().logOut();
              } on Exception catch (e) {
                print("No google account to signout");
              }
              //* After amount of time go to ==> register page
              Timer(Duration(seconds: kTimeResult + 5), () {
                setState(() {
                  socialMediaStatus = LoadingState.none;
                });
              });
            }
          }).timeout(Duration(seconds: kTimeOut), onTimeout: () async {
            //* Set Timeout message
            setState(() {
              socialMediaStatus = LoadingState.timeout;
            });
            // Modify Registring status
            auth.setNotRegistered();
            //* Sign out google account
            try {
              await GoogleSignIn().disconnect();
            } on Exception catch (e) {
              print("No google account to signout");
            }
            //* Signout facebook account
            try {
              await FacebookLogin().logOut();
            } on Exception catch (e) {
              print("No google account to signout");
            }
            //* Reset Timeout message after 4s
            Timer(Duration(seconds: kTimeLoading), () {
              setState(() {
                socialMediaStatus = LoadingState.none;
              });
            });
          });
        } else {
          print('timeout');
          setState(() {
            socialMediaStatus = LoadingState.timeout;
          });
          // Modify Registring status
          auth.setNotRegistered();
        }
      } on SocketException catch (_) {
        setState(() {
          socialMediaStatus = LoadingState.timeout;
        });
        // Modify Registring status
        auth.setNotRegistered();
      }
    }
    //////////////////////////////////////////////////////////////////////////////////////////////

    // Facebook Register  ////////////////////////////////////////////////////////////////////////
    // void fbRegister() async {
    //   // Loading
    //   setState(() {
    //     socialMediaStatus = LoadingState.loading;
    //   });
    //
    //   final facebookLogin = FacebookLogin();
    //   final facebookLoginResult = await facebookLogin.logIn(['email']);
    //
    //   if (facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
    //     final token = facebookLoginResult.accessToken.token;
    //
    //     /// for profile details also use the below code
    //     final graphResponse = await get(Uri.parse(
    //         'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token'));
    //     final profile = json.decode(graphResponse.body);
    //     register(profile['email'], '.facebook.' + obelouchHolyPower,
    //         profile['first_name']);
    //   } else if (facebookLoginResult.status ==
    //       FacebookLoginStatus.cancelledByUser) {
    //     print('fb suscription is cancelled by user');
    //     setState(() {
    //       socialMediaStatus = LoadingState.none;
    //     });
    //   } else if (facebookLoginResult.status == FacebookLoginStatus.error) {
    //     print('${facebookLoginResult.errorMessage}');
    //     setState(() {
    //       socialMediaStatus = LoadingState.none;
    //     });
    //   }
    // }
    // /////////////////////////////////////////////////////////////////////////////////////////////
    //
    // // Google Register  /////////////////////////////////////////////////////////////////////////
    // void googleRegister() async {
    //   // Loading
    //   setState(() {
    //     socialMediaStatus = LoadingState.loading;
    //   });
    //
    //   try {
    //     // Init Google Sign-In instance
    //     GoogleSignIn _googleSignIn = GoogleSignIn(
    //       scopes: [
    //         'email',
    //       ],
    //     );
    //     // Sign in with google
    //     _googleSignIn.signIn().then((GoogleSignInAccount acc) async {
    //       //// Check if the account is handed
    //       if (acc != null) {
    //         // Register using the credential
    //         register(
    //             acc.email,
    //             '.google.' + obelouchHolyPower,
    //             acc.displayName != null && acc.displayName.isNotEmpty
    //                 ? acc.displayName.split(" ")[0]
    //                 : "user");
    //       }
    //       //// Handle cancel
    //       else {
    //         setState(() {
    //           socialMediaStatus = LoadingState.none;
    //         });
    //       }
    //     }).timeout(Duration(seconds: kTimeOut), onTimeout: () {
    //       setState(() {
    //         socialMediaStatus = LoadingState.none;
    //       });
    //     });
    //   } catch (error) {
    //     print(error);
    //     setState(() {
    //       socialMediaStatus = LoadingState.none;
    //     });
    //   }
    // }
    //////////////////////////////////////////////////////////////////////////////////////////////

    // Apple Register  ///////////////////////////////////////////////////////////////////////////
    // void appleRegister() async {
    //   // Loading
    //   setState(() {
    //     socialMediaStatus = LoadingState.loading;
    //   });

    //   // Authenticate
    //   SignInWithApple.getAppleIDCredential(
    //     scopes: [
    //       AppleIDAuthorizationScopes.email,
    //       AppleIDAuthorizationScopes.fullName,
    //     ],
    //   ).then((credential) {
    //     // Register using the credential
    //     print(credential);
    //   });
    // }
    //////////////////////////////////////////////////////////////////////////////////////////////

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(40),
            ),
            child: SingleChildScrollView(
              child: IndexedStack(
                index: _pageIndex,
                children: <Widget>[
                  // Step 1: (email + password)
                  Column(
                    children: <Widget>[
                      //* Loading
                      if (socialMediaStatus == LoadingState.loading)
                        LoadingSpin(),
                      //* Error
                      if (socialMediaStatus == LoadingState.error)
                        ErrorBloc(
                          message: AppLocalizations.of(context)
                              .translate('social-media_sign-up_error'),
                          backFunction: goBack,
                        ),
                      //* Timeout
                      // if (socialMediaStatus == LoadingState.timeout)
                      //   TimeoutBloc(
                      //     retryFunction: fbRegister,
                      //   ),
                      //* Success
                      if (socialMediaStatus == LoadingState.success)
                        SuccessBloc(
                          message: AppLocalizations.of(context)
                              .translate('social-media_sign-up_success'),
                        ),
                      //* Normal
                      if (socialMediaStatus == LoadingState.none)
                        Column(
                          children: <Widget>[
                            //// Logo
                            // ignore: missing_required_param
                            Logo(
                              height: SizeConfig.screenHeight * 0.12,
                            ),
                            // Empty Space
                            SizedBox(height: getProportionateScreenHeight(25)),

                            //// Welcome Panel
                            Text(
                              AppLocalizations.of(context)
                                  .translate('sign-up_headline-1'),
                              style: Theme.of(context).textTheme.headline1,
                            ),
                            Text(
                              AppLocalizations.of(context)
                                  .translate('sign-up_message-1'),
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            SizedBox(height: getProportionateScreenHeight(50)),

                            //// Sign Up Form
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  //// Form Fields
                                  // Email
                                  buildEmailFormField(),
                                  // Password
                                  buildPasswordFormField(),
                                  // Confirm password
                                  buildConfirmFormField(),
                                  //// Continue Button
                                  DefaultButton(
                                    text: AppLocalizations.of(context)
                                        .translate('sign-up_next-1'),
                                    margin: getProportionateScreenHeight(32),
                                    width: getProportionateScreenWidth(220),
                                    press: saveInfos,
                                  ),
                                ],
                              ),
                            ),

                            // Sign Up using social media
                            // SocialMediaSection(
                            //   onPress: {
                            //     'facebook': fbRegister,
                            //     'google': googleRegister,
                            //     // 'apple': appleRegister,
                            //   },
                            // ),

                            // Log In link (if u have an account)
                            YesAccountText(),
                          ],
                        ),
                    ],
                  ),

                  // Step 2: Name + infos
                  Column(
                    children: [
                      //// Logo
                      // ignore: missing_required_param
                      Logo(
                        height: SizeConfig.screenHeight * 0.12,
                      ),
                      // Empty Space
                      SizedBox(height: getProportionateScreenHeight(25)),

                      //// Welcome Panel
                      Text(
                        AppLocalizations.of(context)
                            .translate('sign-up_headline-2'),
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      Text(
                        AppLocalizations.of(context)
                            .translate('sign-up_message-2'),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      SizedBox(height: getProportionateScreenHeight(50)),

                      //// Complete Profile Form
                      CompleteProfileForm(
                        userInfos: _userInfos,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //// Email Form       //////////////////////////////////////////
  // Onchange Function
  void _changeEmail(value) {
    if (isEmail(value) &&
        errors['email'] ==
            AppLocalizations.of(context).translate('error_email-invalid'))
      _removeEmailError();
    else if (value.isNotEmpty &&
        errors['email'] ==
            AppLocalizations.of(context).translate('error_email-null'))
      _removeEmailError();
  }

  // Validate Function
  String _validateEmail(value) {
    if (value.isEmpty) {
      _addEmailError(
          AppLocalizations.of(context).translate('error_email-null'));
      return "";
    }
    if (!isEmail(value)) {
      _addEmailError(
          AppLocalizations.of(context).translate('error_email-invalid'));
      return "";
    }
    return null;
  }

  // Error Tools
  void _addEmailError(String error) {
    setState(() {
      errors['email'] = error;
    });
  }

  void _removeEmailError() {
    setState(() {
      errors['email'] = '';
    });
  }

  // Form Field
  Widget buildEmailFormField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        cursorColor: Theme.of(context).cursorColor,
        style: Theme.of(context).textTheme.bodyText1,
        keyboardType: TextInputType.emailAddress,
        onSaved: (newValue) => email = newValue,
        onChanged: _changeEmail,
        validator: _validateEmail,
        onEditingComplete: () => passwordFocusNode.requestFocus(),
        decoration: emailInputDecoration(
          error: errors['email'],
          labelText: AppLocalizations.of(context).translate('email'),
          hintText: AppLocalizations.of(context).translate('hint_email'),
        ),
      ),
    );
  }
  //////////////////////////////////////////////////////////////////

  //// Password Form       /////////////////////////////////////////
  // Onchange Function
  void _changePassword(value) {
    // if (isStrongPassword(value) &&
    //     errors['password'] ==
    //         AppLocalizations.of(context).translate('error_password-weak'))
    //   _removePasswordError();
    // else
    if (value.length >= 5 &&
        errors['password'] ==
            AppLocalizations.of(context).translate('error_password-short'))
      _removePasswordError();
    else if (value.isNotEmpty &&
        errors['password'] ==
            AppLocalizations.of(context).translate('error_password-null'))
      _removePasswordError();
    password = value;
  }

  // Validate Function
  String _validatePassword(value) {
    if (value.isEmpty) {
      _addPasswordError(
          AppLocalizations.of(context).translate('error_password-null'));
      return "";
    }
    if (value.length <= 5) {
      _addPasswordError(
          AppLocalizations.of(context).translate('error_password-short'));
      return "";
    }
    // if (!isStrongPassword(value)) {
    //   _addPasswordError(
    //       AppLocalizations.of(context).translate('error_password-weak'));
    //   return "";
    // }
    return null;
  }

  // Error Tools
  void _addPasswordError(String error) {
    setState(() {
      errors['password'] = error;
    });
  }

  void _removePasswordError() {
    setState(() {
      errors['password'] = '';
    });
  }

  // Form Field
  Widget buildPasswordFormField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        focusNode: passwordFocusNode,
        cursorColor: Theme.of(context).cursorColor,
        style: Theme.of(context).textTheme.bodyText1,
        obscureText: _isPassObscure,
        onSaved: (newValue) => password = newValue,
        onChanged: _changePassword,
        validator: _validatePassword,
        onEditingComplete: () => confirmFocusNode.requestFocus(),
        decoration: passwordInputDecoration(
            error: errors['password'],
            labelText: AppLocalizations.of(context).translate('password'),
            hintText: AppLocalizations.of(context).translate('hint_password'),
            isObscure: _isPassObscure,
            toggleView: _togglePasswordView),
      ),
    );
  }
  ////////////////////////////////////////////////////////////////////////////

  //// Confirm Password Form       ///////////////////////////////////////////
  // Onchange Function
  void _changeConfirmPassword(value) {
    if (value == password &&
        errors['confirm_password'] ==
            AppLocalizations.of(context).translate('error_confirm-diff'))
      _removeConfirmError();
    else if (value.isNotEmpty &&
        errors['confirm_password'] ==
            AppLocalizations.of(context).translate('error_confirm-null'))
      _removeConfirmError();
    confirm = value;
  }

  // Validate Function
  String _validateConfirmPassword(value) {
    if (value.isEmpty) {
      _addConfirmError(
          AppLocalizations.of(context).translate('error_confirm-null'));
      return "";
    }
    if (value != password) {
      _addConfirmError(
          AppLocalizations.of(context).translate('error_confirm-diff'));
      return "";
    }
    return null;
  }

  // Error Tools
  void _addConfirmError(String error) {
    setState(() {
      errors['confirm_password'] = error;
    });
  }

  void _removeConfirmError() {
    setState(() {
      errors['confirm_password'] = '';
    });
  }

  // Form Field
  Widget buildConfirmFormField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
          focusNode: confirmFocusNode,
          cursorColor: Theme.of(context).cursorColor,
          style: Theme.of(context).textTheme.bodyText1,
          obscureText: _isPassObscure,
          onSaved: (newValue) => confirm = newValue,
          onChanged: _changeConfirmPassword,
          validator: _validateConfirmPassword,
          decoration: confirmPassInputDecoration(
              error: errors['confirm_password'],
              labelText: AppLocalizations.of(context).translate('confirm'),
              hintText: AppLocalizations.of(context).translate('hint_confirm'),
              isObscure: _isPassObscure,
              toggleView: _togglePasswordView)),
    );
  }
}
