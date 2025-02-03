import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'login_viewmodel.dart';

class LoginView extends StackedView<LoginViewModel> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget builder(
      BuildContext context, LoginViewModel viewModel, Widget? child) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 48),
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2193b0), Color(0xFF6dd5ed)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildBackButton(context),
                  const SizedBox(height: 50),
                  _buildTitle(),
                  const SizedBox(height: 40),
                  _buildLoginForm(viewModel, context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return FadeInDown(
      duration: const Duration(milliseconds: 1000),
      child: Text(
        "Firebase Chat",
        style: GoogleFonts.poppins(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildLoginForm(LoginViewModel viewModel, BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 1000),
      delay: const Duration(milliseconds: 500),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 15,
            ),
          ],
        ),
        child: Form(
          key: viewModel.formKey,
          child: Column(
            children: [
              _buildTextField(
                controller: viewModel.emailController,
                icon: Icons.email_outlined,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) => viewModel.validateEmail(value),
              ),
              const SizedBox(height: 20),
              _buildPasswordField(viewModel),
              const SizedBox(height: 30),
              _buildLoginButton(viewModel),
              const SizedBox(height: 20),
              _buildBottomLinks(viewModel, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF2193b0)),
        suffixIcon: suffixIcon,
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2193b0), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }

  Widget _buildPasswordField(LoginViewModel viewModel) {
    return _buildTextField(
      controller: viewModel.passwordController,
      icon: Icons.lock_outline,
      label: 'Şifre',
      obscureText: !viewModel.isPasswordVisible,
      suffixIcon: IconButton(
        icon: Icon(
          viewModel.isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          color: const Color(0xFF2193b0),
        ),
        onPressed: viewModel.togglePasswordVisibility,
      ),
      validator: (value) => viewModel.validatePassword(value),
    );
  }

  Widget _buildLoginButton(LoginViewModel viewModel) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: viewModel.isLoading ? null : viewModel.handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2193b0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
        ),
        child: viewModel.isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'Giriş Yap',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildBottomLinks(LoginViewModel viewModel, BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: viewModel.handleForgotPassword,
          child: const Text(
            'Şifremi Unuttum',
            style: TextStyle(
              color: Color(0xFF2193b0),
              fontSize: 16,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hesabın yok mu? ',
              style: TextStyle(color: Colors.grey[600]),
            ),
            TextButton(
              onPressed: () => viewModel.navigateToRegister(),
              child: const Text(
                'Kayıt ol',
                style: TextStyle(
                  color: Color(0xFF2193b0),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  LoginViewModel viewModelBuilder(BuildContext context) => LoginViewModel();
}
