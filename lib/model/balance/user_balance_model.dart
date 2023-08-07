class UserBalanceModel {
  bool? success;
  String? message;
  Data? data;
  Error? error;

  UserBalanceModel({this.success, this.message, this.data, this.error});

  UserBalanceModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    error = json['error'] != null ? Error.fromJson(json['error']) : null;
  }
}

class Data {
  int? id;
  int? userId;
  int? sms;
  int? voice;
  int? video;
  int? amount;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.userId,
      this.sms,
      this.voice,
      this.video,
      this.amount,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    sms = json['sms'];
    voice = json['voice'];
    video = json['video'];
    amount = json['amount'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
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
