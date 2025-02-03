import 'package:stacked/stacked.dart';

import '../../../models/chat_user.dart';

class ProfileViewViewModel extends BaseViewModel {
  final ChatUser user;

  ProfileViewViewModel(this.user);

  // Add any additional logic or methods related to the profile view
  // For example, you might want to add methods for:
  // - Updating profile
  // - Performing actions on the profile
  // - Fetching additional user information

  // Example method
  void performSomeAction() {
    // Implement any specific actions
    notifyListeners();
  }
}
