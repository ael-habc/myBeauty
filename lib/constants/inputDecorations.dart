import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'consts.dart';


dynamic         dependColorError(String error) {
  if (error == '')
    return CupertinoColors.systemGrey;
  return Colors.red;
}

// Custom Template ///////////////////////////////////////////////////

InputDecoration   customInputDecoration({
    String  labelText,
    String  hintText,
    Widget  prefixIcon,
    Widget  suffixIcon,
    dynamic color = kPrimaryColor,
    bool    enabled = true
  }) {
  return InputDecoration(
    enabled: enabled,
    labelText: labelText,
    labelStyle: TextStyle(
      color: color,
      fontFamily: kFontTitle,
    ),
    hintText: hintText,
    floatingLabelBehavior: FloatingLabelBehavior.always,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    errorStyle: TextStyle(height: 0),
    isDense: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(
        color: kInputBorderColor,
      ), 
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(
        color: color,
      ), 
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(
        color: Colors.pink[200],
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(
        color: kInputBorderColor,
      ), 
    ),
  );
}

// Email /////////////////////////////////////////////////////////////

InputDecoration   emailInputDecoration({
    String error,
    String labelText,
    String hintText
  }) {
  return customInputDecoration(
    color: dependColorError(error),
    labelText: error == '' ? labelText : error,
    hintText: hintText,
    prefixIcon: Icon(
      CupertinoIcons.mail_solid,
      color: dependColorError(error),
    ),
  );
}
///////////////////////////////////////////////////////////////////////////

// Password  //////////////////////////////////////////////////////////////

InputDecoration   passwordInputDecoration({
    String    error,
    String    labelText,
    String    hintText,
    bool      isObscure,
    Function  toggleView
  }) {
  return customInputDecoration(
    color: dependColorError(error),
    labelText: error == '' ? labelText : error,
    hintText: hintText,
    prefixIcon: Icon(
      CupertinoIcons.lock_fill,
      color: dependColorError(error),
    ),
    suffixIcon: GestureDetector(
      onTap: toggleView,
      child: Icon(
        isObscure ? CupertinoIcons.eye : CupertinoIcons.eye_slash_fill,
        color: CupertinoColors.systemGrey,
      ),
    ),
  );
}
///////////////////////////////////////////////////////////////////////////

// Confirm Password  //////////////////////////////////////////////////////

InputDecoration   confirmPassInputDecoration({
    String    error,
    String    labelText,
    String    hintText,
    bool      isObscure,
    Function  toggleView
  }) {
  return customInputDecoration(
    color: dependColorError(error),
    labelText: error == '' ? labelText : error,
    hintText: hintText,
    prefixIcon: Icon(
      CupertinoIcons.shield_fill,
      color: dependColorError(error),
    ),
    suffixIcon: GestureDetector(
      onTap: toggleView,
      child: Icon(
        isObscure ? CupertinoIcons.eye : CupertinoIcons.eye_slash_fill,
        color: CupertinoColors.systemGrey,
      ),
    ),
  );
}
///////////////////////////////////////////////////////////////////////////

// Name ///////////////////////////////////////////////////////////////////

InputDecoration   nameInputDecoration({
  String error,
  String labelText,
  String hintText,
}) {
  return customInputDecoration(
    color: dependColorError(error),
    labelText: error == '' ? labelText : error,
    hintText: hintText,
    prefixIcon: Icon(
      CupertinoIcons.person_fill,
      color: dependColorError(error),
    ),
  );
}
////////////////////////////////////////////////////////////////////////////

// Phone Number ////////////////////////////////////////////////////////////

InputDecoration   phoneInputDecoration({
  String error,
  String labelText,
  String hintText
}) {
  return customInputDecoration(
    color: dependColorError(error),
    labelText: error == '' ? labelText : error,
    hintText: hintText,
    prefixIcon: Icon(
      CupertinoIcons.phone_fill,
      color: dependColorError(error),
    ),
  );
}
///////////////////////////////////////////////////////////////////////////

// Product Name  //////////////////////////////////////////////////////////

InputDecoration   productInputDecoration({
  String  error,
  String  labelText,
  String  hintText,
}) {
  return customInputDecoration(
    color: dependColorError(error),
    labelText: error == '' ? labelText : error,
    hintText: hintText,
    prefixIcon: Icon(
      CupertinoIcons.search,
      color: dependColorError(error),
    ),
  );
}
///////////////////////////////////////////////////////////////////////////

// Text  /////////////////////////////////////////////////////////////////

InputDecoration   textInputDecoration({
  String  error,
  String  labelText,
  String  hintText,
}) {
  return customInputDecoration(
    color: dependColorError(error),
    labelText: error == '' ? labelText : error,
    hintText: hintText,
  );
}
///////////////////////////////////////////////////////////////////////////

// OTP  ///////////////////////////////////////////////////////////////////

InputDecoration   otpInputDecoration({
  bool error
}) {
  return InputDecoration(
    floatingLabelBehavior: FloatingLabelBehavior.always,
    errorStyle: TextStyle(height: 0),
    isDense: true,
    counterText: "",
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(
        color: error ? Colors.red : CupertinoColors.systemGrey,
      ), 
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(
        color: kPrimaryColor,
      ), 
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(
        color: Colors.pink[200],
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(
        color: error ? Colors.red : CupertinoColors.systemGrey,
      ), 
    ),
  );;
}
///////////////////////////////////////////////////////////////////////////