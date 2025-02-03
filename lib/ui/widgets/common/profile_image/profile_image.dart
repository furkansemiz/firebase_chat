import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_chat/services/apis_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'profile_image_model.dart';

class ProfileImage extends StackedView<ProfileImageModel> {
  final double size;
  final String? url;

  const ProfileImage({super.key, required this.size, this.url});

  @override
  Widget builder(
    BuildContext context,
    ProfileImageModel viewModel,
    Widget? child,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(size)),
      child: CachedNetworkImage(
        width: size,
        height: size,
        fit: BoxFit.cover,
        imageUrl: url ?? ApisService.user.photoURL.toString(),
        errorWidget: (context, url, error) =>
        const CircleAvatar(child: Icon(CupertinoIcons.person)),
      ),
    );
  }

  @override
  ProfileImageModel viewModelBuilder(
    BuildContext context,
  ) =>
      ProfileImageModel();
}
