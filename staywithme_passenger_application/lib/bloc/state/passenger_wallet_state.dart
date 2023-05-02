import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/passenger_model.dart';

class PassengerWalletState {
  PassengerWalletState(
      {this.user,
      this.totalBalance,
      this.totalDeposits,
      this.actualBalance,
      this.isPaymentHistory,
      this.currentDepositIndex});

  PassengerModel? user;
  int? totalBalance;
  int? totalDeposits;
  int? actualBalance;
  bool? isPaymentHistory;
  int? currentDepositIndex;

  DepositModel deposit(List<DepositModel> depositList) {
    return depositList[currentDepositIndex!];
  }
}
