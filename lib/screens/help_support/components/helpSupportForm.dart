import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'package:mybeautyadvisor/app_localizations.dart';

import 'package:mybeautyadvisor/providers/user.dart';

import 'package:mybeautyadvisor/components/timeoutIconMessage.dart';
import 'package:mybeautyadvisor/components/dynamicBottom.dart';
import 'package:mybeautyadvisor/components/iconTextButton.dart';
import 'package:mybeautyadvisor/components/keyboard.dart';

import 'package:mybeautyadvisor/tools/appUrl.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';

import 'package:mybeautyadvisor/constants/consts.dart';
import 'package:mybeautyadvisor/constants/inputDecorations.dart';


import 'dart:convert';
import 'dart:async';
import 'dart:io';





class HelpSupportForm extends StatefulWidget {
  @override
  _HelpSupportFormState createState() => _HelpSupportFormState();
}

class _HelpSupportFormState extends State<HelpSupportForm> {
  // Form key
  final                 _formKey = GlobalKey<FormState>();
  // Status
  LoadingState          status = LoadingState.none;
  // Variables
  String                subject;
  String                description;
  // Focus node
  FocusNode             descriptionFocusNode;
  // Errors
  Map<String, String>   errors = {
                          'subject': '',
                          'description': '',
                        };



  @override
  void initState() {
    super.initState();
    descriptionFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    descriptionFocusNode.dispose();
  }


  // Sending Report Request function //////////////////////////////////////////////
  sendReportRequest(
    String owner,
    String subject,
    String description
  ) async {
    // Product Data
    final Map<String, dynamic>    requestData = {
        'email':        owner,
        'subject':      subject,
        'description':  description,
    };

    // Is Loading
    setState(() {
      status = LoadingState.loading;
    });

    // Send request
    Response          response = await post(
      AppUrl.sendAlertURL,
      body: json.encode(requestData),
      headers: { 'Content-Type': 'application/json' }
    );

    // Set State
    setState(() {
      status = ( response.statusCode == 200 ) ?
          LoadingState.success :
          LoadingState.error;
    });

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
  ///////////////////////////////////////////////////////////////////////////////////

  // Send Report /////////////////////////////////////////////////////////////////////
  sendReport({
    String owner,
    String subject,
    String description
  }) async {
    try {
      //* Check Connexion (pinging on GOOGLE server)
      var   result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // send Request
        await sendReportRequest(owner, subject, description);
      }
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
  }
  /////////////////////////////////////////////////////////////////////////////////////


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [

            //// Form Fields
            buildSubjectFormField(),
            buildDescriptionFormField(),

            //// Timeout Message
            if (status == LoadingState.timeout)
              TimeoutIconMessage(),

            //// Dynamic bottom
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: getProportionateScreenHeight(30),
              ),
              child: DynamicButtom(
                state: status,
                textSuccess: AppLocalizations.of(context).translate('help-support_success'),
                textError: AppLocalizations.of(context).translate('help-support_error'),
                childWidget: IconTextButton(
                  text:
                    (status != LoadingState.timeout) ?
                      AppLocalizations.of(context).translate('submit') :
                      AppLocalizations.of(context).translate('retry'),
                  width: SizeConfig.screenWidth * 0.5,
                  iconData: CupertinoIcons.paperplane_fill,
                  press: () {
                    final   form = _formKey.currentState;     
                    if (form.validate()) {
                      form.save();
                      KeyboardUtil.hideKeyboard(context);
                      // Send Report function
                      sendReport(
                        owner: Provider.of<UserProvider>(context, listen: false).user.email,
                        subject: subject,
                        description: description,
                      );
                    }
                  },
                ),
              ),
            ),

          ],
        ),
    );
  }


  //// Subject Form       //////////////////////////////////////////////////////////////////////////////////
  // Onchange Function
  void      _changeSubject(value) {
    if (value.isNotEmpty && errors['subject'] == AppLocalizations.of(context).translate('error_subject-null'))
      setState(() {
        errors['subject'] = '';
      });
  }

  // Validate Function
  String    _validateSubject(value) {
    if (value.isEmpty) {
      setState(() {
        errors['subject'] = AppLocalizations.of(context).translate('error_subject-null');
      });
      return "";
    }
    return null;
  }

  // Form Field
  Widget    buildSubjectFormField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        cursorColor: Theme.of(context).cursorColor,
        style: Theme.of(context).textTheme.bodyText1,
        keyboardType: TextInputType.text,
        onSaved: (newValue) => subject = newValue,
        onChanged: _changeSubject,
        validator: _validateSubject,
        onEditingComplete: () => descriptionFocusNode.requestFocus(),
        decoration: textInputDecoration(
          error:      errors['subject'],
          labelText:  AppLocalizations.of(context).translate('subject'),
          hintText:   AppLocalizations.of(context).translate('hint_subject'),
        ),
      ),
    );
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////

  //// Description Form       //////////////////////////////////////////////////////////////////////////////////
  // Onchange Function
  void      _changeDescription(value) {
    if (value.isNotEmpty && errors['description'] == AppLocalizations.of(context).translate('error_description-null'))
      setState(() {
        errors['description'] = '';
      });
  }

  // Validate Function
  String    _validateDescription(value) {
    if (value.isEmpty) {
      setState(() {
        errors['description'] = AppLocalizations.of(context).translate('error_description-null');
      });
      return "";
    }
    return null;
  }

  // Form Field
  Widget    buildDescriptionFormField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        minLines: 5,
        maxLines: 5,
        focusNode: descriptionFocusNode,
        cursorColor: Theme.of(context).cursorColor,
        style: Theme.of(context).textTheme.bodyText1,
        keyboardType: TextInputType.text,
        onSaved: (newValue) => description = newValue,
        onChanged: _changeDescription,
        validator: _validateDescription,
        decoration: textInputDecoration(
          error:      errors['description'],
          labelText:  AppLocalizations.of(context).translate('description'),
          hintText:   AppLocalizations.of(context).translate('hint_description'),
        ),
      ),
    );
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////

}