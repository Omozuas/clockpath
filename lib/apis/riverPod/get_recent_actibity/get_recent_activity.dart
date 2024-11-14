import 'dart:async';

import 'package:clockpath/apis/models/recent_activity_model.dart';
import 'package:clockpath/apis/services/home_api/home_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetRecentActivityProvider
    extends AutoDisposeAsyncNotifier<RecentActivityModel?> {
  @override
  Future<RecentActivityModel?> build() async {
    getRecentResults();
    return null;
  }

  Future<void> getRecentResults() async {
    final auth = ref.read(homeApi);

    try {
      state = const AsyncLoading();
      final response = await auth.getRecentResults();
      state = AsyncData(response);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

final getRecentActivityProvider = AutoDisposeAsyncNotifierProvider<
    GetRecentActivityProvider,
    RecentActivityModel?>(GetRecentActivityProvider.new);
