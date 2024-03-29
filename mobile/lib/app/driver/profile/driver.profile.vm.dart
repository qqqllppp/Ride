import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/auth/auth.vm.dart';
import 'package:ride/models/driver_application.dart';
import 'package:ride/models/driver_reputation.dart';
import 'package:ride/services/crypto.dart';
import 'package:ride/services/repository.dart';
import 'package:ride/services/ride/ride_badge.dart';
import 'package:ride/utils/fire_helper.dart';

part 'driver.profile.vm.freezed.dart';

@freezed
class DriverProfileState with _$DriverProfileState {
  const factory DriverProfileState.loading() = _DriverProfileLoading;
  const factory DriverProfileState.error(String? message) = _DriverProfileError;
  const factory DriverProfileState.data(DriverReputation driverReputation,
      DriverApplication driverApplication) = _DriverProfileData;
}

class DriverProfileVM extends StateNotifier<DriverProfileState> {
  DriverProfileVM(Reader read)
      : _crypto = read(cryptoProvider),
        _repository = read(repositoryProvider),
        _rideBadgeService = read(rideBadgeProvider),
        super(const DriverProfileState.loading()) {
    getDriverReputation();
  }

  final Crypto _crypto;
  final Repository _repository;
  final RideBadgeService _rideBadgeService;

  Future<void> getDriverReputation() async {
    try {
      state = const DriverProfileState.loading();
      final credentials = _repository.getPrivateKey();
      final driverAddress = await _crypto.getPublicAddress(credentials!);
      final driverReputation =
          await _rideBadgeService.getDriverReputation(driverAddress);
      final driverApplication =
          await FireHelper.getDriverApplication(driverAddress.hexEip55);
      state = DriverProfileState.data(driverReputation, driverApplication!);
    } catch (ex) {
      state = DriverProfileState.error(ex.toString());
    }
  }
}

final driverProfileProvider =
    StateNotifierProvider<DriverProfileVM, DriverProfileState>((ref) {
  ref.watch(authProvider);

  return DriverProfileVM(ref.read);
});
