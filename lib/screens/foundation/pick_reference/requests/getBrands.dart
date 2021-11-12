import 'package:http/http.dart';
import 'package:mybeautyadvisor/tools/appUrl.dart';

import 'dart:convert';
import 'dart:async';
import 'dart:core';



// Get All the Brands from API
Future<List<String>>    getBrands() async {
  var   response = await get(
    AppUrl.getBrandsURL,
    headers: { 'Content-Type': 'application/json' }
  );

  // Success
  if (response.statusCode == 200)
    return (json.decode(response.body) as List<dynamic>).cast<String>();
  // Fail
  return [];
}
