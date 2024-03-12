import 'package:stacked/stacked.dart';

import '../app/app.logger.dart';
import '../models/device.dart';
import 'package:firebase_database/firebase_database.dart';

const dbCode = "lSfWVwRHbXeU3bitqGDy95fGyG12";

class DatabaseService with ListenableServiceMixin {
  final log = getLogger('RealTimeDB_Service');

  final FirebaseDatabase _db = FirebaseDatabase.instance;

  DeviceReading? _node;
  DeviceReading? get node => _node;


  void setupNodeListening() {
    DatabaseReference starCountRef =
        _db.ref('/devices/$dbCode/reading');
    log.i("R ${starCountRef.key}");
    try {
      starCountRef.onValue.listen((DatabaseEvent event) {
        log.i("Reading..");
        if (event.snapshot.exists) {
          _node = DeviceReading.fromMap(event.snapshot.value as Map);
          log.v(_node?.lastSeen); //data['time']
          notifyListeners();
        }
      });
    } catch (e) {
      log.e("Error: $e");
    }
  }

  Future<DeviceData?> getDeviceData() async {
    DatabaseReference dataRef =
        _db.ref('/devices/$dbCode/data');
    final value = await dataRef.once();
    if (value.snapshot.exists) {
      return DeviceData.fromMap(value.snapshot.value as Map);
    }
    return null;
  }

  void setDeviceData(DeviceData data) {
    DatabaseReference dataRef =
        _db.ref('/devices/$dbCode/data');
    dataRef.update(data.toJson());
  }
}
