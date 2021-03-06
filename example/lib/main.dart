import 'package:common_state/common_state.dart';
import 'package:common_state/source/request/blocking_request.dart';
import 'package:example/widgets/generic_dialog.dart';
import 'package:example/widgets/generic_error.dart';
import 'package:example/widgets/generic_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'api_service.dart';
import 'fetch_weather_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();

    CommonStateHandling.registerCommonErrorWidget((context, error, showRetry, onRetry) {
      return GenericError(error: error, retryEnabled: showRetry, onRetry: onRetry,);
    });

    CommonStateHandling.registerCommonLoadingWidget((context) {
      return GenericLoading();
    });

    CommonStateHandling.registerBlockingDialogWidget((context, child, state) {
      return GenericDialog(child: child, state: state);
    });

    return MaterialApp(
      title: 'Common State Handling',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SomeScreen(),
    );
  }
}

class SomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: BlocProvider(
            create: (context) => FetchWeatherBloc(), child: WeatherCard()),
      ),
    );
  }
}

class WeatherCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        children: <Widget>[
          Card(
            child: Container(
              margin: const EdgeInsets.all(12.0),
              height: 180.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Inline with click'),
                  Expanded(
                    child: InLayoutRequestWidget<Weather, FetchWeatherBloc>(
                      BlocProvider.of<FetchWeatherBloc>(context),
                      builder: (context, weather) {
                        return Container(
                            alignment: Alignment.center,
                            child: Text(weather.condition + " in " + weather.city));
                      },
                      buildInitial: (context) {
                        return InkWell(
                          onTap: (){
                            BlocProvider.of<FetchWeatherBloc>(context).makeRequest();
                          },
                          child: Container(
                              alignment: Alignment.center,
                              child: Text('Click here to get weather')),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
