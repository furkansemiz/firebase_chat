import 'package:firebase_chat/ui/widgets/common/profile_dialog/profile_dialog_model.dart';
import 'package:flutter/material.dart';

import '../../../../models/chat_user.dart';
import '../profile_image/profile_image.dart';

class ProfileDialog extends StatelessWidget {
  final ProfileDialogModel viewModel;

  const ProfileDialog({super.key, required ProfileDialogModel viewModel})
      : viewModel = viewModel;

  factory ProfileDialog.create({required ChatUser user}) {
    return ProfileDialog(viewModel: ProfileDialogModel(user: user));
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white.withOpacity(.9),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      content: SizedBox(
          width: mq.width * .6,
          height: mq.height * .35,
          child: Stack(
            children: [
              // User profile picture
              Positioned(
                top: mq.height * .075,
                left: mq.width * .1,
                child: ProfileImage(
                    size: mq.width * .5, url: viewModel.user.image),
              ),

              // User name
              Positioned(
                left: mq.width * .04,
                top: mq.height * .02,
                width: mq.width * .55,
                child: Text(viewModel.user.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500)),
              ),

              // Info button
              Positioned(
                  right: 8,
                  top: 6,
                  child: MaterialButton(
                    onPressed: () =>
                        viewModel.navigateToProfileDetails(context),
                    minWidth: 0,
                    padding: const EdgeInsets.all(0),
                    shape: const CircleBorder(),
                    child: const Icon(Icons.info_outline,
                        color: Colors.blue, size: 30),
                  ))
            ],
          )),
    );
  }
}
