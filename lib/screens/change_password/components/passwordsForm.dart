import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mybeautyadvisor/providers/auth.dart';
import 'package:mybeautyadvisor/tools/myNavigator.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';

import 'package:mybeautyadvisor/app_localizations.dart';
import 'package:mybeautyadvisor/providers/user.dart';

import 'package:mybeautyadvisor/components/errorIconMessage.dart';
import 'package:mybeautyadvisor/components/littleLoadingSpin.dart';
import 'package:mybeautyadvisor/components/successIconMessage.dart';
import 'package:mybeautyadvisor/components/timeoutIconMessage.dart';
import 'package:mybeautyadvisor/components/defaultButton.dart';
import 'package:mybeautyadvisor/components/keyboard.dart';

import 'package:mybeautyadvisor/tools/sizeConfig.dart';
import 'package:mybeautyadvisor/tools/appUrl.dart';
import 'package:mybeautyadvisor/tools/myLib.dart';

import 'package:mybeautyadvisor/constants/consts.dart';
import 'package:mybeautyadvisor/constants/inputDecorations.dart';

import 'dart:convert';
import 'dart:io';





class PasswordsForm extends StatefulWidget {
  @override
  _PasswordsFormState createState() => _PasswordsFormState();
}


class _PasswordsFormState extends State<PasswordsForm> {
  // Key form
  final                   _formKey = GlobalKey<FormState>();
  // Input Text Controllers
  TextEditingController   newPasswordTextController = TextEditingController();
  TextEditingController   confirmTextController = TextEditingController();
  // Loading state
  LoadingState            status = LoadingState.none;
  // is Obscure
  bool                    _isNewPassObscure = true;
  // Values
  String                  newPassword;
  String                  confirm;
  // Focus node
  FocusNode               confirmFocusNode;
  // Errors
  Map<String, String>     errors = {
                            'new_password': '',
                            'confirm_password': '',
                          };


  
  
  @override
  void initState() {
    super.initState();
    confirmFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    confirmFocusNode.dispose();
  }


  // Obscure functions     /////////////////////////////////////////////////////////
  void      _toggleNewPasswordView() {
    setState(() {
      _isNewPassObscure = !_isNewPassObscure;
    });
  }
  /////////////////////////////////////////////////////////////////////////////////


  @override
  Widget build(BuildContext context) {
    var       user = Provider.of<UserProvider>(context).user;

    // change password function  //////////////////////////////////////////////////
    changePassword(String newPassword) async {
      try {
        final Map<String, dynamic>    passwordData = {
            'userid':       user.id,
            'newPassword':  newPassword,
        };

        // Is Loading
        setState(() {
          status = LoadingState.loading;
        });

        // Send request
        Response          response = await post(
          AppUrl.changePasswordURL,
          body: json.encode(passwordData),
          headers: {
            'Authorization': 'Bearer ' + user.token,
            'Content-Type': 'application/json'
          }
        );

        // Success
        if (response.statusCode == 200) {
          //* Show Success
          setState(() {
            status = LoadingState.success;
          });
          //* Go to Home
          MyNavigator.goHome(context);
        }
        // Expired token [logout]
        else if (response.statusCode == 401) {
          //* Logout from APP Auth
          Provider.of<AuthProvider>(context, listen: false).logout();
          //+ Go Home
          MyNavigator.goHome(context);
        }
        // Failed
        else {
          setState(() {
            //* Show Error
            status = LoadingState.error;
            //* empty input controllers
            newPasswordTextController.text = '';
            confirmTextController.text = '';
            //* empty the new values
            newPassword = '';
            confirm = '';
          });
        }
      } on SocketException catch (_) {
        setState(() {
          status = LoadingState.timeout;
        });
      }
    }
    ///////////////////////////////////////////////////////////////////////////////

    /// submit password changes function ///////////////////////////////////////////
    void              submitChangePassword() {
      final   form = _formKey.currentState;
    
      if (form.validate()) {
        form.save();
        KeyboardUtil.hideKeyboard(context);
        //* change password
        changePassword(newPassword).timeout(
          Duration(seconds: kTimeOut),
          onTimeout: () {
            setState(() {
              status = LoadingState.timeout;
            });
          }
        );
      }
    }
    //////////////////////////////////////////////////////////////////////////////////////

    return Form(
      key: _formKey,
      child: Column(
        children: [

            //// Form Fields
            //* new Password
            buildNewPasswordFormField(),
            //* Confirn Password
            buildConfirmFormField(),
            //* Space
            SizedBox(height: getProportionateScreenHeight(20)),

            //// Timeout Message
            if (status == LoadingState.timeout)
              TimeoutIconMessage(),

            //// Dynamic bottom
            Column(
              children: [
                //* Loading state
                if (status == LoadingState.loading)
                  LittleLoadingSpin(),

                //* Wrong State
                if (status == LoadingState.error)
                  ErrorIconMessage(
                    message: AppLocalizations.of(context).translate('change-password_error'),
                  ),

                //* Timout State
                if (status == LoadingState.timeout)
                  TimeoutIconMessage(),

                //* Success State
                if (status == LoadingState.success)
                  SuccessIconMessage(
                    message: AppLocalizations.of(context).translate('change-password_success'),
                  ),

                //* Change password Button
                if (
                  status != LoadingState.loading &&
                  status != LoadingState.success
                )
                  DefaultButton(
                    text:
                      (
                        status != LoadingState.timeout &&
                        status != LoadingState.error
                      ) ?
                        AppLocalizations.of(context).translate('submit') :
                        AppLocalizations.of(context).translate('retry'),
                    margin: getProportionateScreenHeight(32),
                    width: SizeConfig.screenWidth * 0.4,
                    //* Change password fonctionality
                    press: submitChangePassword,
                  ),
                
              ],
            ),

          ],
        ),
    );
  }


  //// New Password Form       //////////////////////////////////////////////////////////////////////////////////////////////
  // Onchange Function
  void      _changeNewPassword(value) {
    // if (isStrongPassword(value) && errors['new_password'] == AppLocalizations.of(context).translate('error_password-weak'))
    //   _removeNewPasswordError();
    // else
     if (value.length >= 6 && errors['new_password'] == AppLocalizations.of(context).translate('error_password-short'))
      _removeNewPasswordError();
    else if (value.isNotEmpty && errors['new_password'] == AppLocalizations.of(context).translate('error_password-null'))
      _removeNewPasswordError();
    newPassword = value;
  }

  // Validate Function
  String    _validateNewPassword(value) {
    if (value.isEmpty) {
      _addNewPasswordError(AppLocalizations.of(context).translate('error_password-null'));
      return "";
    }
    if (value.length <= 6) {
      _addNewPasswordError(AppLocalizations.of(context).translate('error_password-short'));
      return "";
    }
    // if (!isStrongPassword(value)) {
    //   _addNewPasswordError(AppLocalizations.of(context).translate('error_password-weak'));
    //   return "";
    // }
    return null;
  }

  // Error Tools
  void _addNewPasswordError(String error) {
    setState(() {
      errors['new_password'] = error;
    });
  }

  void _removeNewPasswordError() {
    setState(() {
      errors['new_password'] = '';
    });
  }

  // Form Field
  Widget       buildNewPasswordFormField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        cursorColor: Colors.pinkAccent,
        obscureText: _isNewPassObscure,
        style: Theme.of(context).textTheme.bodyText1,
        onSaved: (newValue) => newPassword = newValue,
        onChanged: _changeNewPassword,
        validator: _validateNewPassword,
        onEditingComplete: () => confirmFocusNode.requestFocus(),
        controller: newPasswordTextController,
        decoration: passwordInputDecoration(
          error:      errors['new_password'],
          labelText:  AppLocalizations.of(context).translate('new-password'),
          hintText:   AppLocalizations.of(context).translate('hint_new-password'),
          isObscure:  _isNewPassObscure,
          toggleView: _toggleNewPasswordView
        ),
      ),
    );
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  //// Confirm Password Form       ////////////////////////////////////////////////////////////////////////////////////////
  // Onchange Function
  void      _changeConfirmPassword(value) {
    if (value == newPassword && errors['confirm_password'] == AppLocalizations.of(context).translate('error_confirm-diff'))
      _removeConfirmError();
    else if (value.isNotEmpty && errors['confirm_password'] == AppLocalizations.of(context).translate('error_confirm-null'))
      _removeConfirmError();
    confirm = value;
  }

  // Validate Function
  String    _validateConfirmPassword(value) {
    if (value.isEmpty) {
      _addConfirmError(AppLocalizations.of(context).translate('error_confirm-null'));
      return "";
    }
    if (value != newPassword) {
      _addConfirmError(AppLocalizations.of(context).translate('error_confirm-diff'));
      return "";
    }
    return null;
  }

  // Error Tools
  void      _addConfirmError(String error) {
    setState(() {
      errors['confirm_password'] = error;
    });
  }

  void      _removeConfirmError() {
    setState(() {
      errors['confirm_password'] = '';
    });
  }

  // Form Field
  Widget       buildConfirmFormField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        focusNode: confirmFocusNode,
        cursorColor: Colors.pinkAccent,
        obscureText: _isNewPassObscure,
        style: Theme.of(context).textTheme.bodyText1,
        onSaved: (newValue) => confirm = newValue,
        onChanged: _changeConfirmPassword,
        validator: _validateConfirmPassword,
        controller: confirmTextController,
        decoration: confirmPassInputDecoration(
          error:      errors['confirm_password'],
          labelText:  AppLocalizations.of(context).translate('confirm'),
          hintText:   AppLocalizations.of(context).translate('hint_confirm'),
          isObscure:  _isNewPassObscure,
          toggleView: _toggleNewPasswordView
        )
      ),
    );
  }

}