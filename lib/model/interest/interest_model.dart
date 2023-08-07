class InterestModel {
  bool? success;
  String? message;
  List<Data>? data;
  Error? error;

  InterestModel({this.success, this.message, this.data, this.error});

  InterestModel.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? name;
  bool? isActive;
  String? createdAt;
  String? updatedAt;

  Data({this.id, this.name, this.isActive, this.createdAt, this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['isActive'];
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
