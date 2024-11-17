import 'dart:async';

import 'package:clockpath/apis/models/get_workdays_model.dart';

import 'package:clockpath/apis/services/home_api/home_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetWorkDaysProvider extends AutoDisposeAsyncNotifier<GetWorkModel?> {
  @override
  Future<GetWorkModel?> build() async {
    getWorkDays();
    return null;
  }

  Future<void> getWorkDays() async {
    final auth = ref.read(homeApi);

    try {
      state = const AsyncLoading();
      final response = await auth.getWorkDays();
      state = AsyncData(response);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

final getWorkDaysProvider =
    AutoDisposeAsyncNotifierProvider<GetWorkDaysProvider, GetWorkModel?>(
        GetWorkDaysProvider.new);
