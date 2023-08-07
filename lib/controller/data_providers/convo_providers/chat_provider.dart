import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/convo/chat/user_chat_details_model.dart';

class ConvoHistory extends ChangeNotifier {
  final List<Conversations> convoList = []; //list to store the conversations.
// add to the list
  setInitConvo(List<Conversations> conversations) {
    //store all conversation first time..
    convoList.addAll(conversations);
    notifyListeners();
  }

  setConvo(Conversations convo) {
    convoList.add(convo);
    notifyListeners();
  }

  resetHistory() {
    convoList.clear();
  }
}

final convoHistoryProvider = ChangeNotifierProvider<ConvoHistory>((ref) {
  return ConvoHistory();
});
