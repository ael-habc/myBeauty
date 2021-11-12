
// Check if email
bool      isEmail(String value) {
  if (value == null) return false;
  RegExp      regExp = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$');
  return regExp.hasMatch(value);
}


// Check if the Password is strong
bool      isStrongPassword(String password) {
  if (password == null || password.isEmpty) return false;

  bool  hasCase = password.contains(new RegExp(r'[a-zA-Z]'));
  bool  hasDigits = password.contains(new RegExp(r'[0-9]'));
  bool  hasSpecialCharacters = password.contains(new RegExp(r'[\^\-_@#[~`\$%^&\*\(\)\[\],;/\.!\?":\{\}\|<>\\\+]+'));

  return hasCase & hasDigits & hasSpecialCharacters;
}


// Check if it's a Name
bool      isName(String value) {
  if (value == null) return false;

  bool  hasDigits = value.contains(new RegExp(r'[0-9]'));
  bool  hasSpecialCharacters = value.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  return !hasDigits & !hasSpecialCharacters;
}


// Check if a Phone number
bool      isPhoneNumber(String value) {
  RegExp      regExp = RegExp(r'(^(?:[+0]9)?[0-9]{8,14}$)');

  //if (value == null) return f;
  value = value.trim();
  if (!regExp.hasMatch(value)) return false;
  return true;
}


// Capitalize string
String    capitalize(String value) {
  return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
}


// Check if it's numeric
bool      isNumeric(String value) {
  if (value == null) return false;
  RegExp      regExp = RegExp(r'^-?[0-9]+$');
  return regExp.hasMatch(value);
}


// Check if the string contain substring ignoring case
bool      isContainsIgnoreCase(String s1, String s2) {
  return  s1.toLowerCase().contains(
            s2.toLowerCase()
          );
}
