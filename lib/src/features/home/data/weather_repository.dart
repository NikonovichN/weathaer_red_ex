import 'dart:convert';

import 'package:flutter/services.dart';

import 'dto.dart';

class WeatherRepository {
  const WeatherRepository();

  Future<WeatherForecastEntity?> fetch() async {
    try {
      String data = await rootBundle.loadString("assets/weather_data.json");
      final response = jsonDecode(data);
      return WeatherForecastEntity.fromJson(response);
    } catch (_) {
      // TODO: handle this case
      return null;
    }
  }
}
