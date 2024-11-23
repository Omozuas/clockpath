import 'package:clockpath/apis/respones/general_respons.dart';
import 'package:clockpath/apis/services/settings_api/settings_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsProvider extends AutoDisposeNotifier<SettingsProviderStates> {
  @override
  SettingsProviderStates build() {
    return const SettingsProviderStates(
      requestUser: AsyncData(null),
      managePassword: AsyncData(null),
      logOut: AsyncData(null),
      registerDevice: AsyncData(null),
      reminder: AsyncData(null),
      // resetPassword: AsyncData(null)
    );
  }

  Future<void> requestUser(
      {required String requestType,
      required String reason,
      required String note,
      required String startDate,
      required String endDate}) async {
    final auth = ref.read(settingsApi);
    try {
      state = state.copyWith(requestUser: const AsyncLoading());
      final response = await auth.requestUser(
          requestType: requestType,
          reason: reason,
          note: note,
          startDate: startDate,
          endDate: endDate);
      state = state.copyWith(requestUser: AsyncData(response));
    } catch (e) {
      state = state.copyWith(
          requestUser: AsyncError(e.toString(), StackTrace.current));
    }
  }

  Future<void> managePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final auth = ref.read(settingsApi);
    try {
      state = state.copyWith(managePassword: const AsyncLoading());
      final response = await auth.managePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
          confirmPassword: confirmPassword);
      state = state.copyWith(managePassword: AsyncData(response));
    } catch (e) {
      state = state.copyWith(
          managePassword: AsyncError(e.toString(), StackTrace.current));
    }
  }

//logOut and Out
  Future<void> logOut() async {
    final auth = ref.read(settingsApi);
    try {
      state = state.copyWith(logOut: const AsyncLoading());
      final response = await auth.logOut();
      state = state.copyWith(logOut: AsyncData(response));
    } catch (e) {
      state =
          state.copyWith(logOut: AsyncError(e.toString(), StackTrace.current));
    }
  }

  Future<void> registerDevice(
      {required String deviceToken, required String platform}) async {
    final auth = ref.read(settingsApi);
    try {
      state = state.copyWith(registerDevice: const AsyncLoading());
      final response = await auth.registerDevice(
          deviceToken: deviceToken, platform: platform);
      state = state.copyWith(registerDevice: AsyncData(response));
    } catch (e) {
      state = state.copyWith(
          registerDevice: AsyncError(e.toString(), StackTrace.current));
    }
  }

  Future<void> reminder(
      {required String clockInReminder,
      required String clockOutReminder}) async {
    final auth = ref.read(settingsApi);
    try {
      state = state.copyWith(reminder: const AsyncLoading());
      final response = await auth.reminder(
          clockInReminder: clockInReminder, clockOutReminder: clockOutReminder);
      state = state.copyWith(reminder: AsyncData(response));
    } catch (e) {
      state = state.copyWith(
          reminder: AsyncError(e.toString(), StackTrace.current));
    }
  }

  // Future<void> resetPassword(
  //     {required String newPassword, required String confirmPassword}) async {
  //   final auth = ref.read(authServicesProvider);
  //   try {
  //     state = state.copyWith(resetPassword: const AsyncLoading());
  //     final response = await auth.restPassword(
  //         newPassword: newPassword, confirmPassword: confirmPassword);
  //     state = state.copyWith(resetPassword: AsyncData(response));
  //   } catch (e) {
  //     state = state.copyWith(
  //         resetPassword: AsyncError(e.toString(), StackTrace.current));
  //   }
  // }
}

final settingsProvider =
    AutoDisposeNotifierProvider<SettingsProvider, SettingsProviderStates>(
        SettingsProvider.new);

class SettingsProviderStates {
  final AsyncValue<GeneralRespons?> requestUser;
  final AsyncValue<GeneralRespons?> managePassword;
  final AsyncValue<GeneralRespons?> logOut;
  final AsyncValue<GeneralRespons?> registerDevice;
  final AsyncValue<GeneralRespons?> reminder;
  // final AsyncValue<GeneralRespons?> resetPassword;
  const SettingsProviderStates({
    required this.requestUser,
    required this.managePassword,
    required this.logOut,
    required this.registerDevice,
    required this.reminder,
    // required this.resetPassword
  });
  SettingsProviderStates copyWith({
    AsyncValue<GeneralRespons?>? requestUser,
    AsyncValue<GeneralRespons?>? managePassword,
    AsyncValue<GeneralRespons?>? logOut,
    AsyncValue<GeneralRespons?>? registerDevice,
    AsyncValue<GeneralRespons?>? reminder,
    // AsyncValue<GeneralRespons?>? resetPassword,
  }) {
    return SettingsProviderStates(
      requestUser: requestUser ?? this.requestUser,
      managePassword: managePassword ?? this.managePassword,
      logOut: logOut ?? this.logOut,
      registerDevice: registerDevice ?? this.registerDevice,
      reminder: reminder ?? this.reminder,
      // resetPassword: resetPassword ?? this.resetPassword
    );
  }
}
