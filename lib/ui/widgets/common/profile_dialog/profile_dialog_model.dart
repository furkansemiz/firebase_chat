// profile_dialog_view_model.dart
import 'package:firebase_chat/app/app.locator.dart';
import 'package:firebase_chat/app/app.router.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../../models/chat_user.dart';
import '../../../views/profile_view/profile_view_view.dart';

class ProfileDialogModel {
  final ChatUser user;

  ProfileDialogModel({required this.user});

  void navigateToProfileDetails(BuildContext context) {
    // Close the dialog
    Navigator.pop(context);

    // Navigate to view profile screen
    locator<NavigationService>().navigateToViewProfileScreen(user: user);
  }
}
