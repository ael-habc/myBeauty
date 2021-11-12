import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mybeautyadvisor/providers/user.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';

import 'package:mybeautyadvisor/app_localizations.dart';
import 'package:mybeautyadvisor/providers/auth.dart';
import 'package:mybeautyadvisor/models/User.dart';

import 'package:mybeautyadvisor/components/dynamicBottom.dart';
import 'package:mybeautyadvisor/components/iconTextButton.dart';
import 'package:mybeautyadvisor/components/keyboard.dart';
import 'package:mybeautyadvisor/components/errorIconMessage.dart';
import 'package:mybeautyadvisor/components/littleLoadingSpin.dart';
import 'package:mybeautyadvisor/components/successIconMessage.dart';
import 'package:mybeautyadvisor/components/timeoutIconMessage.dart';

import 'package:mybeautyadvisor/constants/consts.dart';
import 'package:mybeautyadvisor/constants/inputDecorations.dart';

import 'package:mybeautyadvisor/tools/appUrl.dart';
import 'package:mybeautyadvisor/tools/customPageRoute.dart';
import 'package:mybeautyadvisor/tools/myNavigator.dart';
import 'package:mybeautyadvisor/tools/sharedPreference.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';

import 'tools/requestOtpCode.dart';

import 'dart:convert';
import 'dart:async';
import 'dart:io';





class VerifyOtpScreen extends StatefulWidget {
  final String    email;

  VerifyOtpScreen({
    @required this.email
  });

  @override
  _VerifyOtpScreenState createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  // Key
  final           _verifyFormKey = GlobalKey<FormState>();
  // Status
  LoadingState    verifyOtpStatus = LoadingState.none;
  LoadingState    resendOtpStatus = LoadingState.none;
  // Focus Nodes
  FocusNode       pin2FocusNode;
  FocusNode       pin3FocusNode;
  FocusNode       pin4FocusNode;
  // PIN Variables
  List<String>    pin = ['', '', '', ''];
  // Error
  bool            error = false;




  @override
  void initState() {
    super.initState();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    pin2FocusNode.dispose();
    pin3FocusNode.dispose();
    pin4FocusNode.dispose();
  }

  // Resend OTP code verification   //////////////////////////////////////////////////////////////
  void      resendOTPcode(String email) async {
    try {
      //* Check Connexion
      final result = await InternetAddress.lookup(
        'google.com'
      );
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // Loading State
        setState(() {
          resendOtpStatus = LoadingState.loading;
        });
        // send OTP code function
        requestOTPcode(email).then(
          (status) {
            //* Success status
            if (status) {
              setState(() {
                resendOtpStatus = LoadingState.success;
              });
              //* Go to the validate OTP page after 3s
              Timer(
                Duration(seconds: kTimeResult),
                // Reopen verify OTP screen
                () {
                  //* pop previous page
                  Navigator.pop(context);
                  //* Go to match screen
                  Navigator.push(
                    context,
                    CustomPageRoute(
                      builder: (BuildContext context) => VerifyOtpScreen(
                        email: widget.email
                      ),
                    ),
                  );
                }
              );
            }
            // Error status
            else {
              //* Error status
              setState(() {
                resendOtpStatus = LoadingState.error;
              });
            }
          }
        ).timeout(
          Duration(seconds: kTimeOut),
          onTimeout: () {
            // Timeout
            setState(() {
              resendOtpStatus = LoadingState.timeout;
            });
          }
        );
      }
      else {
        setState(() {
          resendOtpStatus = LoadingState.timeout;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        resendOtpStatus = LoadingState.timeout;
      });
    }
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////



  @override
  Widget build(BuildContext context) {

    // Verify OTP code Request             /////////////////////////////////////////////////////////
    Future<bool>      verifyOTPcodeRequest() async {
      // Data
      final Map<String, dynamic>    infosData = {
          'email': widget.email,
          'token': int.parse(pin.join(''))
      };

      // Send request
      Response          response = await post(
        AppUrl.loginOtpURL,
        body: json.encode(infosData),
        headers: {
          'Content-Type':   'application/json',
        }
      );

      // Success
      if (response.statusCode == 200) {
        //* Get user instance from the response
        final Map<String, dynamic>  responseBody = json.decode(response.body);
        var                         userData = responseBody['user'];
        userData['token'] = responseBody['token'];
        //* Build user object
        User    authUser = User.fromJson(userData);

        //* Save the user in the cache
        UserPreferences().saveUser(authUser);
        //* init the auth user
        Provider.of<UserProvider>(context, listen: false).setUser(authUser);
        //* Set as logged In
        Provider.of<AuthProvider>(context, listen: false).setNotifyLoggedIn();
        
        //* Return success
        return true;
      }

      // Fail
      return false;
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////
    
    // Verify the OTP code          ///////////////////////////////////////////////////////////////
    void      verifyOTPcode() async {
      try {
        //* Check Connexion
        final result = await InternetAddress.lookup(
          'google.com'
        );
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          // Loading State
          setState(() {
            verifyOtpStatus = LoadingState.loading;
          });
          // verify OTP code function
          verifyOTPcodeRequest().then(
            (status) {
              //* Success
              if (status) {
                // Success State
                setState(() {
                  verifyOtpStatus = LoadingState.success;
                });
                // After 3s Go to Change password
                Timer(
                  Duration(seconds: kTimeResult),
                  // Go to verify OTP screen
                  () {
                    MyNavigator.goChangePassword(context);
                  }
                );
              }
              //* Fail
              else {
                // Loading State
                setState(() {
                  verifyOtpStatus = LoadingState.error;
                });
              }
            }
          ).timeout(
            Duration(seconds: kTimeOut),
            onTimeout: () {
              // Timeout State
              setState(() {
                verifyOtpStatus = LoadingState.timeout;
              });
            }
          );
        }
        else {
          setState(() {
            verifyOtpStatus = LoadingState.timeout;
          });
        }
      } on SocketException catch (_) {
        setState(() {
          verifyOtpStatus = LoadingState.timeout;
        });
      }
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////

    return Scaffold(
      // Empty Appbar
      appBar: AppBar(title: Text("")),
    
      // body
      body: SafeArea(
        child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(40),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [

                  //// Welcome Panel 
                  Text(
                    AppLocalizations.of(context).translate('forgot-password_headline'),
                    style: Theme.of(context).textTheme.headline1.copyWith(
                      fontSize: getProportionateScreenWidth(25),
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context).translate('forgot-password_otp_message'),
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.center,
                  ),
                  //Coldown timer
                  TweenAnimationBuilder(
                    tween: Tween(begin: 300.0, end: 0.0),
                    duration: Duration(seconds: 300),
                    builder: (_, value, child) => Text(
                      "${(value / 60).toInt()}:${(value % 60).toInt()}",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(60)),

                  //// Verify OTP Form
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: getProportionateScreenHeight(30),
                    ),
                    child: Form(
                      key: _verifyFormKey,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //* PIN 1
                          SizedBox(
                            width: getProportionateScreenWidth(60),
                            child: TextFormField(
                              style: otpTextStyle,
                              cursorColor: Theme.of(context).primaryColor,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              decoration: otpInputDecoration(
                                error: verifyOtpStatus == LoadingState.error,
                              ),
                              onChanged: (value) {
                                if (value != null) {
                                  //* Reset state
                                  if (verifyOtpStatus == LoadingState.error)
                                    setState(() {
                                      verifyOtpStatus = LoadingState.none;
                                    });
                                  //* Set 1 PIN
                                  setState(() {
                                    pin[0] = value;
                                  });
                                  //* Set focus on 2
                                  pin2FocusNode.requestFocus();
                                }
                              },
                            ),
                          ),
                          //* PIN 2
                          SizedBox(
                            width: getProportionateScreenWidth(60),
                            child: TextFormField(
                              focusNode: pin2FocusNode,
                              style: otpTextStyle,
                              cursorColor: Theme.of(context).primaryColor,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              decoration: otpInputDecoration(
                                error: verifyOtpStatus == LoadingState.error,
                              ),
                              onChanged: (value) {
                                if (value != null) {
                                  //* Reset state
                                  if (verifyOtpStatus == LoadingState.error)
                                    setState(() {
                                      verifyOtpStatus = LoadingState.none;
                                    });
                                  //* Set 2 PIN
                                  setState(() {
                                    pin[1] = value;
                                  });
                                  //* Set focus on 3
                                  pin3FocusNode.requestFocus();
                                }
                              },
                            ),
                          ),
                          //* PIN 3
                          SizedBox(
                            width: getProportionateScreenWidth(60),
                            child: TextFormField(
                              focusNode: pin3FocusNode,
                              style: otpTextStyle,
                              cursorColor: Theme.of(context).primaryColor,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              decoration: otpInputDecoration(
                                error: verifyOtpStatus == LoadingState.error,
                              ),
                              onChanged: (value) {
                                if (value != null) {
                                  //* Reset state
                                  if (verifyOtpStatus == LoadingState.error)
                                    setState(() {
                                      verifyOtpStatus = LoadingState.none;
                                    });
                                  //* Set 3 PIN
                                  setState(() {
                                    pin[2] = value;
                                  });
                                  pin4FocusNode.requestFocus();
                                }
                              },
                            ),
                          ),
                          //* PIN 4
                          SizedBox(
                            width: getProportionateScreenWidth(60),
                            child: TextFormField(
                              focusNode: pin4FocusNode,
                              style: otpTextStyle,
                              cursorColor: Theme.of(context).primaryColor,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              decoration: otpInputDecoration(
                                error: verifyOtpStatus == LoadingState.error,
                              ),
                              onChanged: (value) {
                                if (value != null) {
                                  //* Reset state
                                  if (verifyOtpStatus == LoadingState.error)
                                    setState(() {
                                      verifyOtpStatus = LoadingState.none;
                                    });
                                  //* Set 4 PIN
                                  setState(() {
                                    pin[3] = value;
                                  });
                                  //* Unfocus on 4
                                  pin4FocusNode.unfocus();
                                }
                              }
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  //// Verify Dynamic bottom
                  Column(
                    children: [
                      //* Loading state
                      if (verifyOtpStatus == LoadingState.loading)
                        LittleLoadingSpin(),

                      //* Wrong State
                      if (verifyOtpStatus == LoadingState.error)
                        ErrorIconMessage(
                          message: AppLocalizations.of(context).translate('otp_verify_error'),
                        ),

                      //* Timout State
                      if (verifyOtpStatus == LoadingState.timeout)
                        TimeoutIconMessage(),

                      //* Success State
                      if (verifyOtpStatus == LoadingState.success)
                        SuccessIconMessage(
                          message: AppLocalizations.of(context).translate('otp_verify_success'),
                        ),

                      //* Send Button
                      if (
                        pin[0].isNotEmpty && pin[1].isNotEmpty && pin[2].isNotEmpty && pin[3].isNotEmpty &&
                        verifyOtpStatus != LoadingState.loading &&
                        verifyOtpStatus != LoadingState.success
                      )
                        IconTextButton(
                          text:
                            (verifyOtpStatus != LoadingState.timeout) ?
                              AppLocalizations.of(context).translate('submit') :
                              AppLocalizations.of(context).translate('retry'),
                          iconData: CupertinoIcons.paperplane_fill,
                          width: SizeConfig.screenWidth * 0.6,
                          margin: 20,
                          press: () {
                            if (_verifyFormKey.currentState.validate()) {
                              _verifyFormKey.currentState.save();
                              KeyboardUtil.hideKeyboard(context);
                              // if all are valid then go to success screen
                              verifyOTPcode();
                            }
                          },
                        ),
                    ],
                  ),

                  //// Resend Dynamic bottom
                  Column(
                    children: [
                      //* Loading state
                      if (resendOtpStatus == LoadingState.loading)
                        LittleLoadingSpin(),

                      //* Wrong State
                      if (resendOtpStatus == LoadingState.error)
                        ErrorIconMessage(
                          message: AppLocalizations.of(context).translate('otp_resent_error'),
                        ),

                      //* Timout State
                      if (resendOtpStatus == LoadingState.timeout)
                        TimeoutIconMessage(),

                      //* Success State
                      if (resendOtpStatus == LoadingState.success)
                        SuccessIconMessage(
                          message: AppLocalizations.of(context).translate('otp_sent_success'),
                        ),

                      //* Resend Button
                      if (
                        //// Checks on verify status
                        verifyOtpStatus != LoadingState.loading &&
                        verifyOtpStatus != LoadingState.success &&
                        //// Checks on resend status
                        resendOtpStatus != LoadingState.loading &&
                        resendOtpStatus != LoadingState.success
                      )
                        IconTextButton(
                          text: AppLocalizations.of(context).translate('otp_sent_retry'),
                          width: SizeConfig.screenWidth * 0.61,
                          iconData: CupertinoIcons.arrow_clockwise,
                          color: Theme.of(context).accentColor,
                          margin: 20,
                          press: () {
                            // Resend the OTP code
                            resendOTPcode(widget.email);
                          },
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
}