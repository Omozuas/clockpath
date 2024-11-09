import 'package:clockpath/apis/respones/general_respons.dart';
import 'package:clockpath/apis/services/auth_api/auth_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthProvider extends AutoDisposeNotifier<AuthProviderStates> {
  @override
  AuthProviderStates build() {
    return const AuthProviderStates(
        acceptRespons: AsyncData(null),
        createPassword: AsyncData(null),
        loginRespons: AsyncData(null),
        forgotPassword: AsyncData(null),
        oneTimePin: AsyncData(null),
        resetPassword: AsyncData(null));
  }

  Future<void> acceptInvite(
      {required String email, required String code}) async {
    final auth = ref.read(authServicesProvider);
    try {
      state = state.copyWith(acceptRespons: const AsyncLoading());
      final response = await auth.acceptInvite(email: email, code: code);
      state = state.copyWith(acceptRespons: AsyncData(response));
    } catch (e) {
      state = state.copyWith(
          acceptRespons: AsyncError(e.toString(), StackTrace.current));
    }
  }

  Future<void> setNewPassword(
      {required String newPassword, required String confirmPassword}) async {
    final auth = ref.read(authServicesProvider);
    try {
      state = state.copyWith(createPassword: const AsyncLoading());
      final response = await auth.createPassword(
          newPassword: newPassword, confirmPassword: confirmPassword);
      state = state.copyWith(createPassword: AsyncData(response));
    } catch (e) {
      state = state.copyWith(
          createPassword: AsyncError(e.toString(), StackTrace.current));
    }
  }

  Future<void> login({required String email, required String password}) async {
    final auth = ref.read(authServicesProvider);
    try {
      state = state.copyWith(loginRespons: const AsyncLoading());
      final response =
          await auth.loginRespons(email: email, password: password);
      state = state.copyWith(loginRespons: AsyncData(response));
    } catch (e) {
      state = state.copyWith(
          loginRespons: AsyncError(e.toString(), StackTrace.current));
    }
  }

  Future<void> forgotPassword({required String email}) async {
    final auth = ref.read(authServicesProvider);
    try {
      state = state.copyWith(forgotPassword: const AsyncLoading());
      final response = await auth.forgotPassword(email: email);
      state = state.copyWith(forgotPassword: AsyncData(response));
    } catch (e) {
      state = state.copyWith(
          forgotPassword: AsyncError(e.toString(), StackTrace.current));
    }
  }

  Future<void> oneTimePin({required String otp}) async {
    final auth = ref.read(authServicesProvider);
    try {
      state = state.copyWith(oneTimePin: const AsyncLoading());
      final response = await auth.oneTimePin(otp: otp);
      state = state.copyWith(oneTimePin: AsyncData(response));
    } catch (e) {
      state = state.copyWith(
          oneTimePin: AsyncError(e.toString(), StackTrace.current));
    }
  }

  Future<void> resetPassword(
      {required String newPassword, required String confirmPassword}) async {
    final auth = ref.read(authServicesProvider);
    try {
      state = state.copyWith(resetPassword: const AsyncLoading());
      final response = await auth.restPassword(
          newPassword: newPassword, confirmPassword: confirmPassword);
      state = state.copyWith(resetPassword: AsyncData(response));
    } catch (e) {
      state = state.copyWith(
          resetPassword: AsyncError(e.toString(), StackTrace.current));
    }
  }
}

final authProvider =
    AutoDisposeNotifierProvider<AuthProvider, AuthProviderStates>(
        AuthProvider.new);

class AuthProviderStates {
  final AsyncValue<GeneralRespons?> acceptRespons;
  final AsyncValue<GeneralRespons?> createPassword;
  final AsyncValue<GeneralRespons?> loginRespons;
  final AsyncValue<GeneralRespons?> forgotPassword;
  final AsyncValue<GeneralRespons?> oneTimePin;
  final AsyncValue<GeneralRespons?> resetPassword;
  const AuthProviderStates(
      {required this.acceptRespons,
      required this.createPassword,
      required this.loginRespons,
      required this.forgotPassword,
      required this.oneTimePin,
      required this.resetPassword});
  AuthProviderStates copyWith({
    AsyncValue<GeneralRespons?>? acceptRespons,
    AsyncValue<GeneralRespons?>? createPassword,
    AsyncValue<GeneralRespons?>? loginRespons,
    AsyncValue<GeneralRespons?>? forgotPassword,
    AsyncValue<GeneralRespons?>? oneTimePin,
    AsyncValue<GeneralRespons?>? resetPassword,
  }) {
    return AuthProviderStates(
        acceptRespons: acceptRespons ?? this.acceptRespons,
        createPassword: createPassword ?? this.createPassword,
        loginRespons: loginRespons ?? this.loginRespons,
        forgotPassword: forgotPassword ?? this.forgotPassword,
        oneTimePin: oneTimePin ?? this.oneTimePin,
        resetPassword: resetPassword ?? this.resetPassword);
  }
}
