import 'package:firebase_chat/app/app.router.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import 'register_viewmodel.dart';

class RegisterView extends StackedView<RegisterViewModel> {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget builder(
      BuildContext context, RegisterViewModel viewModel, Widget? child) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 48),
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF43cea2), Color(0xFF185a9d)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(context),
                _buildForm(context, viewModel),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return FadeInDown(
      duration: Duration(milliseconds: 1000),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Hesap Oluştur',
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, RegisterViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FadeInUp(
        duration: Duration(milliseconds: 1000),
        child: Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Form(
            key: viewModel.formKey,
            child: Column(
              children: [
                _buildTextField(
                  controller: viewModel.emailController,
                  label: 'Email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: viewModel.validateEmail,
                ),
                SizedBox(height: 20),
                _buildPasswordField(viewModel),
                SizedBox(height: 20),
                _buildConfirmPasswordField(viewModel),
                SizedBox(height: 30),
                _buildRegisterButton(viewModel),
                SizedBox(height: 20),
                _buildLoginLink(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
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
      style: TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600]),
        prefixIcon: Icon(icon, color: Color(0xFF185a9d)),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Color(0xFF185a9d), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }

  Widget _buildPasswordField(RegisterViewModel viewModel) {
    return _buildTextField(
      controller: viewModel.passwordController,
      label: 'Şifre',
      icon: Icons.lock_outline,
      obscureText: !viewModel.isPasswordVisible,
      validator: viewModel.validatePassword,
      suffixIcon: IconButton(
        icon: Icon(
          viewModel.isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          color: Color(0xFF185a9d),
        ),
        onPressed: viewModel.togglePasswordVisibility,
      ),
    );
  }

  Widget _buildConfirmPasswordField(RegisterViewModel viewModel) {
    return _buildTextField(
      controller: viewModel.confirmPasswordController,
      label: 'Şifre Tekrar',
      icon: Icons.lock_outline,
      obscureText: !viewModel.isConfirmPasswordVisible,
      validator: viewModel.validateConfirmPassword,
      suffixIcon: IconButton(
        icon: Icon(
          viewModel.isConfirmPasswordVisible
              ? Icons.visibility
              : Icons.visibility_off,
          color: Color(0xFF185a9d),
        ),
        onPressed: viewModel.toggleConfirmPasswordVisibility,
      ),
    );
  }

  Widget _buildRegisterButton(RegisterViewModel viewModel) {
    return Container(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: viewModel.isBusy ? null : viewModel.register,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF185a9d),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
        ),
        child: viewModel.isBusy
            ? CircularProgressIndicator(color: Colors.white)
            : Text(
                'Kayıt Ol',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildLoginLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Zaten hesabın var mı?',
          style: TextStyle(color: Colors.grey[600]),
        ),
        TextButton(
          onPressed: () {
            NavigationService().navigateToLoginView();
          } ,
          child: Text(
            'Giriş Yap',
            style: TextStyle(
              color: Color(0xFF185a9d),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  @override
  RegisterViewModel viewModelBuilder(BuildContext context) =>
      RegisterViewModel();
}
