import 'dart:developer';
import 'dart:io';
import 'package:firebase_chat/app/app.locator.dart';
import 'package:firebase_chat/app/app.router.dart';
import 'package:firebase_chat/services/apis_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../helper/my_date_util.dart';
import '../../../models/chat_user.dart';
import '../../../models/message.dart';
import '../profile_view/profile_view_view.dart';

class ChatViewModel extends BaseViewModel {
  late ChatUser user;
  final TextEditingController textController = TextEditingController();
  bool _showEmoji = false;
  bool _isUploading = false;

  ChatViewModel({required this.user});

  bool get showEmoji => _showEmoji;
  bool get isUploading => _isUploading;

  Stream get messagesStream => ApisService.getAllMessages(user);
  Stream get userInfoStream => ApisService.getUserInfo(user);

  List<dynamic> getMessagesFromSnapshot(AsyncSnapshot snapshot) {
    final data = snapshot.data?.docs;
    return data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
  }

  ChatUser? getUserFromSnapshot(AsyncSnapshot snapshot) {
    final data = snapshot.data?.docs;
    final list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
    return list.isNotEmpty ? list[0] : null;
  }

  String getLastActiveText(ChatUser? userData, BuildContext buildCont) {
    if (userData == null) {
      return MyDateUtil.getLastActiveTime(
          context: buildCont, lastActive: user.lastActive);
    }
    return userData.isOnline
        ? 'Online'
        : MyDateUtil.getLastActiveTime(
            context: buildCont, lastActive: userData.lastActive);
  }

  void toggleEmoji(BuildContext context) {
    FocusScope.of(context).unfocus();
    _showEmoji = !_showEmoji;
    notifyListeners();
  }

  void onTextFieldTap() {
    if (_showEmoji) {
      _showEmoji = false;
      notifyListeners();
    }
  }

  Future<void> pickMultipleImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage(imageQuality: 70);

    for (var image in images) {
      log('Image Path: ${image.path}');
      _isUploading = true;
      notifyListeners();

      await ApisService.sendChatImage(user, File(image.path));

      _isUploading = false;
      notifyListeners();
    }
  }

  Future<void> pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 70);

    if (image != null) {
      log('Image Path: ${image.path}');
      _isUploading = true;
      notifyListeners();

      await ApisService.sendChatImage(user, File(image.path));

      _isUploading = false;
      notifyListeners();
    }
  }

  void sendMessage() {
    if (textController.text.isNotEmpty) {
      if (getMessagesFromSnapshot(AsyncSnapshot.nothing()).isEmpty) {
        ApisService.sendFirstMessage(user, textController.text, Type.text);
      } else {
        ApisService.sendMessage(user, textController.text, Type.text);
      }
      textController.clear();
    }
  }

  void handlePopScope(BuildContext context) {
    if (_showEmoji) {
      _showEmoji = !_showEmoji;
      notifyListeners();
      return;
    }


  }

  void navigateToProfile(BuildContext context) {
    locator<NavigationService>().navigateToViewProfileScreen(user: user);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
