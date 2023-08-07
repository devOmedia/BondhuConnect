class LoginWithOTPModel {
  bool? success;
  String? message;
  Data? data;
  Error? error;

  LoginWithOTPModel({this.success, this.message, this.data, this.error});

  LoginWithOTPModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ?  Data.fromJson(json['data']) : null;
    error = json['error'] != null ?  Error.fromJson(json['error']) : null;
  }

}

class Data {
  User? user;
  Tokens? tokens;

  Data({this.user, this.tokens});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ?  User.fromJson(json['user']) : null;
    tokens =
        json['tokens'] != null ?  Tokens.fromJson(json['tokens']) : null;
  }

}

class User {
  int? id;
  String? name;
  String? about;
  String? userName;
  String? email;
  String? phone;
  String? dob;
  String? gender;
  int? photoId;
  String? city;
  String? address;
  String? postalCode;
  bool? isEmailVerified;
  bool? isPhoneVerified;
  String? lastLogin;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  Medium? medium;

  User(
      {this.id,
      this.name,
      this.about,
      this.userName,
      this.email,
      this.phone,
      this.dob,
      this.gender,
      this.photoId,
      this.city,
      this.address,
      this.postalCode,
      this.isEmailVerified,
      this.isPhoneVerified,
      this.lastLogin,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.medium});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    about = json['about'];
    userName = json['user_name'];
    email = json['email'];
    phone = json['phone'];
    dob = json['dob'];
    gender = json['gender'];
    photoId = json['photo_id'];
    city = json['city'];
    address = json['address'];
    postalCode = json['postal_code'];
    isEmailVerified = json['isEmailVerified'];
    isPhoneVerified = json['isPhoneVerified'];
    lastLogin = json['last_login'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    medium =
        json['medium'] != null ?  Medium.fromJson(json['medium']) : null;
  }
}

class Medium {
  int? id;
  int? userId;
  String? type;
  String? url;
  bool? isVerified;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  Medium(
      {this.id,
      this.userId,
      this.type,
      this.url,
      this.isVerified,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  Medium.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    type = json['type'];
    url = json['url'];
    isVerified = json['isVerified'];
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
    access =
        json['access'] != null ?  Access.fromJson(json['access']) : null;
    refresh =
        json['refresh'] != null ?  Access.fromJson(json['refresh']) : null;
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
