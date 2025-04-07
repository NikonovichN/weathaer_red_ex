import 'package:equatable/equatable.dart';

class WeatherForecastEntity extends Equatable {
  final List<CityWeatherEntity> list;
  const WeatherForecastEntity({required this.list});

  @override
  List<Object?> get props => [list];

  static WeatherForecastEntity fromJson(Map<String, dynamic> json) {
    return WeatherForecastEntity(
      list: (json['weather_forecasts'] as List).map((j) => CityWeatherEntity.fromJson(j)).toList(),
    );
  }
}

class CityWeatherEntity extends Equatable {
  final String name;
  final List<WeatherDataDetailsEntity> details;

  const CityWeatherEntity({
    required this.name,
    required this.details,
  });

  @override
  List<Object?> get props => [name, details];

  static CityWeatherEntity fromJson(Map<String, dynamic> json) {
    return CityWeatherEntity(
      name: json['city'],
      details: (json['forecast'] as List).map((j) => WeatherDataDetailsEntity.fromJson(j)).toList(),
    );
  }
}

class WeatherDataDetailsEntity extends Equatable {
  final DateTime date;
  final int temp;
  final String condition;
  final int precipitation;

  const WeatherDataDetailsEntity({
    required this.date,
    required this.temp,
    required this.condition,
    required this.precipitation,
  });

  @override
  List<Object?> get props => [date, temp, condition, precipitation];

  static WeatherDataDetailsEntity fromJson(Map<String, dynamic> json) {
    return WeatherDataDetailsEntity(
      date: DateTime.parse(json['date']),
      temp: json['temperature'],
      condition: json['condition'],
      precipitation: json['precipitation'],
    );
  }
}
