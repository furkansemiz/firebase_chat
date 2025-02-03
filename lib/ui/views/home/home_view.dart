import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat/services/apis_service.dart';
import 'package:firebase_chat/ui/widgets/common/chat_user_card/chat_user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../widgets/common/profile_image/profile_image.dart';
import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> with WidgetsBindingObserver {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    viewModel.setupLifecycleHandler();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (_, __) => viewModel.handleBackPress(context),
        child: Scaffold(
          backgroundColor: const Color(0xFFF5F9FD),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Hero(
                tag: 'profile_image',
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => viewModel.navigateToProfile(context),
                    child: const ProfileImage(
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
            title: viewModel.isSearching
                ? TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Ad veya Email ara...',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
              ),
              autofocus: true,
              style: const TextStyle(
                fontSize: 16,
                letterSpacing: 0.5,
                color: Colors.black87,
              ),
              onChanged: viewModel.handleSearch,
            )
                : const Text(
              'Sohbetler',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            actions: [
              IconButton(
                tooltip: 'Ara',
                onPressed: viewModel.toggleSearch,
                icon: Icon(
                  viewModel.isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : CupertinoIcons.search,
                  color: Colors.black54,
                  size: 24,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.blueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  tooltip: 'Kişi Ekle',
                  onPressed: () => viewModel.showAddUserDialog(context),
                  icon: const Icon(
                    CupertinoIcons.person_add,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
          body: StreamBuilder(
            stream: ApisService.getMyUsersId(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.connectionState == ConnectionState.none) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        strokeWidth: 3,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Sohbetler yükleniyor...',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return StreamBuilder<dynamic>(
                stream: viewModel.getAllUsers(
                  snapshot.data?.docs
                      .map((e) => e.id)
                      .toList()
                      ?.cast<String>() ??
                      [],
                ),
                builder: (context, AsyncSnapshot snapshot) {
                  if (viewModel.handleUsersSnapshot(snapshot)) {
                    return ListView.builder(
                      itemCount: viewModel.isSearching
                          ? viewModel.searchList.length
                          : viewModel.userList.length,
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * .01,
                      ),
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          child: ChatUserCardView(
                            user: viewModel.isSearching
                                ? viewModel.searchList[index]
                                : viewModel.userList[index],
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.person_2,
                            size: 80,
                            color: Colors.blue.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Henüz sohbet yok',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Yeni bir sohbet başlatmak için\nkişi ekleyebilirsiniz',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () => viewModel.showAddUserDialog(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            icon: const Icon(CupertinoIcons.person_add),
                            label: const Text(
                              'Kişi Ekle',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();

  @override
  void onViewModelReady(HomeViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.init();
    WidgetsBinding.instance.addObserver(this);
  }
}