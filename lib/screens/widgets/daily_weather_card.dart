import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class DailyWeatherCard extends StatelessWidget {
  final String? location;
  final String? image;
  final double? temp;
  final String? description;
  final double? minTemp;
  final double? maxTemp;
  final double? feelsLike;
  final int? timeZone;

  const DailyWeatherCard({
    Key? key,
    this.location,
    this.image,
    this.temp,
    this.description,
    this.minTemp,
    this.maxTemp,
    this.feelsLike,
    this.timeZone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customTextTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 15, 5, 10),
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(
              Icons.pin_drop_outlined,
              color: Colors.orange,
              size: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5),
              child: Text(
                location ?? '',
                style: customTextTheme.headline2!
                    .copyWith(fontSize: 20, color: Colors.orange),
              ),
            )
          ]),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 10),
            child: Text(
              //DateTime.parse(timestamp.toDate().toString())
              DateFormat.yMMMMEEEEd().format(
                DateTime.fromMillisecondsSinceEpoch(
                    DateTime.now().millisecondsSinceEpoch +
                        (timeZone! * 1000) -
                        (19800 * 1000)),
              ),
              style: customTextTheme.headline2!
                  .copyWith(color: Colors.grey.shade400),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: Image.network(
                    'http://openweathermap.org/img/wn/$image@2x.png'),
              ),
              Text(
                '$temp°',
                style: customTextTheme.headline2!
                    .copyWith(fontSize: 40, fontWeight: FontWeight.w100),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 5, 5),
                      child: Text(
                        description ?? '',
                        style: customTextTheme.headline2!.copyWith(
                            fontSize: 12, color: Colors.grey.shade400),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 5, 5),
                      child: Text(
                        '$maxTemp°/$minTemp°',
                        style: customTextTheme.headline2!.copyWith(
                            fontSize: 12, color: Colors.grey.shade400),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 5, 5),
                      child: Text(
                        'Feels like $feelsLike',
                        style: customTextTheme.headline2!.copyWith(
                            fontSize: 12, color: Colors.grey.shade400),
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
