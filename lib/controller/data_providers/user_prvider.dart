import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProvider {
  String? id;
  String? name;


  setData({ID, Name}) {
    id = ID;
    name = Name;
  }
}

final userProvider =
    StateProvider<UserProvider>((ref) {
  return UserProvider();
});


