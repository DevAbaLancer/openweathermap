import 'package:get/get.dart';

import 'package:weather_map/models/one_call_daily_Model.dart';
import 'package:weather_map/service/api_client.dart';

class OneCallDailyController extends GetxController {
  var isLoading = true.obs;
  var oneCallDailyData = OneCallDailyModel().obs;

  @override
  void onInit() {
    getOneCallDailyApi(lat: 12.9716, lon: 77.5946);
    super.onInit();
  }

  Future<void> getOneCallDailyApi({required lat, required lon}) async {
    try {
      isLoading(true);
      oneCallDailyData.value =
          await ApiClient().getOneCallDailyApi(lat: lat, lon: lon);
    } finally {
      isLoading(false);
      oneCallDailyData.refresh();
      update();
    }
  }
}
