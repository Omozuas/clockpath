import 'dart:async';

import 'package:clockpath/apis/models/get_reminder.dart';
import 'package:clockpath/apis/services/settings_api/settings_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetReminderProvider extends AutoDisposeAsyncNotifier<ReminderModel?> {
  @override
  Future<ReminderModel?> build() async {
    getReminder();
    return null;
  }

  Future<void> getReminder() async {
    final auth = ref.read(settingsApi);

    try {
      state = const AsyncLoading();
      final response = await auth.getReminder();
      state = AsyncData(response);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

final getReminderProvider =
    AutoDisposeAsyncNotifierProvider<GetReminderProvider, ReminderModel?>(
        GetReminderProvider.new);
