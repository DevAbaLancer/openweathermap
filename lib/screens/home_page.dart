import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:weather_map/controllers/geocoding_controller.dart';
import 'package:weather_map/controllers/one_call_daily_controller.dart';
import 'package:weather_map/controllers/weather_controller.dart';

import 'package:weather_map/screens/widgets/custom_divider.dart';
import 'package:weather_map/screens/widgets/daily_weather_card.dart';
import 'package:weather_map/screens/widgets/history_weather_card.dart';
import 'package:weather_map/screens/widgets/tile_over_lay_body.dart';
import 'package:weather_map/screens/widgets/weekly_weather_card.dart';

import '../controllers/one_call_history_controller.dart';
import 'widgets/location_search.dart';

class HomePage extends StatelessWidget {
  final GeocodingController _geocodingController =
      Get.put(GeocodingController());
  final OneCallDailyController _oneCallDailyController =
      Get.put(OneCallDailyController());
  final OneCallHistoryController _oneCallHistoryController =
      Get.put(OneCallHistoryController());
  final WeatherController _weatherModelController =
      Get.put(WeatherController());

  final RxInt _selectedIndex = 1.obs;

  HomePage({Key? key}) : super(key: key);

  void _onItemTapped(int index) {
    _selectedIndex.value = index;
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   activateApi();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final customTextTheme = Theme.of(context).textTheme;

    String cityName;
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          unselectedItemColor: Colors.grey,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 20, color: Colors.white),
                activeIcon: Icon(Icons.home, size: 20, color: Colors.orange),
                label: 'Home',
                backgroundColor: Colors.black),
            BottomNavigationBarItem(
              icon: Icon(Icons.file_copy, size: 20, color: Colors.white),
              activeIcon: Icon(Icons.file_copy, size: 20, color: Colors.orange),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite, size: 20, color: Colors.white),
              activeIcon: Icon(Icons.favorite, size: 20, color: Colors.orange),
              label: 'Saved',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications, size: 20, color: Colors.white),
              activeIcon:
                  Icon(Icons.notifications, size: 20, color: Colors.orange),
              label: 'Profile',
            ),
          ],
          type: BottomNavigationBarType.shifting,
          currentIndex: _selectedIndex.value,
          selectedItemColor: Colors.white,
          iconSize: 40,
          onTap: _onItemTapped,
          elevation: 5,
        );
      }),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _geocodingController.isLoading.value
                ? Container(
                    height: 200,
                    color: Colors.black,
                    child: Center(
                      child: Text(
                        'London',
                        style:
                            customTextTheme.headline1!.copyWith(fontSize: 40),
                      ),
                    ),
                  )
                : Container(
                    height: 200,
                    color: Colors.black,
                    child: Center(
                      child: _geocodingController.isNotNullValue.value == true
                          ? Text(
                              _geocodingController.geocodeData.value.name
                                  .toString(),
                              style: customTextTheme.headline1!
                                  .copyWith(fontSize: 40),
                            )
                          : Text(
                              'Try Again',
                              style: customTextTheme.headline1!
                                  .copyWith(fontSize: 40),
                            ),
                    ),
                  ),
            const CustomDivider(),
            LocationSearch(onTapSearch: (value) async {
              cityName = value;
              await _geocodingController.getGeocodingApi(cityName);
              FocusManager.instance.primaryFocus?.unfocus();
              if (_geocodingController.isNotNullValue.value == false) {
                Get.snackbar('Something went wrong', 'Please try again',
                    colorText: Colors.white);
              } else {
                _oneCallDailyController.getOneCallDailyApi(
                    lat: _geocodingController.geocodeData.value.lat,
                    lon: _geocodingController.geocodeData.value.lon);
                _oneCallHistoryController.getOneCallHistoryApi(
                    lat: _geocodingController.geocodeData.value.lat,
                    lon: _geocodingController.geocodeData.value.lon,
                    time: ((DateTime.now().millisecondsSinceEpoch -
                            (24 * 60 * 60 * 1000)) ~/
                        1000));
                _weatherModelController.getWeatherApi(
                    lat: _geocodingController.geocodeData.value.lat,
                    lon: _geocodingController.geocodeData.value.lon);
              }
              print(DateTime.now().millisecondsSinceEpoch -
                  (24 * 60 * 60 * 1000) -
                  19800000);
              print("cityName: $cityName");
            }),
            const CustomDivider(),
            _geocodingController.isNotNullValue.value == true
                ? Column(
                    children: [
                      Column(
                        children: [
                          GetX<WeatherController>(builder: (controller) {
                            return controller.isLoading.value
                                ? const SizedBox(
                                    height: 300,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : DailyWeatherCard(
                                    location: controller.weatherData.value.name,
                                    image: controller
                                        .weatherData.value.weather![0].icon,
                                    temp:
                                        controller.weatherData.value.main!.temp,
                                    description: controller.weatherData.value
                                        .weather![0].description,
                                    minTemp: controller
                                        .weatherData.value.main!.tempMin,
                                    maxTemp: controller
                                        .weatherData.value.main!.tempMax,
                                    feelsLike: controller
                                        .weatherData.value.main!.feelsLike,
                                    timeZone:
                                        controller.weatherData.value.timezone,
                                  );
                          }),
                          const CustomDivider(),
                          GetX<OneCallDailyController>(
                            builder: (controller) {
                              return controller.isLoading.value
                                  ? Container(
                                      height: 300,
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  : WeeklyWeatherCard(
                                      daily: controller
                                          .oneCallDailyData.value.daily,
                                    );
                            },
                          ),
                          const CustomDivider(),
                          GetX<OneCallHistoryController>(
                            builder: (controller) {
                              return controller.isLoading.value
                                  ? const SizedBox(
                                      height: 300,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        HistoryWeatherCard(
                                          image: controller.oneCallHistoryData
                                              .value.current!.weather![0].icon,
                                          temp: controller.oneCallHistoryData
                                              .value.current!.temp,
                                          description: controller
                                              .oneCallHistoryData
                                              .value
                                              .current!
                                              .weather![0]
                                              .description,
                                          humidity: controller
                                              .oneCallHistoryData
                                              .value
                                              .current!
                                              .humidity,
                                          feelsLike: controller
                                              .oneCallHistoryData
                                              .value
                                              .current!
                                              .feelsLike,
                                          date: controller.oneCallHistoryData
                                              .value.current!.dt,
                                        ),
                                        const CustomDivider(),
                                        SizedBox(
                                          height: 500,
                                          child: TileOverlayBody(
                                              lat: _geocodingController
                                                  .geocodeData.value.lat,
                                              lon: _geocodingController
                                                  .geocodeData.value.lon),
                                        ),
                                      ],
                                    );
                            },
                          ),
                        ],
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

//   void activateApi() {
    
//     _weatherModelController.getWeatherApi(lat: 51.5073219, lon: -0.1276474);

//     _oneCallDailyController.getOneCallDailyApi(
//         lat: 51.5073219, lon: -0.1276474);
//     _oneCallHistoryController.getOneCallHistoryApi(
//         lat: 51.5073219,
//         lon: -0.1276474,
//         time: ((DateTime.now().millisecondsSinceEpoch -
//                 (24 * 60 * 60 * 1000) -
//                 19800000) ~/
//             1000));
//   }
// }
