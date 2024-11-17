import 'dart:async';

import 'package:clockpath/apis/models/get_request_model.dart';

import 'package:clockpath/apis/services/home_api/home_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetRequestProvider extends AutoDisposeAsyncNotifier<GetRequestModel?> {
  @override
  Future<GetRequestModel?> build() async {
    getRequest(limit: 30);
    return null;
  }

  Future<void> getRequest({required double limit}) async {
    final auth = ref.read(homeApi);

    try {
      state = const AsyncLoading();
      final response = await auth.getRequest(limit: limit);
      state = AsyncData(response);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

final getRequestProvider =
    AutoDisposeAsyncNotifierProvider<GetRequestProvider, GetRequestModel?>(
        GetRequestProvider.new);
