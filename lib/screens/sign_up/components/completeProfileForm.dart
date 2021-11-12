import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

import 'package:mybeautyadvisor/app_localizations.dart';

import 'package:mybeautyadvisor/providers/user.dart';
import 'package:mybeautyadvisor/providers/auth.dart';

import 'package:mybeautyadvisor/models/User.dart';
import 'package:mybeautyadvisor/models/UserInfos.dart';

import 'package:mybeautyadvisor/constants/inputDecorations.dart';
import 'package:mybeautyadvisor/constants/consts.dart';

import 'package:mybeautyadvisor/tools/myNavigator.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';
import 'package:mybeautyadvisor/tools/myLib.dart';

import 'package:mybeautyadvisor/components/signLoadingSpin.dart';
import 'package:mybeautyadvisor/components/defaultButton.dart';
import 'package:mybeautyadvisor/components/errorIconMessage.dart';
import 'package:mybeautyadvisor/components/timeoutIconMessage.dart';
import 'package:mybeautyadvisor/components/keyboard.dart';

import 'optionalPanel.dart';

import 'dart:async';
import 'dart:io';

class CompleteProfileForm extends StatefulWidget {
  final UserInfos userInfos;

  CompleteProfileForm({@required this.userInfos});

  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  // Form key
  final _formKey = GlobalKey<FormState>();
  // State
  bool _isTimeOut = false;
  bool _isWrong = false;
  // Variables
  String phoneNumber;
  String phoneISO;
  String name;
  // Focus node
  FocusNode phoneFocusNode;
  // Errors
  Map<String, String> errors = {
    'name': '',
    'phone_number': '',
  };

  @override
  void initState() {
    super.initState();
    phoneFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    phoneFocusNode.dispose();
  }

  // Remove is wrong //////////////////////////////////////////////////////////
  void removeWrong() {
    if (_isWrong)
      setState(() {
        _isWrong = false;
      });
  }
  /////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    UserInfos userInfos = widget.userInfos;

    // register function  ////////////////////////////////////////////////////////////////
    void register(String name, String phoneNumber) async {
      try {
        //* Check Connexion
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          // register function
          userInfos.setName(capitalize(name));
          userInfos.setPhone(phoneNumber);

          Future<Map<String, dynamic>> result = auth.register(userInfos.name,
              userInfos.phone, userInfos.email, userInfos.password);

          result.then((response) {
            if (response['status']) {
              User user = response['user'];
              //* Set User
              Provider.of<UserProvider>(context, listen: false).setUser(user);
              //* Go onboarding
              MyNavigator.goOnboarding(context);
            } else {
              setState(() {
                _isWrong = true;
              });
            }
          }).timeout(Duration(seconds: kTimeOut), onTimeout: () {
            // Set Timeout message
            setState(() {
              _isTimeOut = true;
            });
            // Modify Registring status
            auth.setNotRegistered();
            // Reset Timeout message after 4s
            Timer(Duration(seconds: kTimeLoading), () {
              setState(() {
                _isTimeOut = false;
              });
            });
          });
        } else {
          setState(() {
            _isTimeOut = true;
          });
          // Modify Registring status
          auth.setNotRegistered();
        }
      } on SocketException catch (_) {
        setState(() {
          _isTimeOut = true;
        });
        // Modify Registring status
        auth.setNotRegistered();
      }
    }
    /////////////////////////////////////////////////////////////////////////////////////

    return Form(
      key: _formKey,
      child: Column(
        children: [
          //// Text Fields
          // Name Form Field
          buildNameFormField(),
          // Optional text
          // OptionalPanel(),
          // // Phone Number form Field
          // buildPhoneFormField(),
          // Empty Space
          SizedBox(height: getProportionateScreenHeight(30)),

          //// Wrong Email or Password
          if (_isWrong)
            ErrorIconMessage(
              message: AppLocalizations.of(context).translate('sign-up_wrong'),
            ),

          //// Timeout Message
          if (_isTimeOut) TimeoutIconMessage(),

          //// Register Button
          (auth.registeredStatus == Status.Registering)
              ?
              // Loading Spin
              SignLoadingSpin()
              :
              // Login features
              DefaultButton(
                  text: (_isTimeOut)
                      ? AppLocalizations.of(context).translate('retry')
                      : AppLocalizations.of(context)
                          .translate('sign-up_next-2'),
                  margin: getProportionateScreenHeight(30),
                  width: getProportionateScreenWidth(230),
                  press: () {
                    var form = _formKey.currentState;
                    if (form.validate()) {
                      form.save();
                      KeyboardUtil.hideKeyboard(context);
                      // Rmove Timeout
                      _isTimeOut = false;
                      // Call back the register fonction
                      register(name, "");
                    }
                  },
                ),
        ],
      ),
    );
  }

  //// Name Form       //////////////////////////////////////////
  // Onchange Function
  void _changeName(String value) {
    // if (isName(value) &&
    //     errors['name'] ==
    //         AppLocalizations.of(context).translate('error_name-invalid'))
    //   _removeNameError();
    //else
    if (value.isNotEmpty &&
        errors['name'] ==
            AppLocalizations.of(context).translate('error_name-null'))
      _removeNameError();
  }

  // Validate Function
  String _validateName(String value) {
    if (value.isEmpty) {
      _addNameError(AppLocalizations.of(context).translate('error_name-null'));
      return "";
    }
    // if (!isName(value)) {
    //   _addNameError(
    //       AppLocalizations.of(context).translate('error_name-invalid'));
    //   return "";
    // }
    return null;
  }

  // Error Tools
  void _addNameError(String error) {
    setState(() {
      errors['name'] = error;
    });
  }

  void _removeNameError() {
    setState(() {
      errors['name'] = '';
    });
  }

  // Form Field
  TextFormField buildNameFormField() {
    return TextFormField(
      cursorColor: Colors.pinkAccent,
      style: Theme.of(context).textTheme.bodyText1,
      keyboardType: TextInputType.name,
      onSaved: (newValue) => name = newValue,
      onChanged: _changeName,
      validator: _validateName,
      onEditingComplete: () => phoneFocusNode.requestFocus(),
      decoration: nameInputDecoration(
        error: errors['name'],
        labelText: AppLocalizations.of(context).translate('name'),
        hintText: AppLocalizations.of(context).translate('hint_name'),
      ),
    );
  }
  /////////////////////////////////////////////////////////////////

  //// Phone Form       //////////////////////////////////////////
  // Onchange Function
  void _changePhoneNumber(PhoneNumber value) {
    if (value.number.length >= PHONE_NBR_MIN_LEN &&
        errors['phone_number'] ==
            AppLocalizations.of(context).translate('error_phone-short'))
      _removePhoneError();
    else if (value.number.length <= PHONE_NBR_MAX_LEN &&
        errors['phone_number'] ==
            AppLocalizations.of(context).translate('error_phone-long'))
      _removePhoneError();
    else if (isNumeric(value.number)) _removePhoneError();
  }

  // Validate Function
  String _validatePhoneNumber(String value) {
    if (value.length > PHONE_NBR_MAX_LEN) {
      _addPhoneError(
          AppLocalizations.of(context).translate('error_phone-long'));
      return "";
    }
    if (value.length > 0 && value.length < PHONE_NBR_MIN_LEN) {
      _addPhoneError(
          AppLocalizations.of(context).translate('error_phone-short'));
      return "";
    }
    return null;
  }

  // Error Tools
  void _addPhoneError(String error) {
    setState(() {
      errors['phone_number'] = error;
    });
  }

  void _removePhoneError() {
    setState(() {
      errors['phone_number'] = '';
    });
  }

  // Form Field
  IntlPhoneField buildPhoneFormField() {
    return IntlPhoneField(
      autoValidate: false,
      initialCountryCode: 'FR',
      focusNode: phoneFocusNode,
      countryCodeTextColor: Theme.of(context).textTheme.bodyText1.color,
      searchText:
          AppLocalizations.of(context).translate('sign-up_search-contry-phone'),
      style: Theme.of(context).textTheme.bodyText1,
      validator: _validatePhoneNumber,
      onChanged: _changePhoneNumber,
      onSaved: (newValue) {
        phoneNumber = newValue.number;
        phoneISO = newValue.countryCode;
      },
      decoration: phoneInputDecoration(
        error: errors['phone_number'],
        labelText: AppLocalizations.of(context).translate('phone'),
        hintText: AppLocalizations.of(context).translate('hint_phone'),
      ),
    );
  }
  /////////////////////////////////////////////////////////////////
}
