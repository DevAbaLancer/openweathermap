import 'package:get/get.dart';
import 'package:weather_map/models/geocoding_model.dart';
import 'package:weather_map/service/api_client.dart';

class GeocodingController extends GetxController {
  var isLoading = true.obs;
  var geocodeData = GeocodingModel().obs;
  var isNotNullValue = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> getGeocodingApi(cityName) async {
    try {
      isLoading(true);
      geocodeData.value = await ApiClient().getGeocodingApi(cityName);
      if (geocodeData.value.name == null) {
        isNotNullValue(false);
      } else {
        isNotNullValue(true);
      }
    } finally {
      isLoading(false);
      geocodeData.refresh();
      update();
    }
  }
}
