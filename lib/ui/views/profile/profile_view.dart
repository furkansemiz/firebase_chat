import 'dart:io';
import 'package:firebase_chat/services/apis_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../models/chat_user.dart';
import 'profile_viewmodel.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _aboutFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _aboutController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _aboutController = TextEditingController(text: widget.user.about);
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _aboutFocusNode.dispose();
    _nameController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      viewModelBuilder: () => ProfileViewModel(user: widget.user),
      builder: (context, viewModel, child) => GestureDetector(
        onTap: () {
          if (!_nameFocusNode.hasFocus && !_aboutFocusNode.hasFocus) {
            FocusScope.of(context).unfocus();
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.grey[100],
          extendBodyBehindAppBar: true,
          appBar: _buildAppBar(context, viewModel),
          body: _buildBody(context, viewModel),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, ProfileViewModel viewModel) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: _buildBackButton(context),
      actions: [_buildLogoutButton(context, viewModel)],
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.arrow_back, color: Colors.black87),
      ),
      onPressed: () => Navigator.pop(context),
    );
  }

  Widget _buildLogoutButton(BuildContext context, ProfileViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: GestureDetector(
        onTap: () => _showLogoutDialog(context, viewModel),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.logout_rounded, color: Colors.redAccent),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ProfileViewModel viewModel) {
    final bool isTablet = MediaQuery.of(context).size.width > 600;

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        children: [
          _buildProfileHeader(context, viewModel, isTablet),
          _buildProfileForm(context, viewModel, isTablet),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, ProfileViewModel viewModel, bool isTablet) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue[400]!,
            Colors.blue[800]!,
          ],
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.08),
          _buildProfileImage(context, viewModel, isTablet),
          const SizedBox(height: 20),
          Text(
            viewModel.user.email,
            style: TextStyle(
              color: Colors.white,
              fontSize: isTablet ? 18 : 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          _buildStatusChip(),
        ],
      ),
    );
  }

  Widget _buildProfileImage(BuildContext context, ProfileViewModel viewModel, bool isTablet) {
    double imageSize = isTablet ? 180 : 120;
    return Stack(
      children: [
        Container(
          width: imageSize,
          height: imageSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(imageSize),
            child: viewModel.profileImage != null
                ? Image.file(
              File(viewModel.profileImage!),
              fit: BoxFit.cover,
            )
                : CachedNetworkImage(
              imageUrl: viewModel.user.image,
              fit: BoxFit.cover,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
              const Icon(Icons.person, size: 60),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => _showImagePickerModal(context, viewModel),
            child: Container(
              padding: EdgeInsets.all(isTablet ? 12 : 8),
              decoration: BoxDecoration(
                color: Colors.blue[600],
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Icon(
                Icons.camera_alt_rounded,
                color: Colors.white,
                size: isTablet ? 28 : 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 8,
            height: 8,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(width: 8),
          Text(
            'Online',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileForm(BuildContext context, ProfileViewModel viewModel, bool isTablet) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? MediaQuery.of(context).size.width * 0.1 : 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kişisel Bilgiler',
              style: TextStyle(
                fontSize: isTablet ? 24 : 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 25),
            _buildTextField(
              label: 'Ad Soyad',
              icon: Icons.person_outline_rounded,
              controller: _nameController,
              focusNode: _nameFocusNode,
              isTablet: isTablet,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'Hakkında',
              icon: Icons.info_outline_rounded,
              controller: _aboutController,
              focusNode: _aboutFocusNode,
              maxLines: 3,
              isTablet: isTablet,
            ),
            const SizedBox(height: 40),
            _buildUpdateButton(context, viewModel, isTablet),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required FocusNode focusNode,
    int maxLines = 1,
    required bool isTablet,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        maxLines: maxLines,
        validator: (val) => val != null && val.isNotEmpty ? null : 'Zorunlu',
        style: TextStyle(
          fontSize: isTablet ? 18 : 16,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: isTablet ? 16 : 14,
          ),
          prefixIcon: Icon(icon, color: Colors.blue[600]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: maxLines > 1 ? 20 : 0,
          ),
        ),
      ),
    );
  }

  Widget _buildUpdateButton(
      BuildContext context,
      ProfileViewModel viewModel,
      bool isTablet,
      ) {
    return SizedBox(
      width: double.infinity,
      height: isTablet ? 60 : 50,
      child: ElevatedButton(
        onPressed: viewModel.isBusy
            ? null
            : () {
          if (_formKey.currentState!.validate()) {
            viewModel.updateProfileInfo(
              _nameController.text,
              _aboutController.text,
              context,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[600],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
        ),
        child: viewModel.isBusy
            ? const CircularProgressIndicator()
            : Text(
          'Profili güncelle',
          style: TextStyle(
            fontSize: isTablet ? 18 : 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  void _showImagePickerModal(BuildContext context, ProfileViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(30),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Profil resmini değiştir',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImagePickerOption(
                  icon: Icons.photo_library_rounded,
                  label: 'Galeri',
                  onTap: () {
                    Navigator.pop(context);
                    viewModel.pickImage(ImageSource.gallery, context);
                  },
                ),
                _buildImagePickerOption(
                  icon: Icons.camera_alt_rounded,
                  label: 'Kamera',
                  onTap: () {
                    Navigator.pop(context);
                    viewModel.pickImage(ImageSource.camera, context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePickerOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.blue[600], size: 30),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, ProfileViewModel viewModel) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
        title: const Text('Çıkış yap'),
    content: const Text('Çıkış yapmak istediğinize emin misiniz?'),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('İptal'),
      ),
      TextButton(
        onPressed: () {
          Navigator.pop(context);
          viewModel.logout(context);
        },
        child: const Text('Çıkış Yap', style: TextStyle(color: Colors.red)),
      ),
    ],
        ),
    );
  }
}