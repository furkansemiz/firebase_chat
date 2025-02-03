import 'package:firebase_chat/app/app.locator.dart';
import 'package:firebase_chat/app/app.router.dart';
import 'package:firebase_chat/services/apis_service.dart';
import 'package:firebase_chat/ui/views/chat/chat_view.dart';
import 'package:firebase_chat/ui/widgets/common/profile_dialog/profile_dialog_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../../models/chat_user.dart';
import '../profile_dialog/profile_dialog.dart';
import '../profile_image/profile_image.dart';
import 'chat_user_card_model.dart';

class ChatUserCardView extends StatelessWidget {
  final ChatUser user;

  const ChatUserCardView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return ViewModelBuilder<ChatUserCardModel>.reactive(
      viewModelBuilder: () => ChatUserCardModel(user: user),
      builder: (context, viewModel, child) {
        return StreamBuilder(
          stream: viewModel.getLastMessageStream(),
          builder: (context, snapshot) {
            return Card(
              margin:
                  EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: 4),
              elevation: 0.5,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                onTap: () async{
                  await ApisService.getSelfInfo();
                  locator<NavigationService>().navigateToChatView(user: user);
                },
                child: ListTile(
                  leading: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) => ProfileDialog(viewModel: ProfileDialogModel(user: user),));
                    },
                    child:
                        ProfileImage(size: mq.height * .055, url: user.image),
                  ),
                  title: Text(user.name),
                  subtitle: Text(viewModel.getSubtitleText(), maxLines: 1),
                  trailing: viewModel.lastMessage == null
                      ? null
                      : viewModel.hasUnreadMessage()
                          ? const SizedBox(
                              width: 15,
                              height: 15,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 0, 230, 119),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              ),
                            )
                          : Text(
                              viewModel.getLastMessageTime(context),
                              style: const TextStyle(color: Colors.black54),
                            ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
