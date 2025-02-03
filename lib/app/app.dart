import 'package:firebase_chat/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:firebase_chat/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:firebase_chat/ui/views/home/home_view.dart';
import 'package:firebase_chat/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:firebase_chat/ui/views/authentication/authentication_view.dart';
import 'package:firebase_chat/services/apis_service.dart';
import 'package:firebase_chat/ui/views/login/login_view.dart';
import 'package:firebase_chat/services/navigator_service.dart';
import 'package:firebase_chat/ui/views/register/register_view.dart';
import 'package:firebase_chat/ui/views/chat/chat_view.dart';
import 'package:firebase_chat/ui/views/profile/profile_view.dart';
import 'package:firebase_chat/ui/views/profile_view/profile_view_view.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView, initial: true),
    MaterialRoute(page: AuthenticationView),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: RegisterView),
    MaterialRoute(page: ChatView),
    MaterialRoute(page: ProfileScreen),
    MaterialRoute(page: ViewProfileScreen),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: ApisService),
    LazySingleton(classType: NavigatorService),
// @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}
