import 'package:firebase_chat/app/app.locator.dart';
import 'package:firebase_chat/app/app.router.dart';
import 'package:firebase_chat/services/apis_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewmodel extends BaseViewModel {
  final _navigationService = NavigationService();

  void initialize() {
    // Exit full-screen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      statusBarColor: Colors.white,
    ));

    Future.delayed(const Duration(seconds: 2), () {
      _navigateBasedOnAuthStatus();
    });
  }

  void _navigateBasedOnAuthStatus() {
    if (ApisService.auth.currentUser != null) {
      _navigationService.replaceWith(Routes.homeView);
    } else {
      _navigationService.replaceWith(Routes.authenticationView);
    }
  }
}