import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mybeautyadvisor/models/User.dart';
import 'dart:async';

// User                    ////////////////////////////////////////////////////////////////
class   UserPreferences {

  // Save
  saveUser(User user) async {
    final SharedPreferences   space = await SharedPreferences.getInstance();

    space.setInt("id", user.id);
    space.setString("name", user.name);
    space.setString("email", user.email);
    space.setString("phone", user.phone ?? '');
    space.setString("photo", user.photo ?? '');
    space.setString("token", user.token);
  }

  // Modify Picture
  setPhoto(String imageURL) async {
    final SharedPreferences   space = await SharedPreferences.getInstance();
    space.setString("photo", imageURL);
  }

  // Get
  Future<User>    getUser() async {
    final SharedPreferences   space = await SharedPreferences.getInstance();
    String      phone;
    String      photo;
  
    // Get phone
    phone = (
      space.getString("phone") != null &&
      space.getString("phone").isNotEmpty
    ) ?
      space.getString("phone") : null;

    // Get photo
    photo = (
      space.getString("photo") != null &&
      space.getString("photo").isNotEmpty
    ) ?
      space.getString("photo") : null;
    
    return User(
      id:       space.getInt("id"),
      name:     space.getString("name"),
      email:    space.getString("email"),
      phone:    phone,
      photo:    photo,
      token:    space.getString("token"),
    );
  }

  // Remove
  removeUser() async {
    final SharedPreferences   space = await SharedPreferences.getInstance();

    space.remove("id");
    space.remove("name");
    space.remove("email");
    space.remove("phone");
    space.remove("photo");
  }

  // Get Token
  Future<String>  getToken() async {
    final SharedPreferences   space = await SharedPreferences.getInstance();
    return space.getString("token");
  }

  // Set Token
  setToken(String newToken) async {
    final SharedPreferences   space = await SharedPreferences.getInstance();
    space.setString("token", newToken);
  }

}
///////////////////////////////////////////////////////////////////////////////////////

// Theme      /////////////////////////////////////////////////////////////////////////
class     ThemePreferences {

  // Get
  Future<ThemeMode>  getTheme() async {
    final SharedPreferences   space = await SharedPreferences.getInstance();
    final String              theme = space.getString("theme");
  
    if (theme == 'light')
      return ThemeMode.light;
    else if (theme == 'dark')
      return ThemeMode.dark;
    return null;
  }
}
///////////////////////////////////////////////////////////////////////////////////////
