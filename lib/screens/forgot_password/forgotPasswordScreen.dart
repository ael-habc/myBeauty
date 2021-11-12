import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:mybeautyadvisor/app_localizations.dart';

import 'package:mybeautyadvisor/screens/forgot_password/verifyOtpScreen.dart';
import 'package:mybeautyadvisor/screens/sign_in/components/noAccountText.dart';

import 'package:mybeautyadvisor/components/errorIconMessage.dart';
import 'package:mybeautyadvisor/components/littleLoadingSpin.dart';
import 'package:mybeautyadvisor/components/successIconMessage.dart';
import 'package:mybeautyadvisor/components/timeoutIconMessage.dart';
import 'package:mybeautyadvisor/components/defaultButton.dart';
import 'package:mybeautyadvisor/components/keyboard.dart';

import 'package:mybeautyadvisor/tools/customPageRoute.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';
import 'package:mybeautyadvisor/tools/myLib.dart';

import 'package:mybeautyadvisor/constants/consts.dart';
import 'package:mybeautyadvisor/constants/inputDecorations.dart';

import 'tools/requestOtpCode.dart';

import 'dart:async';
import 'dart:io';





class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final           _sendFormKey = GlobalKey<FormState>();
  LoadingState    sendOtpStatus = LoadingState.none;
  String          email;
  String          error = '';



  //* Go to Verify OTP Screen    //////////////////////////////////////////////////////////////////
  void        goToVerifyOtpScreen() {
    //* Reset State
    setState(() {
      sendOtpStatus = LoadingState.none;
    });
    //* Go to match screen
    Navigator.push(
      context,
      CustomPageRoute(
        builder: (BuildContext context) => VerifyOtpScreen(email: email),
      ),
    );
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // Send OTP code verification   //////////////////////////////////////////////////////////////////
  void      sendOTPcode(String email) async {
    try {
      //* Check Connexion
      final result = await InternetAddress.lookup(
        'google.com'
      );
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // Loading State
        setState(() {
          sendOtpStatus = LoadingState.loading;
        });
        // send OTP code function
        requestOTPcode(email).then(
          (status) {
            //* Success status
            if (status) {
              setState(() {
                sendOtpStatus = LoadingState.success;
              });
              //* Go to the validate OTP page after 3s
              Timer(
                Duration(seconds: kTimeResult),
                //// Go to verify OTP screen
                goToVerifyOtpScreen,
              );
            }
            // Error status
            else {
              //* Error status
              setState(() {
                error = AppLocalizations.of(context).translate('error_email-wrong');
                sendOtpStatus = LoadingState.error;
              });
            }
          }
        ).timeout(
          Duration(seconds: kTimeOut),
          onTimeout: () {
            // Timeout
            setState(() {
              sendOtpStatus = LoadingState.timeout;
            });
          }
        );
      }
      else {
        setState(() {
          sendOtpStatus = LoadingState.timeout;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        sendOtpStatus = LoadingState.timeout;
      });
    }
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////



  @override
  Widget build(BuildContext context) {
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
                    AppLocalizations.of(context).translate('forgot-password_message'),
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: getProportionateScreenHeight(60)),

                  //// Sign in Form
                  Form(
                    key: _sendFormKey,
                    child: Column(
                      children: [

                        //// Form Fields
                        buildEmailFormField(),
                        SizedBox(height: 20),

                        //// Dynamic bottom
                        Column(
                          children: [
                              
                            //* Loading state
                            if (sendOtpStatus == LoadingState.loading)
                              LittleLoadingSpin(),

                            //* Wrong State
                            if (sendOtpStatus == LoadingState.error)
                              ErrorIconMessage(
                                message: AppLocalizations.of(context).translate('otp_sent_error'),
                              ),
                            
                            //* Timout State
                            if (sendOtpStatus == LoadingState.timeout)
                              TimeoutIconMessage(),

                            //* Success State
                            if (sendOtpStatus == LoadingState.success)
                              SuccessIconMessage(
                                message: AppLocalizations.of(context).translate('otp_sent_success'),
                              ),

                            //* Send Button
                            if (
                              sendOtpStatus != LoadingState.loading &&
                              sendOtpStatus != LoadingState.success
                            )
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: getProportionateScreenHeight(30),
                              ),
                              child: DefaultButton(
                                  text:
                                    (
                                      sendOtpStatus != LoadingState.timeout &&
                                      sendOtpStatus != LoadingState.error
                                    ) ?
                                      AppLocalizations.of(context).translate('send') :
                                      AppLocalizations.of(context).translate('retry'),
                                  width: SizeConfig.screenWidth * 0.6,
                                  press: () {
                                    if (_sendFormKey.currentState.validate()) {
                                      _sendFormKey.currentState.save();
                                      KeyboardUtil.hideKeyboard(context);
                                      // if all are valid then go to success screen
                                      sendOTPcode(email);
                                    }
                                  },
                                ),
                            ),
                            
                          ],
                        ),

                        //// Sign up link (if u don't have an account)
                        if (sendOtpStatus == LoadingState.none)
                          NoAccountText(),
                              
                      ],
                    ),
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
  void      _changeEmail(value) {
    if (error == AppLocalizations.of(context).translate('error_email-wrong'))
      _removeError();
    if (isEmail(value) && error == AppLocalizations.of(context).translate('error_email-invalid'))
      _removeError();
    else if (value.isNotEmpty && error == AppLocalizations.of(context).translate('error_email-null'))
      _removeError();
  }

  // Validate Function
  String    _validateEmail(value) {
    if (value.isEmpty) {
      _addError(AppLocalizations.of(context).translate('error_email-null'));
      return "";
    }
    if (!isEmail(value)) {
      _addError(AppLocalizations.of(context).translate('error_email-invalid'));
      return "";
    }
    return null;
  }

  // Error functions
  void      _removeError() {
    setState(() {
      error = '';
    });
  }

  void      _addError(err) {
    setState(() {
      error = err;
    });
  }

  // Form Field
  TextFormField     buildEmailFormField() {
    return TextFormField(
      cursorColor: Colors.pinkAccent,
      style: Theme.of(context).textTheme.bodyText1,
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: _changeEmail,
      validator: _validateEmail,
      decoration: emailInputDecoration(
        error: error,
        labelText: AppLocalizations.of(context).translate('email'),
        hintText: AppLocalizations.of(context).translate('hint_email'),
      ),
    );
  }
  //////////////////////////////////////////////////////////////////////////////////////////

}