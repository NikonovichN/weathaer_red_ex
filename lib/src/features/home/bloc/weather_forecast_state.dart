part of 'weather_forecast_bloc.dart';

sealed class WeatherForecastState extends Equatable {
  const WeatherForecastState();

  @override
  List<Object> get props => [];
}

final class WeatherForecastInitial extends WeatherForecastState {}

final class WeatherForecastLoading extends WeatherForecastState {}

final class WeatherForecastLoaded extends WeatherForecastState {
  final WeatherForecastEntity weather;
  const WeatherForecastLoaded({required this.weather});
  @override
  List<Object> get props => [weather];
}

final class WeatherForecastError extends WeatherForecastState {}
