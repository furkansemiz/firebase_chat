import 'package:firebase_chat/services/apis_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'dart:developer';

import '../../../../helper/dialogs.dart';
import '../../../../models/message.dart';

class MessageCardModel extends BaseViewModel {
  final Message message;
  late final String _currentUserId;

  MessageCardModel(this.message) {
    _currentUserId = ApisService.user.uid;
    notifyListeners();
  }

  bool get isMe {
    final result = _currentUserId == message.fromId;
    print('IsMe check: Current UID: $_currentUserId, Message FromId: ${message.fromId}, Result: $result');
    return result;
  }

  void copyMessage(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: message.msg)).then((value) {
      if (context.mounted) {
        Dialogs.showSnackbar(context, 'Kopyalandı!');
      }
    });
  }

  void saveImage(BuildContext context) async {
    try {
      log('Image Url: ${message.msg}');
      await GallerySaver.saveImage(message.msg, albumName: 'Chat Case APP')
          .then((success) {
        if (context.mounted) {
          if (success != null && success) {
            Dialogs.showSnackbar(context, 'Resim başarıyla kaydedildi!');
          }
        }
      });
    } catch (e) {
      log('ErrorWhileSavingImg: $e');
    }
  }

  void updateMessage(BuildContext context, String updatedMsg) {
    ApisService.updateMessage(message, updatedMsg);
  }

  void deleteMessage(BuildContext context) async {
    await ApisService.deleteMessage(message);
  }
}
