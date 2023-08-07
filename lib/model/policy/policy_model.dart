class PolicyModel {
  bool? success;
  String? message;
  List<Data>? data;
  Error? error;

  PolicyModel({this.success, this.message, this.data, this.error});

  PolicyModel.fromJson(Map<String, dynamic> json) {
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
  String? content;
  List<String>? nested;
  String? ending;

  Data({this.name, this.content, this.nested, this.ending});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    content = json['content'];
    nested = json['nested'].cast<String>();
    ending = json['ending'];
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
