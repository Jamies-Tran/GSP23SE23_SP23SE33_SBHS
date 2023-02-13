class AddBalanceState {
  AddBalanceState({this.balance});

  int? balance;

  String? validateBalance() {
    if (balance == null) {
      return "Please input balance";
    } else if (balance == 0) {
      return "Balance must be equal or greater than 1,000 VND";
    }

    return null;
  }
}
