class LoginModel {
  bool? success;
  String? message;
  Data? data;
  Error? error;

  LoginModel({this.success, this.message, this.data, this.error});

  LoginModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    error = json['error'] != null ? Error.fromJson(json['error']) : null;
  }
}

class Data {
  User? user;
  Tokens? tokens;

  Data({this.user, this.tokens});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    tokens = json['tokens'] != null ? Tokens.fromJson(json['tokens']) : null;
  }
}

class User {
  int? id;
  String? name;
  String? userName;
  String? email;
  String? phone;
  String? dob;
  String? gender;
  String? photoUrl;
  String? city;
  String? address;
  String? postalCode;
  bool? isEmailVerified;
  bool? isPhoneVerified;
  String? lastLogin;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  User(
      {this.id,
      this.name,
      this.userName,
      this.email,
      this.phone,
      this.dob,
      this.gender,
      this.photoUrl,
      this.city,
      this.address,
      this.postalCode,
      this.isEmailVerified,
      this.isPhoneVerified,
      this.lastLogin,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    userName = json['user_name'];
    email = json['email'];
    phone = json['phone'];
    dob = json['dob'];
    gender = json['gender'];
    photoUrl = json['photo_url'];
    city = json['city'];
    address = json['address'];
    postalCode = json['postal_code'];
    isEmailVerified = json['isEmailVerified'];
    isPhoneVerified = json['isPhoneVerified'];
    lastLogin = json['last_login'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
  }
}

class Tokens {
  Access? access;
  Access? refresh;

  Tokens({this.access, this.refresh});

  Tokens.fromJson(Map<String, dynamic> json) {
    access = json['access'] != null ? Access.fromJson(json['access']) : null;
    refresh = json['refresh'] != null ? Access.fromJson(json['refresh']) : null;
  }
}

class Access {
  String? token;
  String? expires;

  Access({this.token, this.expires});

  Access.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    expires = json['expires'];
  }
}

class Error {
  bool? status;
  int? code;
  String? message;

  Error({this.status, this.code, this.message});

  Error.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
  }
}
