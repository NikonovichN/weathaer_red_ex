import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
        child: DefaultTextStyle(
          style: TextStyle(color: Colors.white),
          child: _PageState(),
        ),
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
      style: TextStyle(fontSize: 20),
    ));
  }
}

class _SuccessState extends StatefulWidget {
  final WeatherForecastEntity weatherState;

  const _SuccessState({required this.weatherState});

  @override
  State<_SuccessState> createState() => __SuccessStateState();
}

class __SuccessStateState extends State<_SuccessState> {
  PageController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      children: widget.weatherState.list.map((e) => _WeatherDisplay(data: e)).toList(),
    );
  }
}

class _WeatherDisplay extends StatelessWidget {
  final CityWeatherEntity data;

  static const _sevenDayForecast = '7-DAY WEATHER FORECAST';

  const _WeatherDisplay({required this.data});

  @override
  Widget build(BuildContext context) {
    final firstDay = data.details[0];
    final formatter = DateFormat('EEEE, MMM d, y');
    return SizedBox(
      height: 400,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Text(
              data.name,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 20.0),
            Text(
              formatter.format(firstDay.date),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 36.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.sunny,
                  color: Colors.white,
                  size: 80.0,
                ),
                const SizedBox(width: 20.0),
                Column(
                  children: [
                    Text(
                      '${firstDay.temp.toString()} °C',
                      style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.w300),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      firstDay.condition,
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 120.0),
            Text(
              _sevenDayForecast,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              height: 140,
              child: _HorizontalForecast(
                forecast: data.details.sublist(0, 7),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _HorizontalForecast extends StatelessWidget {
  final List<WeatherDataDetailsEntity> forecast;
  const _HorizontalForecast({required this.forecast});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemExtent: 220.0,
      itemCount: forecast.length,
      itemBuilder: (context, indx) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: _DayView(
            data: forecast[indx],
          ),
        );
      },
    );
  }
}

class _DayView extends StatelessWidget {
  final WeatherDataDetailsEntity data;

  const _DayView({required this.data});

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('EEEE');
    return Container(
      width: 320.0,
      height: 280,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(92, 255, 255, 255),
      ),
      child: Column(
        children: [
          Text(
            formatter.format(data.date),
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w300),
          ),
          const SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                '${data.temp.toString()} °C',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w300),
              ),
              Icon(
                Icons.sunny,
                color: Colors.white,
                size: 40.0,
              ),
            ],
          )
        ],
      ),
    );
  }
}
