
class   UserInfos {
  String    name;
  String    email;
  String    password;
  String    phone;

  UserInfos({
    this.name = '',
    this.email = '',
    this.password = '',
    this.phone = '',
  });

  void    setName(String name) => this.name = name;
  void    setPhone(String phone) => this.phone = phone;
  void    setEmail(String email) => this.email = email;
  void    setPassword(String password) => this.password = password;
}