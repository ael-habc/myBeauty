

class   AppUrl {
  //// Strings
  static const String     baseString =      "https://cosmecode.com/api";

  //// Urls
  static var      baseURL =           Uri.https(baseString, '/');
  static var      loginURL =          Uri.parse(baseString + "/login");                 // POST
  static var      registerURL =       Uri.parse(baseString + "/register");              // POST
  static var      getBrandsURL =      Uri.parse(baseString + "/get/brands");            // GET
  static var      getMatchsURL =      Uri.parse(baseString + "/get/match");             // POST
  static var      sendAlertURL =      Uri.parse(baseString + "/request");               // POST
  static var      editProfilURL =     Uri.parse(baseString + "/users/editProfile");     // POST
  static var      editUserPhotoURL =  Uri.parse(baseString + "/users/editPhoto");       // POST
  static var      changePasswordURL = Uri.parse(baseString + "/users/editPwd");         // POST
  static var      saveItemURL =       Uri.parse(baseString + "/users/addProduct");      // POST
  static var      editItemURL =       Uri.parse(baseString + "/users/editProduct");     // POST
  static var      deleteItemURL =     Uri.parse(baseString + "/users/delProduct");      // DELETE
  static var      refreshTokenURL =   Uri.parse(baseString + "/users/refreshToken");    // POST
  static var      addNpsURL =         Uri.parse(baseString + "/users/addNps");          // POST
  static var      getOtpURL =         Uri.parse(baseString + "/sendToken");             // POST
  static var      loginOtpURL =       Uri.parse(baseString + "/resetPwd");
  /// NEW ENDPOINTS !!!              // POST
  static var      getNewBrandsURL =   Uri.parse(baseString + "/v01/get/newbrands");     // GET
  static var      getNewMatchsURL =   Uri.parse(baseString + "v01/get/match");          // POST

  static          getProductsURL(String brand)      => Uri.parse(baseString + "/get/products/" + brand);                      // GET
  static          getShadesURL(String name)         => Uri.parse(baseString + "/get/shades/" + name);                         // GET
  static          getAllItemsURL(int userID)        => Uri.parse(baseString + "/users/getProducts/" + userID.toString());     // GET
  static          checkNpsURL(int userID)           => Uri.parse(baseString + "/users/checkNps/" + userID.toString());        // GET
  //// NEW ENDPOINTS !!!
  static          getNewProductsURL(String brandID)   => Uri.parse(baseString + "/v01/get/newproducts/" + brandID);           // GET
  static          getNewShadesURL(String nameID)      => Uri.parse(baseString + "/v01/get/newshades/" + nameID);              // GET
}
