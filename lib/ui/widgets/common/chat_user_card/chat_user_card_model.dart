import 'package:firebase_chat/services/apis_service.dart';
import 'package:stacked/stacked.dart';

import '../../../../helper/my_date_util.dart';
import '../../../../models/chat_user.dart';
import '../../../../models/message.dart';

class ChatUserCardModel extends BaseViewModel {
  final ChatUser user;
  Message? _lastMessage;

  ChatUserCardModel({required this.user});

  Message? get lastMessage => _lastMessage;

  Stream<List<Message>> getLastMessageStream() {
    return ApisService.getLastMessage(user).map((snapshot) {
      final data = snapshot.docs;
      final list = data.map((e) => Message.fromJson(e.data())).toList();

      if (list.isNotEmpty) {
        _lastMessage = list[0];
        notifyListeners();
      }

      return list;
    });
  }

  String getSubtitleText() {
    return _lastMessage != null
        ? (_lastMessage!.type == Type.image ? 'image' : _lastMessage!.msg)
        : user.about;
  }

  bool hasUnreadMessage() {
    return _lastMessage != null &&
        _lastMessage!.read.isEmpty &&
        _lastMessage!.fromId != ApisService.user.uid;
  }

  String getLastMessageTime(context) {
    return _lastMessage != null
        ? MyDateUtil.getLastMessageTime(
            context: context, time: _lastMessage!.sent)
        : '';
  }
}
