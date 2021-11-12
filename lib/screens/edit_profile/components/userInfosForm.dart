import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';

import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/phone_number.dart';

import 'package:mybeautyadvisor/app_localizations.dart';
import 'package:mybeautyadvisor/providers/auth.dart';
import 'package:mybeautyadvisor/providers/user.dart';

import 'package:mybeautyadvisor/components/timeoutIconMessage.dart';
import 'package:mybeautyadvisor/components/errorIconMessage.dart';
import 'package:mybeautyadvisor/components/dynamicBottom.dart';
import 'package:mybeautyadvisor/components/defaultButton.dart';
import 'package:mybeautyadvisor/components/keyboard.dart';

import 'package:mybeautyadvisor/constants/inputDecorations.dart';
import 'package:mybeautyadvisor/constants/consts.dart';

import 'package:mybeautyadvisor/tools/sharedPreference.dart';
import 'package:mybeautyadvisor/tools/myNavigator.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';
import 'package:mybeautyadvisor/tools/appUrl.dart';
import 'package:mybeautyadvisor/tools/myLib.dart';

import 'dart:convert';
import 'dart:async';
import 'dart:io';






class UserInfosForm extends StatefulWidget {
  @override
  _UserInfosFormState createState() => _UserInfosFormState();
}


class _UserInfosFormState extends State<UserInfosForm> {
  // Key form
  final                 _formKey = GlobalKey<FormState>();
  // new == old error
  bool                  _isSame = false;
  // Loading state
  LoadingState          status = LoadingState.none;
  // Values
  String                phoneNumber;
  String                phoneISO;
  String                name;
  // Focus node
  FocusNode             phoneFocusNode;
  // Errors
  Map<String, String>   errors = {
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


  @override
  Widget build(BuildContext context) {
    var       userProvider = Provider.of<UserProvider>(context);
    var       auth = Provider.of<AuthProvider>(context);
    var       user = userProvider.user;

    // Update Infos function  //////////////////////////////////////////////////
    updateInfos(
      String name,
      String phone
    ) async {
      try {
        //* Check Connexion (pinging on GOOGLE server)
        var   result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          final Map<String, dynamic>    profilData = {
              'userid': user.id,
              'prénom': name,
              'phone':  phone,
          };

          // Is Loading
          setState(() {
            status = LoadingState.loading;
          });

          //* Send request
          Response          response = await post(
            AppUrl.editProfilURL,
            body: json.encode(profilData),
            headers: {
              'Authorization': 'Bearer ' + user.token,
              'Content-Type': 'application/json'
            }
          );
        
          //* Success
          if (response.statusCode == 200) {
            // Modify User Provider
            userProvider.setName(name);
            userProvider.setPhone(phone);
            // Modify User Preference
            await UserPreferences().saveUser(userProvider.user);
            // Show Success
            setState(() {
              status = LoadingState.success;
            });
          }
          //* Expired token [logout]
          else if (response.statusCode == 401) {
            //* Logout from APP Auth
            
            //+ Go Home
            MyNavigator.goHome(context);
          }
          //* Fail
          else {
            setState(() {
              // Show Error
              status = LoadingState.error;
            });
          }
        }
        // Timeout
        else {
          setState(() {
            status = LoadingState.timeout;
          });
        }
      } on SocketException catch (_) {
        setState(() {
          status = LoadingState.timeout;
        });
      }
      // timer to reset the old value
      Timer(
        Duration(seconds: kTimeResult),
        () {
          // None
          setState(() {
            status = LoadingState.none;
          });
        }
      );
    }
    ///////////////////////////////////////////////////////////////////////////////

    /// submit password changes function ///////////////////////////////////////////
    void              submitUpdateInfos() {
      final     form = _formKey.currentState;
      String    phone;
      String    newName;

      // Remove Same Error
        if (_isSame)
          setState(() {
            _isSame = false;
          });
      // Validate Form
      if (form.validate()) {
        form.save();
        KeyboardUtil.hideKeyboard(context);
        // New name capitalized
        newName = capitalize(name);
        // Get Full phone number (with ISO)
        if (phoneNumber == null || phoneNumber.isEmpty)
          phone = null;
        else
          phone = (phoneISO + " " + phoneNumber).trim();
        if (newName == user.name && phone == user.phone) {
          setState(() {
            _isSame = true;
          });
          return ;
        }
        //* update Infos
        updateInfos(newName, phone).timeout(
          Duration(seconds: kTimeOut),
          onTimeout: () {
            // None
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
      child: Padding(
        padding: EdgeInsets.all(
          getProportionateScreenWidth(15),
        ),
        child: Column(
          children: [
            
              //* Name Form Field
              buildNameFormField(user.name),

              //* Space
              SizedBox(height: 20),

              //* Phone Number form Field
              buildPhoneFormField(user.phone),

              //* Space
              SizedBox(height: 20),

              //* Error Same Message
              if (_isSame)
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: ErrorIconMessage(
                    message: AppLocalizations.of(context).translate('edit-profil_same'),
                  ),
                ),

              //* Timeout Error
              if (status == LoadingState.timeout)
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: TimeoutIconMessage(),
                ),

              //// Dynamic bottom
              DynamicButtom(
                textSuccess:  AppLocalizations.of(context).translate('edit-profil_success'),
                textError:    AppLocalizations.of(context).translate('edit-profil_error'),
                state: status,
                childWidget: //// Submit Button
                  DefaultButton(
                    text: (status != LoadingState.timeout) ?
                      AppLocalizations.of(context).translate('submit') :
                      AppLocalizations.of(context).translate('retry'),
                    width: SizeConfig.screenWidth * 0.42,
                    press: submitUpdateInfos,
                  ),
              )

            ],
          ),
      ),
    );
  }


  //// Name Form       ////////////////////////////////////////////////////////////////////////////////////
  // Onchange Function
  void      _changeName(String value) {
    // if (isName(value) && errors['name'] == AppLocalizations.of(context).translate('error_name-invalid'))
    //   _removeNameError();
    // else
    if (value.isNotEmpty && errors['name'] == AppLocalizations.of(context).translate('error_name-null'))
      _removeNameError();
  }

  // Validate Function
  String    _validateName(String value) {
    if (value.isEmpty) {
      _addNameError(AppLocalizations.of(context).translate('error_name-null'));
      return "";
    }
    // if (!isName(value)) {
    //   _addNameError(AppLocalizations.of(context).translate('error_name-invalid'));
    //   return "";
    // }
    return null;
  }

  // Error Tools
  void    _addNameError(String error) {
    setState(() {
      errors['name'] = error;
    });
  }

  void    _removeNameError() {
    setState(() {
      errors['name'] = '';
    });
  }

  // Form Field
    TextFormField     buildNameFormField(String initialName) {
    return TextFormField(
      initialValue: initialName,
      cursorColor: Theme.of(context).cursorColor,
      style: Theme.of(context).textTheme.bodyText1,
      keyboardType: TextInputType.name,
      onSaved: (newValue) => name = newValue,
      onChanged: _changeName,
      validator: _validateName,
      onEditingComplete: () => phoneFocusNode.requestFocus(),
      decoration: nameInputDecoration(
        error:      errors['name'],
        labelText:  AppLocalizations.of(context).translate('name'),
        hintText:   AppLocalizations.of(context).translate('hint_name'),
      ),
    );
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////

  //// Phone Form       ///////////////////////////////////////////////////////////////////////////
  // Onchange Function
  void      _changePhoneNumber(PhoneNumber value) {
    if (value.number.length >= PHONE_NBR_MIN_LEN &&
        errors['phone_number'] == AppLocalizations.of(context).translate('error_phone-short'))
      _removePhoneError();
    else if (value.number.length <= PHONE_NBR_MAX_LEN &&
        errors['phone_number'] == AppLocalizations.of(context).translate('error_phone-long'))
      _removePhoneError();
    else if (isNumeric(value.number))
      _removePhoneError();
  }

  // Validate Function
  String      _validatePhoneNumber(String value) {
    if (value.length > PHONE_NBR_MAX_LEN) {
      _addPhoneError(AppLocalizations.of(context).translate('error_phone-long'));
      return "";
    }
    if (value.length > 0 && value.length < PHONE_NBR_MIN_LEN) {
      _addPhoneError(AppLocalizations.of(context).translate('error_phone-short'));
      return "";
    }
    return null;
  }

  // Error Tools
  void        _addPhoneError(String error) {
    setState(() {
      errors['phone_number'] = error;
    });
  }

  void        _removePhoneError() {
    setState(() {
      errors['phone_number'] = '';
    });
  }

  // Get country code from phoneISO
  String     _getCountryCodeFromPhoneISO(String phoneISO) {
    Map<String, dynamic>    country;

    for (country in countries) {
      if (phoneISO == country['dial_code'])
        return country['code'];
    }
    // Default 'France'
    return 'FR';
  }

  // Form Field
  IntlPhoneField    buildPhoneFormField(String initialPhone) {
    String    oldPhoneISO;
    String    oldPhoneNumber;
    
    if (initialPhone != null) {
      oldPhoneISO = initialPhone.split(' ')[0];
      oldPhoneNumber = initialPhone.split(' ')[1];
    }

    return IntlPhoneField(
      initialValue: oldPhoneNumber,
      autoValidate: false,
      focusNode: phoneFocusNode,
      style: Theme.of(context).textTheme.bodyText1,
      initialCountryCode:_getCountryCodeFromPhoneISO(oldPhoneISO),
      countryCodeTextColor: Theme.of(context).textTheme.bodyText1.color,
      searchText: AppLocalizations.of(context).translate('sign-up_search-contry-phone'),
      validator: _validatePhoneNumber,
      onChanged: _changePhoneNumber,
      onSaved: (newValue) {
        phoneNumber = newValue.number;
        phoneISO = newValue.countryCode;
      },
      decoration: phoneInputDecoration(
        error:      errors['phone_number'],
        labelText:  AppLocalizations.of(context).translate('phone'),
        hintText:   AppLocalizations.of(context).translate('hint_phone'),
      ),
    );
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////

}