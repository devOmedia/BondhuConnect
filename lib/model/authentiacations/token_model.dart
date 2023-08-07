class TokenModel {
  bool? success;
  String? message;
  Data? data;
  Error? error;

  TokenModel({this.success, this.message, this.data, this.error});

  TokenModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ?  Data.fromJson(json['data']) : null;
    error = json['error'] != null ?  Error.fromJson(json['error']) : null;
  }

}

class Data {
  Access? access;
  Access? refresh;

  Data({this.access, this.refresh});

  Data.fromJson(Map<String, dynamic> json) {
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
