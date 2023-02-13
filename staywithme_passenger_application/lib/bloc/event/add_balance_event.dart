abstract class AddBalanceEvent {}

class InputBalanceEvent extends AddBalanceEvent {
  InputBalanceEvent({this.balance});

  int? balance;
}

class NavigatingToMomoEvent extends AddBalanceEvent {
  NavigatingToMomoEvent({this.payUrl});

  String? payUrl;
}

class SubmitAddBalanceEvent extends AddBalanceEvent {
  SubmitAddBalanceEvent({this.amount, this.username});

  int? amount;
  String? username;
}
