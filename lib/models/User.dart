// USER Model ////////////////////////////////////////////////////////////////////////

class   User {
  int         id;
  String      name;
  String      email;
  String      password;
  String      phone;
  String      photo;
  String      token;

  User({
    this.id,
    this.name,
    this.email,
    this.password,
    this.phone,
    this.photo,
    this.token,
  });

  factory   User.fromJson( Map<String, dynamic> responseData ) {
    return User(
      id:       responseData['id'],
      name:     responseData['prénom'],
      email:    responseData['email'],
      password: responseData['mdp'],
      phone:    responseData['phone'],
      token:    responseData['token'],
      photo:    responseData['photo'],
    );
  }

}

///////////////////////////////////////////////////////////////////////////////////////