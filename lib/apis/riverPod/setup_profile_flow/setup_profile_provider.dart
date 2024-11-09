import 'package:clockpath/apis/respones/general_respons.dart';
import 'package:clockpath/apis/services/setupprofile_api/setupprofile_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SetupProfileProvider
    extends AutoDisposeNotifier<SetupProfileProviderStates> {
  @override
  SetupProfileProviderStates build() {
    return const SetupProfileProviderStates(
      setUpProfile: AsyncData(null),
      // createPassword: AsyncData(null),
      // loginRespons: AsyncData(null),
      // forgotPassword: AsyncData(null),
      // oneTimePin: AsyncData(null),
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

  // Future<void> setNewPassword(
  //     {required String newPassword, required String confirmPassword}) async {
  //   final auth = ref.read(authServicesProvider);
  //   try {
  //     state = state.copyWith(createPassword: const AsyncLoading());
  //     final response = await auth.createPassword(
  //         newPassword: newPassword, confirmPassword: confirmPassword);
  //     state = state.copyWith(createPassword: AsyncData(response));
  //   } catch (e) {
  //     state = state.copyWith(
  //         createPassword: AsyncError(e.toString(), StackTrace.current));
  //   }
  // }

  // Future<void> login({required String email, required String password}) async {
  //   final auth = ref.read(authServicesProvider);
  //   try {
  //     state = state.copyWith(loginRespons: const AsyncLoading());
  //     final response =
  //         await auth.loginRespons(email: email, password: password);
  //     state = state.copyWith(loginRespons: AsyncData(response));
  //   } catch (e) {
  //     state = state.copyWith(
  //         loginRespons: AsyncError(e.toString(), StackTrace.current));
  //   }
  // }

  // Future<void> forgotPassword({required String email}) async {
  //   final auth = ref.read(authServicesProvider);
  //   try {
  //     state = state.copyWith(forgotPassword: const AsyncLoading());
  //     final response = await auth.forgotPassword(email: email);
  //     state = state.copyWith(forgotPassword: AsyncData(response));
  //   } catch (e) {
  //     state = state.copyWith(
  //         forgotPassword: AsyncError(e.toString(), StackTrace.current));
  //   }
  // }

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
  // final AsyncValue<GeneralRespons?> createPassword;
  // final AsyncValue<GeneralRespons?> loginRespons;
  // final AsyncValue<GeneralRespons?> forgotPassword;
  // final AsyncValue<GeneralRespons?> oneTimePin;
  // final AsyncValue<GeneralRespons?> resetPassword;
  const SetupProfileProviderStates({
    required this.setUpProfile,
    // required this.createPassword,
    // required this.loginRespons,
    // required this.forgotPassword,
    // required this.oneTimePin,
    // required this.resetPassword
  });
  SetupProfileProviderStates copyWith({
    AsyncValue<GeneralRespons?>? setUpProfile,
    // AsyncValue<GeneralRespons?>? createPassword,
    // AsyncValue<GeneralRespons?>? loginRespons,
    // AsyncValue<GeneralRespons?>? forgotPassword,
    // AsyncValue<GeneralRespons?>? oneTimePin,
    // AsyncValue<GeneralRespons?>? resetPassword,
  }) {
    return SetupProfileProviderStates(
      setUpProfile: setUpProfile ?? this.setUpProfile,
      // createPassword: createPassword ?? this.createPassword,
      // loginRespons: loginRespons ?? this.loginRespons,
      // forgotPassword: forgotPassword ?? this.forgotPassword,
      // oneTimePin: oneTimePin ?? this.oneTimePin,
      // resetPassword: resetPassword ?? this.resetPassword
    );
  }
}
