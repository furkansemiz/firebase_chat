import 'package:firebase_chat/app/app.locator.dart';
import 'package:firebase_chat/app/app.router.dart';
import 'package:firebase_chat/services/apis_service.dart';
import 'package:firebase_chat/services/dialog_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../models/chat_user.dart';

class HomeViewModel extends BaseViewModel with WidgetsBindingObserver {
  final NavigationService _navigationService = NavigationService();
  final DialogsService _dialogService = DialogsService();

  List<dynamic> _userList = [];
  List<dynamic> get userList => _userList;

  final List<ChatUser> _searchList = [];
  List<ChatUser> get searchList => _searchList;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  Stream get userIdsStream => ApisService.getMyUsersId();

  void initialise() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void init() async{
    await ApisService.getSelfInfo();
    ApisService.getMyUsersId();
    setupLifecycleHandler();
  }

  void setupLifecycleHandler() {
    // Mevcut handler'ı temizle
    SystemChannels.lifecycle.setMessageHandler(null);

    // Yeni handler'ı ayarla
    SystemChannels.lifecycle.setMessageHandler((message) async {
      print('Lifecycle event: $message');

      if (ApisService.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          print('App resumed - setting status to online');
          await ApisService.updateActiveStatus(true);
        }
        if (message.toString().contains('pause') ||
            message.toString().contains('inactive') ||
            message.toString().contains('detached')) {
          print('App paused/inactive - setting status to offline');
          await ApisService.updateActiveStatus(false);
        }
      }
      return message;
    });
  }

  Stream getAllUsers(List<String> userIds) => ApisService.getAllUsers(userIds);

  bool handleUsersSnapshot(AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      final data = snapshot.data?.docs;
      _userList = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
      return _userList.isNotEmpty;
    }
    return false;
  }

  void toggleSearch() {
    _isSearching = !_isSearching;
    notifyListeners();
  }

  void handleSearch(String val) {
    _searchList.clear();
    val = val.toLowerCase();

    for (var user in _userList) {
      if (user.name.toLowerCase().contains(val) ||
          user.email.toLowerCase().contains(val)) {
        _searchList.add(user);
      }
    }
    notifyListeners();
  }

  void handleBackPress(BuildContext context) {
    if (_isSearching) {
      toggleSearch();
      return;
    }
    Future.delayed(const Duration(milliseconds: 300), SystemNavigator.pop);
  }

  Future<void> showAddUserDialog(BuildContext context) async {
    final email = await _dialogService.showAddUserDialog(context);
    if (email != null && email.isNotEmpty) {
      _handleAddUser(context, email);
    }
  }

  Future<void> _handleAddUser(BuildContext context, String email) async {
    try {
      final result = await ApisService.addChatUser(email.trim());
      if (result) {
        DialogsService.showSuccessSnackBar (context, 'Kullanıcı eklendi!');
      } else {
        DialogsService.showErrorSnackBar(context, 'Kullanıcı bulunamadı!');
      }
    } catch (e) {
      DialogsService.showErrorSnackBar(
          context, 'Bir hata oluştu! Lütfen tekrar deneyin.');
    }
  }

  void navigateToProfile(BuildContext context) async{
    await ApisService.getSelfInfo();
    _navigationService.navigateToProfileScreen(user: ApisService.me);
  }
}
