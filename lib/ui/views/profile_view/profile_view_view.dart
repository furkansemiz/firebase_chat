import 'package:firebase_chat/ui/views/profile_view/profile_view_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../helper/my_date_util.dart';
import '../../../models/chat_user.dart';
import '../../widgets/common/profile_image/profile_image.dart';

class ViewProfileScreen extends StackedView<ProfileViewViewModel> {
  final ChatUser user;

  const ViewProfileScreen({super.key, required this.user});

  @override
  Widget builder(
    BuildContext context,
    ProfileViewViewModel viewModel,
    Widget? child,
  ) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(title: Text(user.name)),
        floatingActionButton: _buildJoinedDateWidget(context),
        body: _buildProfileBody(context),
      ),
    );
  }

  Widget _buildJoinedDateWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Şu tarihte katıldı: ',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
        Text(
          MyDateUtil.getLastMessageTime(
            context: context,
            time: user.createdAt,
            showYear: true,
          ),
          style: const TextStyle(color: Colors.black54, fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildProfileBody(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(width: mq.width, height: mq.height * .03),
            ProfileImage(
              size: mq.height * .2,
              url: user.image,
            ),
            SizedBox(height: mq.height * .03),
            Text(
              user.email,
              style: const TextStyle(color: Colors.black87, fontSize: 16),
            ),
            SizedBox(height: mq.height * .02),
            _buildAboutSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Hakkında: ',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
        Text(
          user.about,
          style: const TextStyle(color: Colors.black54, fontSize: 15),
        ),
      ],
    );
  }

  @override
  ProfileViewViewModel viewModelBuilder(BuildContext context) {
    return ProfileViewViewModel(user);
  }
}
