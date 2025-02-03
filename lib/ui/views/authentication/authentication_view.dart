import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'authentication_viewmodel.dart';

class AuthenticationView extends StackedView<AuthenticationViewmodel> {
  const AuthenticationView({Key? key}) : super(key: key);

  @override
  Widget builder(
      BuildContext context, AuthenticationViewmodel viewModel, Widget? child) {
    final mq = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF43cea2),
              Color(0xFF185a9d),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Header Section
              FadeInDown(
                duration: Duration(milliseconds: 1500),
                child: Padding(
                  padding: EdgeInsets.only(top: mq.height * 0.1),
                  child: Column(
                    children: [
                      // App Logo
                      AnimatedContainer(
                        duration: Duration(seconds: 1),
                        curve: Curves.easeInOut,
                        height: viewModel.isAnimate ? mq.height * 0.2 : 0,
                        child: Image.asset(
                          'assets/images/icon.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Firebase Chat',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Case Study',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Login Buttons Section
              FadeInUp(
                duration: Duration(milliseconds: 1500),
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildButton(
                        icon: Icons.email_outlined,
                        text: 'Email ile giriş yap',
                        onPressed: viewModel.navigateToEmailLogin,
                      ),
                      SizedBox(height: 15),
                      _buildButton(
                        icon: Icons.person_add_outlined,
                        text: 'Hesap oluştur',
                        color: Color(0xFF185a9d),
                        onPressed: viewModel.navigateToRegister,
                      ),
                      SizedBox(height: 15),
                      _buildButton(
                        customIcon: Image.asset(
                          'assets/images/google.png',
                          height: 24,
                        ),
                        text: 'Google ile devam et',
                        color: Colors.red,
                        onPressed: () => viewModel.handleGoogleLogin(context),
                      ),
                      SizedBox(height: mq.height * 0.05),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    IconData? icon,
    Widget? customIcon,
    required String text,
    required VoidCallback onPressed,
    Color color = const Color(0xFF43cea2),
  }) {
    return Container(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: color,
          backgroundColor: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: color, width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) Icon(icon, size: 24),
            if (customIcon != null) customIcon,
            SizedBox(width: 12),
            Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  AuthenticationViewmodel viewModelBuilder(BuildContext context) =>
      AuthenticationViewmodel();
}
