import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_map/models/one_call_daily_Model.dart';

class WeeklyWeatherCard extends StatelessWidget {
  final List<Daily>? daily;

  const WeeklyWeatherCard({Key? key, required this.daily}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customTextTheme = Theme.of(context).textTheme;
    return Container(
        color: Colors.black,
        height: 215,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 7,
            itemBuilder: (BuildContext context, index) {
              return Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.fromLTRB(5, 10, 0, 10),
                width: 150,
                color: Colors.grey.shade900,
                child: Column(children: [
                  Container(
                    width: 150,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 5, 2),
                          child: Text(
                            //DateTime.parse(timestamp.toDate().toString())
                            DateFormat.EEEE().format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    daily![index].dt! * 1000)),
                            style: customTextTheme.headline2!
                                .copyWith(color: Colors.orange),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 5, 5),
                          child: Text(
                            '${daily![index].weather![0].description}',
                            style: customTextTheme.headline2!.copyWith(
                                fontSize: 14, color: Colors.grey.shade400),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: Image.network(
                        'http://openweathermap.org/img/wn/${daily![index].weather![0].icon}@2x.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 5, 5),
                    child: Text(
                      '${daily![index].temp!.max}°/${daily![index].temp!.min}°',
                      style: customTextTheme.headline2!
                          .copyWith(fontSize: 12, color: Colors.grey.shade400),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 5, 5),
                    child: Text(
                      '${daily![index].humidity}%',
                      style: customTextTheme.headline2!
                          .copyWith(fontSize: 12, color: Colors.grey.shade400),
                    ),
                  ),
                ]),
              );
            }));
  }
}
