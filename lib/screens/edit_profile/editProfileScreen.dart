import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mybeautyadvisor/components/profilImageBorder.dart';
import 'package:mybeautyadvisor/components/profilImageEmpty.dart';
import 'package:provider/provider.dart';

import 'package:mybeautyadvisor/app_localizations.dart';
import 'package:mybeautyadvisor/providers/user.dart';
import 'package:mybeautyadvisor/models/User.dart';

import 'package:mybeautyadvisor/components/iconTextButton.dart';
import 'package:mybeautyadvisor/components/defaultButton.dart';

import 'package:mybeautyadvisor/constants/consts.dart';
import 'package:mybeautyadvisor/tools/myNavigator.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';

import 'components/userInfosForm.dart';
import 'components/iconText.dart';


// Photo enum
enum PhotoPlace       { camera, gallery }




class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final             picker = ImagePicker();
  LoadingState      photoStatus = LoadingState.none;


  @override
  Widget build(BuildContext context) {
    User     user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      // AppBar
      appBar: AppBar(
        title: Text(""),
      ),

      // Body
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget> [

                //// Change image
                Padding(
                  padding: EdgeInsets.only(
                    bottom: getProportionateScreenHeight(16),
                  ),
                  child: ProfilImageBorder(
                    radius: 65,
                    childWidget: ProfilImageEmpty(
                      userName: user.name,
                    ),
                  ),
                ),

                //// Success Message
                if (photoStatus == LoadingState.success)
                  IconText(
                    iconData: CupertinoIcons.check_mark,
                    text: AppLocalizations.of(context).translate('edit-profil_photo_sucess'),
                    color: Colors.green,
                  ),

                //// Erorr Message
                if (photoStatus == LoadingState.error)
                  IconText(
                    iconData: CupertinoIcons.exclamationmark_octagon,
                    text: AppLocalizations.of(context).translate('edit-profil_photo_error'),
                    color: Colors.red,
                  ),

                //// Timeout message
                if (photoStatus == LoadingState.timeout)
                  IconText(
                    iconData: CupertinoIcons.timer,
                    text: AppLocalizations.of(context).translate('timeout'),
                    color: Theme.of(context).disabledColor,
                  ),

                Divider(),

                //// User Infos Form
                UserInfosForm(),
                Divider(),
                
                //// Change password Button
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: getProportionateScreenHeight(20),
                  ),
                  child: IconTextButton(
                    text: AppLocalizations.of(context).translate('change-password'),
                    textColor: Colors.black87,
                    iconData: CupertinoIcons.lock,
                    color: kPrimaryLightColor,
                    fontSize: 16,
                    width: SizeConfig.screenWidth * 0.6,
                    press: () => MyNavigator.goChangePassword(context),
                  ),
                ),

                //// Cancel Button
                DefaultButton(
                  text: AppLocalizations.of(context).translate('cancel'),
                  color: CupertinoColors.systemGrey,
                  fontSize: 16,
                  width: SizeConfig.screenWidth * 0.6,
                  press: () => Navigator.pop(context),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
