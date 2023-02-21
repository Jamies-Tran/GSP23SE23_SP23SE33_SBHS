import 'dart:async';

import 'package:staywithme_passenger_application/bloc/event/main_screen_event.dart';
import 'package:staywithme_passenger_application/bloc/state/main_screen_state.dart';

class MainScreenBloc {
  final eventController = StreamController<MainScreenEvent>();
  final stateController = StreamController<MainScreenState>();

  int? _index = 0;

  MainScreenState initialData(int? startingIndex) =>
      MainScreenState(index: startingIndex ?? _index);

  MainScreenBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  void eventHandler(MainScreenEvent event) {
    if (event is TapNavigationBarEvent) {
      _index = event.index;
    }

    stateController.sink.add(MainScreenState(index: _index));
  }

  void dispose() {
    eventController.close();
    stateController.close();
  }
}
