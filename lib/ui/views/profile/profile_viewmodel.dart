import 'dart:io';
import 'package:firebase_chat/app/app.locator.dart';
import 'package:firebase_chat/app/app.router.dart';
import 'package:firebase_chat/services/apis_service.dart';
import 'package:firebase_chat/services/dialog_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../models/chat_user.dart';

class ProfileViewModel extends BaseViewModel {
  final ChatUser user;
  String? _image;
  final ImagePicker _picker = ImagePicker();

  ProfileViewModel({required this.user});

  String? get profileImage => _image;

  Future<void> pickImage(ImageSource source, BuildContext cont) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (image != null) {
        _image = image.path;
        await ApisService.updateProfilePicture(File(_image!));
        notifyListeners();
      }
    } catch (e) {
      DialogsService.showErrorSnackBar(
        cont,
          'Profil resmi yüklenirken bir hata oluştu!');
    }
  }

  Future<void> updateProfileInfo(String name, String about, BuildContext cont) async {
    setBusy(true);
    try {
      ApisService.me.name = name;
      ApisService.me.about = about;
      await ApisService.updateUserInfo();
      DialogsService.showSuccessSnackBar(cont, 'Profil başarıyla güncellendi!');
    } catch (e) {
      DialogsService.showErrorSnackBar(cont, 'Profil güncellenirken bir hata oluştu!');
    } finally {
      setBusy(false);
    }
  }

  Future<void> logout(BuildContext cont) async {
    setBusy(true);
    try {
      await ApisService.updateActiveStatus(false);

      await ApisService.auth.signOut();
      await GoogleSignIn().signOut();

      NavigationService().replaceWithAuthenticationView();
    } catch (e) {
      DialogsService.showErrorSnackBar(
          cont,
          'Çıkış yapılamadı. Lütfen tekrar deneyin.'
      );
    } finally {
      setBusy(false);
    }
  }
}
