import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:wqd_flutter/models/device.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../app/app.router.dart';
import '../../../services/database_service.dart';
import '../../../services/user_service.dart';

class HomeViewModel extends  ReactiveViewModel {
  final log = getLogger('HomeViewModel');

  // final _snackBarService = locator<SnackbarService>();
  final _navigationService = locator<NavigationService>();
  final _userService = locator<UserService>();
  final _databaseService = locator<DatabaseService>();

  DeviceReading? get node => _databaseService.node;
  @override
  List<ListenableServiceMixin> get listenableServices => [_databaseService];

  void logout() {
    _userService.logout();
    _navigationService.replaceWithLoginRegisterView();
  }

}
