class HomeDataModel {
  bool? success;
  String? message;
  List<Data>? data;
  Error? error;

  HomeDataModel({this.success, this.message, this.data, this.error});

  HomeDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    error = json['error'] != null ? Error.fromJson(json['error']) : null;
  }
}

class Data {
  String? name;
  String? gender;
  int? photoId;
  int? id;
  Medium? medium;

  Data({this.name, this.gender, this.photoId, this.id, this.medium});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    gender = json['gender'];
    photoId = json['photo_id'];
    id = json['id'];
    medium = json['medium'] != null ? Medium.fromJson(json['medium']) : null;
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
