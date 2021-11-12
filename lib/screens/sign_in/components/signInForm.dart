import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';

import 'package:mybeautyadvisor/providers/auth.dart';
import 'package:mybeautyadvisor/providers/user.dart';

import 'package:mybeautyadvisor/app_localizations.dart';
import 'package:mybeautyadvisor/models/User.dart';

import 'package:mybeautyadvisor/constants/inputDecorations.dart';
import 'package:mybeautyadvisor/constants/consts.dart';

import 'package:mybeautyadvisor/tools/myNavigator.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';
import 'package:mybeautyadvisor/tools/myLib.dart';

import 'package:mybeautyadvisor/components/signLoadingSpin.dart';
import 'package:mybeautyadvisor/components/socialMediaSection.dart';
import 'package:mybeautyadvisor/components/timeoutIconMessage.dart';
import 'package:mybeautyadvisor/components/errorIconMessage.dart';
import 'package:mybeautyadvisor/components/defaultButton.dart';
import 'package:mybeautyadvisor/components/keyboard.dart';

import 'noAccountText.dart';

import 'dart:convert';
import 'dart:async';
import 'dart:io';

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  // key
  final _formKey = GlobalKey<FormState>();
  // Text Field Controller
  TextEditingController emailTextFieldController = TextEditingController();
  // Password Obscure
  bool _isPassObscure = true;
  // Checks
  LoadingState socialMediaStatus = LoadingState.none;
  // Variables
  String email;
  String password;
  // Focus node
  FocusNode passwordFocusNode;
  // Errors
  Map<String, String> errors = {
    'email': '',
    'password': '',
  };

  @override
  void initState() {
    super.initState();
    passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    passwordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AuthProvider>(context);

    // Login function //////////////////////////////////////////////////////////////////////
    void login(email, password) async {
      try {
        //* Check Connexion
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          // Login function
          Future<Map<String, dynamic>> result = auth.login(email, password);

          result.then((response) async {
            if (response['status']) {
              User user = response['user'];
              //* Set User
              Provider.of<UserProvider>(context, listen: false).setUser(user);
              //* Go Home
              MyNavigator.goHome(context);
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
            }
          }).timeout(Duration(seconds: kTimeOut), onTimeout: () async {
            //* Set Timeout message
            setState(() {
              socialMediaStatus = LoadingState.timeout;
            });
            //* Modify Logged-in status
            auth.setNotLoggedIn();
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
            Timer(Duration(seconds: 4), () {
              setState(() {
                socialMediaStatus = LoadingState.none;
              });
            });
          });
        } else {
          setState(() {
            socialMediaStatus = LoadingState.timeout;
          });
          // Modify Logged-in status
          auth.setNotLoggedIn();
        }
      } on SocketException catch (_) {
        setState(() {
          socialMediaStatus = LoadingState.timeout;
        });
        // Modify Logged-in status
        auth.setNotLoggedIn();
      }
    }
    //////////////////////////////////////////////////////////////////////////////////////////////////

    // Facebook Register  ////////////////////////////////////////////////////////////////////////////
    // void fbLogin() async {
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
    //
    //     /// Set the email to show in the input
    //     setState(() {
    //       emailTextFieldController.text = profile['email'];
    //     });
    //     login(profile['email'], '.facebook.' + obelouchHolyPower);
    //   } else if (facebookLoginResult.status ==
    //       FacebookLoginStatus.cancelledByUser) {
    //     print('fb suscription is cancelled by user');
    //   } else if (facebookLoginResult.status == FacebookLoginStatus.error) {
    //     print('${facebookLoginResult.errorMessage}');
    //   }
    // }
    // ////////////////////////////////////////////////////////////////////////////////////////////
    //
    // // Google Login  ///////////////////////////////////////////////////////////////////////////
    // void googleLogin() async {
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
    //         setState(() {
    //           emailTextFieldController.text = acc.email;
    //         });
    //         // Login using Google credential
    //         login(acc.email, '.google.' + obelouchHolyPower);
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
    ////////////////////////////////////////////////////////////////////////////////////////////

    // Apple Login  ////////////////////////////////////////////////////////////////////////////
    // void appleLogin() async {
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
    //     login(credential.email, '.apple.' + obelouchHolyPower);
    //   }).timeout(Duration(seconds: kTimeOut), onTimeout: () {
    //     setState(() {
    //       socialMediaStatus = LoadingState.none;
    //     });
    //   });
    // }
    ///////////////////////////////////////////////////////////////////////////////////////////

    return Form(
      key: _formKey,
      child: Column(
        children: [
          //// Form Fields
          buildEmailFormField(),
          buildPasswordFormField(),

          //// Wrong Email or Password
          if (socialMediaStatus == LoadingState.error)
            ErrorIconMessage(
              message: email != null
                  ? AppLocalizations.of(context).translate('sign-in_wrong')
                  : AppLocalizations.of(context)
                      .translate('sign-in_social-media_wrong'),
            ),

          //// Timeout Message
          if (socialMediaStatus == LoadingState.timeout) TimeoutIconMessage(),

          //// Bottom of the field
          (auth.loggedInStatus == Status.Authenticating ||
                  socialMediaStatus == LoadingState.loading)
              ?
              // Loading Spin
              SignLoadingSpin()
              :
              // Login features
              Column(
                  children: [
                    // Login Button
                    DefaultButton(
                      text: socialMediaStatus == LoadingState.timeout
                          ? AppLocalizations.of(context).translate('retry')
                          : AppLocalizations.of(context).translate('sign_in'),
                      margin: 20,
                      width: SizeConfig.screenWidth * 0.5,
                      press: () {
                        //* Remove wrong email, password error message
                        setState(() {
                          socialMediaStatus = LoadingState.none;
                        });
                        //* Send Form
                        final form = _formKey.currentState;
                        if (form.validate()) {
                          form.save();
                          KeyboardUtil.hideKeyboard(context);
                          // Login function
                          login(email, password);
                        }
                      },
                    ),

                    //// Forget Password!
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: getProportionateScreenHeight(20),
                      ),
                      child: GestureDetector(
                        child: Text(
                          AppLocalizations.of(context)
                              .translate('sign-in_forgot-password'),
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        onTap: () {
                          MyNavigator.goForgotPassword(context);
                        },
                      ),
                    ),

                    // Sign in using social media
                    // SocialMediaSection(
                    //   onPress: {
                    //     'facebook': fbLogin,
                    //     'google': googleLogin,
                    //     // 'apple': appleLogin,
                    //   },
                    // ),

                    // Sign up link (if u don't have an account)
                    NoAccountText(),
                  ],
                ),
        ],
      ),
    );
  }

  //// Email Form       //////////////////////////////////////////////////////////////
  // Onchange Function
  void _changeEmail(value) {
    // Remove Wrong email or password Message
    setState(() {
      socialMediaStatus = LoadingState.none;
    });
    // Inputs Errors
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
        controller: emailTextFieldController,
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
  ///////////////////////////////////////////////////////////////////////////////////

  //// Password Form       //////////////////////////////////////////////////////////
  // Onchange Function
  void _changePassword(value) {
    // Remove Wrong email or password
    setState(() {
      socialMediaStatus = LoadingState.none;
    });
    // Inputs Errors
    if (value.isNotEmpty &&
        errors['password'] ==
            AppLocalizations.of(context).translate('error_password-null'))
      _removePasswordError();
  }

  // Validate Function
  String _validatePassword(value) {
    if (value.isEmpty) {
      _addPasswordError(
          AppLocalizations.of(context).translate('error_password-null'));
      return "";
    }
    return null;
  }

  // Obscure function
  void _togglePasswordView() {
    setState(() {
      _isPassObscure = !_isPassObscure;
    });
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
        decoration: passwordInputDecoration(
          error: errors['password'],
          labelText: AppLocalizations.of(context).translate('password'),
          hintText: AppLocalizations.of(context).translate('hint_password'),
          isObscure: _isPassObscure,
          toggleView: _togglePasswordView,
        ),
      ),
    );
  }
  ////////////////////////////////////////////////////////////////////////////////

}
