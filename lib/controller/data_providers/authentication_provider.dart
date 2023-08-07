import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationProvider extends ChangeNotifier {
  File? firstImage;
  File? secondImage;
  File? thirdImage;
  File? forthImage;
  File? fivethImage;
  File? video;
  Map mediaID =
      {}; // store the image id to delete the image // video index is 0.

//store the images
  setFirstImage(File image) {
    firstImage = image;
    notifyListeners();
  }

  setSecondImage(File image) {
    secondImage = image;
    notifyListeners();
  }

  setThirdImage(File image) {
    thirdImage = image;
    notifyListeners();
  }

  setForthImage(File image) {
    forthImage = image;
    notifyListeners();
  }

  setFivethImage(File image) {
    fivethImage = image;
    notifyListeners();
  }

  setVideo(File file) {
    video = file;
    notifyListeners();
  }

  setMediaID(int mediaIndex, int id) {
    mediaID.addAll({mediaIndex: id});
  }

  deleteMedia(int imageOrder) {
    switch (imageOrder) {
      case 0:
        video = null;
        break;
      case 1:
        firstImage = null;
        break;
      case 2:
        secondImage = null;
        break;
      case 3:
        thirdImage = null;
        break;
      case 4:
        forthImage = null;
        break;
      default:
        fivethImage = null;
    }
    notifyListeners();
  }
}

final authProvider = ChangeNotifierProvider<AuthenticationProvider>((ref) {
  return AuthenticationProvider();
});


