import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/dto.dart';
import '../data/weather_repository.dart';

part 'weather_forecast_event.dart';
part 'weather_forecast_state.dart';

class WeatherForecastBloc extends Bloc<WeatherForecastEvent, WeatherForecastState> {
  final WeatherRepository _repository;

  WeatherForecastBloc({
    required WeatherRepository repository,
  })  : _repository = repository,
        super(WeatherForecastInitial()) {
    on<WeatherLoadEvent>((event, emit) async {
      emit(WeatherForecastLoading());
      try {
        final data = await _repository.fetch();
        if (data == null) {
          throw Error();
        }
        emit(WeatherForecastLoaded(weather: data));
      } catch (_) {
        emit(WeatherForecastError());
      }
    });
  }
}
