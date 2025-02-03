import 'package:firebase_chat/ui/widgets/common/message_card/message_card.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import '../../../models/chat_user.dart';
import '../../widgets/common/profile_image/profile_image.dart';
import 'chat_viewmodel.dart';

class ChatView extends StackedView<ChatViewModel> {
  final ChatUser user;

  ChatView({super.key, required this.user});

  @override
  Widget builder(BuildContext context, ChatViewModel viewModel, Widget? child) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope(
        canPop: true,
        onPopInvokedWithResult: (_, __) => viewModel.handlePopScope(context),
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            flexibleSpace: _buildAppBar(context, viewModel),
          ),
          backgroundColor: const Color(0xFFF5F9FD),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: viewModel.messagesStream,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.blueAccent,
                              strokeWidth: 2,
                            ),
                          );
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final messages = viewModel.getMessagesFromSnapshot(snapshot);

                          if (messages.isNotEmpty) {
                            return ListView.builder(
                              reverse: true,
                              itemCount: messages.length,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: MediaQuery.of(context).size.height * 0.01,
                              ),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: MessageCardView(message: messages[index]),
                                );
                              },
                            );
                          } else {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.chat_bubble_outline,
                                    size: 80,
                                    color: Colors.blue.withOpacity(0.3),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Selam ver! 👋',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                      }
                    },
                  ),
                ),
                if (viewModel.isUploading)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                      ),
                    ),
                  ),
                _buildChatInput(context, viewModel),
                if (viewModel.showEmoji)
                  Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: EmojiPicker(
                      textEditingController: viewModel.textController,
                      config: const Config(),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, ChatViewModel viewModel) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: InkWell(
          onTap: () => viewModel.navigateToProfile(context),
          child: StreamBuilder(
            stream: viewModel.userInfoStream,
            builder: (context, snapshot) {
              final userData = viewModel.getUserFromSnapshot(snapshot);
              return Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.black54,
                      size: 22,
                    ),
                  ),
                  Hero(
                    tag: 'profile_${userData?.image ?? user.image}',
                    child: ProfileImage(
                      size: MediaQuery.of(context).size.height * 0.05,
                      url: userData?.image ?? user.image,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userData?.name ?? user.name,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          viewModel.getLastActiveText(userData, context),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildChatInput(BuildContext context, ChatViewModel viewModel) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.025,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => viewModel.toggleEmoji(context),
                    icon: const Icon(
                      Icons.emoji_emotions_rounded,
                      color: Colors.blueAccent,
                      size: 24,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: viewModel.textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onTap: () => viewModel.onTextFieldTap(),
                      style: const TextStyle(fontSize: 15),
                      decoration: const InputDecoration(
                        hintText: 'Bir mesaj yazın...',
                        hintStyle: TextStyle(color: Colors.blueAccent),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => viewModel.pickMultipleImages(),
                    icon: const Icon(
                      Icons.image_rounded,
                      color: Colors.blueAccent,
                      size: 24,
                    ),
                  ),
                  IconButton(
                    onPressed: () => viewModel.pickImageFromCamera(),
                    icon: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.blueAccent,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.blueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: MaterialButton(
              onPressed: () => viewModel.sendMessage(),
              minWidth: 0,
              padding: const EdgeInsets.all(12),
              shape: const CircleBorder(),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  ChatViewModel viewModelBuilder(BuildContext context) => ChatViewModel(user: user);
}