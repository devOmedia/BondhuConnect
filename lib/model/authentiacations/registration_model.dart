class RegistrationModel {
  bool? success;
  String? message;
  Data? data;
  Error? error;

  RegistrationModel({this.success, this.message, this.data, this.error});

  RegistrationModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ?  Data.fromJson(json['data']) : null;
    error = json['error'] != null ?  Error.fromJson(json['error']) : null;
  }

}

class Data {
  int? otp;

  Data({this.otp});

  Data.fromJson(Map<String, dynamic> json) {
    otp = json['otp'];
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
