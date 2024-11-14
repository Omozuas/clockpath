import 'package:clockpath/apis/respones/general_respons.dart';
import 'package:clockpath/apis/services/setupprofile_api/setupprofile_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SetupProfileProvider
    extends AutoDisposeNotifier<SetupProfileProviderStates> {
  @override
  SetupProfileProviderStates build() {
    return const SetupProfileProviderStates(
      setUpProfile: AsyncData(null),
      setupWorkDays: AsyncData(null),
      clockIn: AsyncData(null),
      clockOut: AsyncData(null),
      // updateProfile: AsyncData(null),
      // resetPassword: AsyncData(null)
    );
  }

  Future<void> setupProfilee(
      {required List<MapEntry<String, dynamic>> data,
      List<Map<String, dynamic>>? images}) async {
    final auth = ref.read(setupProfileApi);
    try {
      state = state.copyWith(setUpProfile: const AsyncLoading());
      final response = await auth.setupProfile(data: data, images: images);
      state = state.copyWith(setUpProfile: AsyncData(response));
    } catch (e) {
      state = state.copyWith(
          setUpProfile: AsyncError(e.toString(), StackTrace.current));
    }
  }

  Future<void> setupPWordDays(
      {required List<Map<String, dynamic>> work}) async {
    final auth = ref.read(setupProfileApi);
    try {
      state = state.copyWith(setupWorkDays: const AsyncLoading());
      final response = await auth.setupPWordDays(work: work);
      state = state.copyWith(setupWorkDays: AsyncData(response));
    } catch (e) {
      state = state.copyWith(
          setupWorkDays: AsyncError(e.toString(), StackTrace.current));
    }
  }

//clockIn and Out
  Future<void> clockIn(
      {required double longitude, required double latitude}) async {
    final auth = ref.read(setupProfileApi);
    try {
      state = state.copyWith(clockIn: const AsyncLoading());
      final response =
          await auth.clockIn(longitude: longitude, latitude: latitude);
      state = state.copyWith(clockIn: AsyncData(response));
    } catch (e) {
      state =
          state.copyWith(clockIn: AsyncError(e.toString(), StackTrace.current));
    }
  }

  Future<void> clockOut(
      {required double longitude, required double latitude}) async {
    final auth = ref.read(setupProfileApi);
    try {
      state = state.copyWith(clockOut: const AsyncLoading());
      final response =
          await auth.clockOut(longitude: longitude, latitude: latitude);
      state = state.copyWith(clockOut: AsyncData(response));
    } catch (e) {
      state = state.copyWith(
          clockOut: AsyncError(e.toString(), StackTrace.current));
    }
  }

  // Future<void> oneTimePin({required String otp}) async {
  //   final auth = ref.read(authServicesProvider);
  //   try {
  //     state = state.copyWith(oneTimePin: const AsyncLoading());
  //     final response = await auth.oneTimePin(otp: otp);
  //     state = state.copyWith(oneTimePin: AsyncData(response));
  //   } catch (e) {
  //     state = state.copyWith(
  //         oneTimePin: AsyncError(e.toString(), StackTrace.current));
  //   }
  // }

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

final setupProfileProvider = AutoDisposeNotifierProvider<SetupProfileProvider,
    SetupProfileProviderStates>(SetupProfileProvider.new);

class SetupProfileProviderStates {
  final AsyncValue<GeneralRespons?> setUpProfile;
  final AsyncValue<GeneralRespons?> setupWorkDays;
  final AsyncValue<GeneralRespons?> clockIn;
  final AsyncValue<GeneralRespons?> clockOut;
  // final AsyncValue<GeneralRespons?> updateProfile;
  // final AsyncValue<GeneralRespons?> resetPassword;
  const SetupProfileProviderStates({
    required this.setUpProfile,
    required this.setupWorkDays,
    required this.clockIn,
    required this.clockOut,
    // required this.updateProfile,
    // required this.resetPassword
  });
  SetupProfileProviderStates copyWith({
    AsyncValue<GeneralRespons?>? setUpProfile,
    AsyncValue<GeneralRespons?>? setupWorkDays,
    AsyncValue<GeneralRespons?>? clockIn,
    AsyncValue<GeneralRespons?>? clockOut,
    AsyncValue<GeneralRespons?>? updateProfile,
    // AsyncValue<GeneralRespons?>? resetPassword,
  }) {
    return SetupProfileProviderStates(
      setUpProfile: setUpProfile ?? this.setUpProfile,
      setupWorkDays: setupWorkDays ?? this.setupWorkDays,
      clockIn: clockIn ?? this.clockIn,
      clockOut: clockOut ?? this.clockOut,
      // updateProfile: updateProfile ?? this.updateProfile,
      // resetPassword: resetPassword ?? this.resetPassword
    );
  }
}
