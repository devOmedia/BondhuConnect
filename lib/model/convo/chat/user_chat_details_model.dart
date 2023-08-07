class UserChatDetailsModel {
  bool? success;
  String? message;
  Data? data;
  Error? error;

  UserChatDetailsModel({this.success, this.message, this.data, this.error});

  UserChatDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    error = json['error'] != null ? Error.fromJson(json['error']) : null;
  }
}

class Data {
  int? id;
  User? user;
  bool? isBlocked;
  List<Conversations>? conversations;

  Data({this.id, this.user, this.isBlocked, this.conversations});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    isBlocked = json['isBlocked'];
    if (json['conversations'] != null) {
      conversations = <Conversations>[];
      json['conversations'].forEach((v) {
        conversations!.add(Conversations.fromJson(v));
      });
    }
  }
}

class User {
  String? name;
  int? id;
  String? photoId;
  String? medium;

  User({this.name, this.id, this.photoId, this.medium});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    photoId = json['photo_id'];
    medium = json['medium'];
  }
}

class Conversations {
  int? id;
  String? type;
  String? content;
  bool? isSeen;
  bool? isSender;
  String? createdAt;

  Conversations(
      {this.id,
      this.type,
      this.content,
      this.isSeen,
      this.isSender,
      this.createdAt});

  Conversations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    content = json['content'];
    isSeen = json['isSeen'];
    isSender = json['isSender'];
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
