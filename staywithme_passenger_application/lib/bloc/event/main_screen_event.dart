abstract class MainScreenEvent {}

class TapNavigationBarEvent extends MainScreenEvent {
  TapNavigationBarEvent({this.index});

  int? index;
}
