class UploadMediaModel {
  bool? success;
  String? message;
  Data? data;
  Error? error;

  UploadMediaModel({this.success, this.message, this.data, this.error});

  UploadMediaModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    error = json['error'] != null ? Error.fromJson(json['error']) : null;
  }
}


class Data {
  bool? isVerified;
  int? id;
  int? userId;
  String? type;
  String? url;
  String? updatedAt;
  String? createdAt;

  Data(
      {this.isVerified,
      this.id,
      this.userId,
      this.type,
      this.url,
      this.updatedAt,
      this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    isVerified = json['isVerified'];
    id = json['id'];
    userId = json['user_id'];
    type = json['type'];
    url = json['url'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
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
