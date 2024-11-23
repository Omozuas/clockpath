import 'dart:async';

import 'package:clockpath/apis/models/get_notification.dart';
import 'package:clockpath/apis/services/home_api/home_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetNotificationProvider
    extends AutoDisposeAsyncNotifier<NotificationModel?> {
  @override
  Future<NotificationModel?> build() async {
    getNotification(limit: 30);
    return null;
  }

  Future<void> getNotification({required double limit}) async {
    final auth = ref.read(homeApi);

    try {
      state = const AsyncLoading();
      final response = await auth.getNotification(limit: limit);
      state = AsyncData(response);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

final getNotificationProvider = AutoDisposeAsyncNotifierProvider<
    GetNotificationProvider, NotificationModel?>(GetNotificationProvider.new);
