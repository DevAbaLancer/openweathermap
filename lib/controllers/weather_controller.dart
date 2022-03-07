import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:weather_map/models/weather_model.dart';
import 'package:weather_map/service/api_client.dart';

class WeatherController extends GetxController {
  var isLoading = true.obs;
  var weatherData = WeatherModel().obs;

  @override
  void onInit() {
    getWeatherApi(lat: 51.5073219, lon: -0.1276474);
    super.onInit();
  }

  Future<void> getWeatherApi({required lat, required lon}) async {
    try {
      isLoading(true);
      weatherData.value = await ApiClient().getWeatherApi(lat: lat, lon: lon);
    } catch (e) {
      SnackBar(
          content: Text(
        e.toString(),
      ));
      isLoading(false);
      weatherData.refresh();
      update();
    } finally {
      isLoading(false);
      weatherData.refresh();
      update();
    }
  }
}
