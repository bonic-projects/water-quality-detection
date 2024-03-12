import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:wqd_flutter/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:wqd_flutter/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:wqd_flutter/ui/views/home/home_view.dart';
import 'package:wqd_flutter/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import '../services/database_service.dart';
import '../services/firestore_service.dart';
import '../services/user_service.dart';
import '../ui/views/login/login_view.dart';
import '../ui/views/login_register/login_register_view.dart';
import '../ui/views/register/register_view.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    MaterialRoute(page: LoginRegisterView),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: RegisterView),
    // @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DatabaseService),
    LazySingleton(classType: FirebaseAuthenticationService),
    LazySingleton(classType: FirestoreService),
    LazySingleton(classType: UserService),
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
  logger: StackedLogger(),
)
class App {}
