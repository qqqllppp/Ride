import 'package:firebase_database/firebase_database.dart';
import 'package:ride/models/driver_application.dart';
import 'package:ride/models/nearby_driver.dart';
import 'package:ride/models/ride_request.dart';

class FireHelper {
  static final List<NearbyDriver> _nearbyDriverList = [];

  static List<NearbyDriver> get nearbyDriverList => _nearbyDriverList;

  static final _rideRequestsRef =
      FirebaseDatabase.instance.ref('ride_requests');

  static final _driverApplicantsRef =
      FirebaseDatabase.instance.ref('driver_applications');

  static void addNearbyDriver(NearbyDriver driver) {
    _nearbyDriverList.add(driver);
  }

  static void removeNearbyDriver(String key) {
    int index = _nearbyDriverList
        .indexWhere((existingDriver) => existingDriver.key == key);
    _nearbyDriverList.removeAt(index);
  }

  static void updateNearbyLocation(NearbyDriver driver) {
    int index = _nearbyDriverList
        .indexWhere((existingDriver) => existingDriver.key == driver.key);
    _nearbyDriverList[index].latitude = driver.latitude;
    _nearbyDriverList[index].longitude = driver.longitude;
  }

  static Future<void> addDriverApplication(
      String driverId, Map<String, Object> applicantMap) async {
    await _driverApplicantsRef.child(driverId).set(applicantMap);
  }

  static Stream<DatabaseEvent> getDriverApplicationsStream(String status) {
    return _driverApplicantsRef.orderByChild('status').equalTo(status).onValue;
  }

  static Future<DriverApplication?> getDriverApplication(
      String driverId) async {
    return await _driverApplicantsRef.child(driverId).once().then((result) {
      final Object? value = result.snapshot.value;
      return value != null ? DriverApplication.parseRaw(value) : null;
    });
  }

  static Future<void> updateDriverApplication(
      String driverId, Map<String, Object?> value) async {
    await _driverApplicantsRef.child(driverId).update(value);
  }

  static Future<void> addRideRequest(
      String tixId, Map<String, Object> rideMap) async {
    await _rideRequestsRef.child(tixId).set(rideMap);
  }

  static Future<RideRequest> getRideRequest(String tixId) async {
    return await _rideRequestsRef.child(tixId).once().then((result) {
      final Object? value = result.snapshot.value;
      return RideRequest.parseRaw(value!);
    });
  }

  static Future<void> updateRideRequest(
      String tixId, Map<String, Object?> value) async {
    await _rideRequestsRef.child(tixId).update(value);
  }

  static Future<void> removeRideRequest(String tixId) async {
    await _rideRequestsRef.child(tixId).remove();
  }

  static Stream<DatabaseEvent> getWaitingRideRequestStream() {
    return _rideRequestsRef.orderByChild('status').equalTo('waiting').onValue;
  }

  static Stream<DatabaseEvent> getRideRequestStreamByTixId(String tixId) {
    return _rideRequestsRef.child(tixId).onValue;
  }
}
