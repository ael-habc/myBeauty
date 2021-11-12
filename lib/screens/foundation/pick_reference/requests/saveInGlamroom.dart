import 'package:http/http.dart';

import 'package:mybeautyadvisor/constants/consts.dart';
import 'package:mybeautyadvisor/models/User.dart';
import 'package:mybeautyadvisor/tools/appUrl.dart';

import 'dart:convert';



// Save the item in the glamroom
Future<int>      saveProductInGlamroom(
  int productID,
  User user,
) async {
  // Product Data
  final Map<String, dynamic>    saveItemData = {
      'productid':    productID,
      'userid':       user.id,
      'rate':         kDefaultRate.toString(),
  };

  // Send request
  Response          response = await post(
    AppUrl.saveItemURL,
    body: json.encode(saveItemData),
    headers: {
      'Authorization':  'Bearer ' + user.token,
      'Content-Type':   'application/json',
    }
  );

  // return status
  return response.statusCode;
}