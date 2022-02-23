import 'dart:developer';

import 'package:get/get.dart';

import 'package:weather_map/service/api_client.dart';

import '../models/one_call_history_model.dart';

class OneCallHistoryController extends GetxController {
  var isLoading = true.obs;
  var oneCallHistoryData = OneCallHistoryModel().obs;

  // @override
  // void onInit() {
  //   getOneCallDailyApi(lat: 12.9716, lon: 77.5946);
  //   super.onInit();
  // }

  Future<void> getOneCallHistoryApi(
      {required lat, required lon, required time}) async {
    try {
      isLoading(true);

      oneCallHistoryData.value = (await ApiClient()
          .getOneCallHistoryApi(lat: lat, lon: lon, time: time));
    } finally {
      isLoading(false);
      oneCallHistoryData.refresh();
      update();
    }
  }
}
