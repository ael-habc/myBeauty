import 'package:flutter/material.dart';
import 'package:mybeautyadvisor/models/User.dart';

class   UserProvider with ChangeNotifier {
  User  _user = User();

  User  get user => _user;

  void    setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void    initUser(User user) {
    _user = user;
  }

  void    setName(String name) {
    _user.name = name;
    notifyListeners();
  }

  void    setPhone(String phone) {
    _user.phone = phone;
    notifyListeners();
  }

  void    setPhoto(String photo) {
    _user.photo = photo;
    notifyListeners();
  }
}
