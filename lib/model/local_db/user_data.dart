import 'package:shared_preferences/shared_preferences.dart';


class UserData {
  // set the access token
  static setAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("access", token);
  }

//get the access token
  static getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("access");
  }

//set the refresh token
  static setRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("refresh", token);
  }

//get the refresh token
  static getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("refresh");
  }

  //store the device id
  static setTheDeviceID(String id) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("deviceID", id);
  }

  //get the device id
  static getDeviceID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("deviceID");
  }

  //delete the storage
  static deleteMemory() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  //remove the tokens
  static deleteToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove("access");
    await preferences.remove("refresh");
  }

  //store user object
  static setUser(dynamic user) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("id", user.id.toString()); //
    await preferences.setString("name", user.name.toString()); //
  }

  static getUserID() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("id");
  }

  static getUserName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("name");
  }

//store the access token life time.
  static setAccessTokenExpireTime(String time) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setString("accessExpire", time);
  }

//store the refresh token life time.
  static setRefreshTokenExpireTime(String time) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setString("refreshToken", time);
  }

  static getRefreshTokenExpireTime() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.getString("refreshToken");
  }

//get the token expire time
  static getAccessTokenExpireTime() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.getString("accessExpire");
  }
}
