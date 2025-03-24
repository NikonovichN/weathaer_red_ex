import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/dto.dart';
import 'data/weather_repository.dart';

import 'bloc/weather_forecast_bloc.dart';

class HomePage extends StatelessWidget {
  final Text title;

  const HomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: DefaultTextStyle(
          style: TextStyle(fontSize: 24),
          child: title,
        ),
      ),
      body: BlocProvider(
        create: (context) => WeatherForecastBloc(
          repository: WeatherRepository(),
        )..add(WeatherLoadEvent()),
        child: _PageState(),
      ),
    );
  }
}

class _PageState extends StatelessWidget {
  const _PageState();

  static const _progressIndicator = Center(child: CircularProgressIndicator(color: Colors.white));

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherForecastBloc, WeatherForecastState>(
      builder: (context, state) {
        return switch (state) {
          WeatherForecastInitial() => _progressIndicator,
          WeatherForecastLoading() => _progressIndicator,
          WeatherForecastLoaded() => _SuccessState(weatherState: state.weather),
          WeatherForecastError() => const _ErrorState(),
        };
      },
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState();
  static const _errorText = 'Something went wrong!';
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      _errorText,
      style: TextStyle(color: Colors.white, fontSize: 20),
    ));
  }
}

class _SuccessState extends StatelessWidget {
  final WeatherForecastEntity weatherState;

  const _SuccessState({required this.weatherState});

  @override
  Widget build(BuildContext context) {
    return Column(children: weatherState.list.map((e) => Text(e.name)).toList());
  }
}
