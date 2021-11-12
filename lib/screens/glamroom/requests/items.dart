import 'package:http/http.dart';

import 'package:mybeautyadvisor/models/User.dart';
import 'package:mybeautyadvisor/tools/appUrl.dart';

import 'dart:convert';



//* Delete Item Request     /////////////////////////////////////////////////////
Future<int>          deleteItem({
  int productID,
  User user,
}) async {
  // Product Data
  final Map<String, dynamic>    itemData = {
      'productid':    productID,
      'userid':       user.id,
  };

  // Send request
  Response          response = await delete(
    AppUrl.deleteItemURL,
    body: json.encode(itemData),
    headers: {
      'Authorization':  'Bearer ' + user.token,
      'Content-Type':   'application/json',
    }
  );

  // return status
  return response.statusCode;
}
/////////////////////////////////////////////////////////////////////////////////

//* Edit Item Request     ///////////////////////////////////////////////////////
Future<int>          editItem({
  int productID,
  User user,
  double newRate
}) async {
  // Product Data
  final Map<String, dynamic>    itemData = {
      'productid':    productID,
      'userid':       user.id,
      'rate':         newRate.toString()
  };

  // Send request
  Response          response = await post(
    AppUrl.editItemURL,
    body: json.encode(itemData),
    headers: {
      'Authorization':  'Bearer ' + user.token,
      'Content-Type':   'application/json',
    }
  );

  // return status
  return response.statusCode;
}
//////////////////////////////////////////////////////////////////////////////////
