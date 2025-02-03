import 'package:firebase_chat/app/app.router.dart';
import 'package:firebase_chat/services/apis_service.dart';
import 'package:firebase_chat/services/navigator_service.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';

class LoginViewModel extends BaseViewModel {
  final _authService = ApisService();
  final _navigationService = NavigationService();
  final _navigatorService = locator<NavigatorService>();

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;

  bool get isLoading => _isLoading;
  bool get isPasswordVisible => _isPasswordVisible;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lütfen email adresinizi girin';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lütfen şifrenizi girin';
    }
    return null;
  }

  Future<void> handleLogin() async {
    if (formKey.currentState!.validate()) {
      _isLoading = true;
      notifyListeners();

      final result = await _authService.signIn(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      _isLoading = false;
      notifyListeners();

      if (result == null) {
        await _navigationService.replaceWithHomeView();
      } else {
        _navigatorService.showErrorMessage(result);
      }
    }
  }

  Future<void> handleForgotPassword() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      _navigatorService.showErrorMessage('Lütfen email adresinizi girin');
      return;
    }

    _isLoading = true;
    notifyListeners();

    final result = await _authService.resetPassword(email: email);

    _isLoading = false;
    notifyListeners();

    if (result == null) {
      _navigatorService.showSuccessMessage(
          'Şifre sıfırlama bağlantısı emailinize gönderildi');
    } else {
      _navigatorService.showErrorMessage(result);
    }
  }

  void navigateToRegister() {
    _navigationService.navigateToRegisterView();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
