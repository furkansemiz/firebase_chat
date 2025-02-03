import 'package:firebase_chat/app/app.locator.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class NavigatorService {
  final navigatorKey = StackedService.navigatorKey;

  void showErrorMessage(String message) {
    _showMessage(message, Colors.red);
  }

  void showSuccessMessage(String message) {
    _showMessage(message, Colors.green);
  }

  void _showMessage(String message, Color backgroundColor) {
    print(navigatorKey!.currentContext);
    if (navigatorKey!.currentContext != null) {
      ScaffoldMessenger.of(navigatorKey!.currentContext!).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }
}
