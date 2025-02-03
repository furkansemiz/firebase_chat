import 'dart:developer';
import 'package:firebase_chat/services/apis_service.dart';
import 'package:firebase_chat/services/navigator_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';

class AuthenticationViewmodel extends BaseViewModel {
  final _navigatorService = NavigatorService();
  final _navigationService = NavigationService();
  final _authService = ApisService();
  final _dialogService = DialogService();

  bool _isAnimate = false;
  bool get isAnimate => _isAnimate;

  LoginViewModel() {
    _initAnimation();
  }

  void _initAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _isAnimate = true;
    notifyListeners();
  }

  Future<void> handleGoogleLogin(BuildContext context) async {
    setBusy(true);
    try {
      final success = await _authService.signInWithGoogle(context);
      if (success != null) {
        await _navigationService.replaceWith(Routes.homeView);
      }
    } catch (e) {
      log('Google login error: $e');
      await _dialogService.showDialog(
        title: 'Error',
        description:
            'Something went wrong. Please check your internet connection.',
      );
    }
    setBusy(false);
  }

  void navigateToEmailLogin() {
    _navigationService.navigateToLoginView();
  }

  void navigateToRegister() {
    _navigationService.navigateToRegisterView();
  }
}
