import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

// api url
final registerationUrl = "${dotenv.env["DOMAIN"]}/${dotenv.env["REGISTER"]}";

final loginUrl = "${dotenv.env["DOMAIN"]}/${dotenv.env["LOGIN"]}";

final googleLoginUrl = "${dotenv.env["DOMAIN"]}/${dotenv.env["GOOGLE_LOGIN"]}";

final sendOtpByMailUrl = "${dotenv.env["DOMAIN"]}/${dotenv.env["OTP_MAIL"]}";

final otpVerificationUrl =
    "${dotenv.env["DOMAIN"]}/${dotenv.env["OTP_VALIFICATION"]}";

final passwordModificationUrl =
    "${dotenv.env["DOMAIN"]}/${dotenv.env["PASSWORD_MODIFICATION"]}";

final emailValidateUrl =
    "${dotenv.env["DOMAIN"]}/${dotenv.env["EMAIL_VALIDATE"]}";

final registerUrl = "${dotenv.env["DOMAIN"]}/${dotenv.env["REGISTER"]}";

final userInfoUrl = "${dotenv.env["DOMAIN"]}/${dotenv.env["USER_INFORMATION"]}";

final paymentUrl = "${dotenv.env["DOMAIN"]}/${dotenv.env["PAYMENT"]}";

final paymentHistoryUrl =
    "${dotenv.env["DOMAIN"]}/${dotenv.env["PAYMENT_HISTORY"]}";

final autoCompleteUrl = "${dotenv.env["DOMAIN"]}/${dotenv.env["AUTOCOMPLETE"]}";

final cityProvincesUrl =
    "${dotenv.env["DOMAIN"]}/${dotenv.env["CITY_PROVINCE"]}";

final homestayListOrderByRatingUrl =
    "${dotenv.env["DOMAIN"]}/${dotenv.env["HOMESTAY_AVG_RATING"]}";

final blocListOrderByRatingUrl =
    "${dotenv.env["DOMAIN"]}/${dotenv.env["BLOC_AVG_RATING"]}";

final homestayNearestLocationUrl =
    "${dotenv.env["DOMAIN"]}/${dotenv.env["HOMESTAY_NEAREST_LOCATION"]}";

// common variable
final currencyFormat = NumberFormat("#,##0");
final connectionTimeOut = int.parse(dotenv.env["CONNECTION_TIMEOUT"]!);
const primaryColor = Colors.orange;
const secondaryColor = Colors.deepOrangeAccent;

String? getCityProvinceName(String cityProvince, bool shorten) {
  if (shorten) {
    switch (cityProvince) {
      case "An Giang":
        return "AG";
      case "Bà Rịa-Vũng Tàu":
        return "BV";
      case "Bạc Liêu":
        return "BL";
      case "Bắc Giang":
        return "BG";
      case "Bắc Kạn":
        return "BK";
      case "Bắc Ninh":
        return "BN";
      case "Bến Tre":
        return "BT";
      case "Bình Dương":
        return "BD";
      case "Bình Định":
        return "BĐ";
      case "Bình Phước":
        return "BP";
      case "Cà Mau":
        return "CM";
      case "Cao Bằng":
        return "CB";
      case "Cần Thơ":
        return "CT";
      case "Đà Nẵng":
        return "DNa";
      case "Đắk lắk":
        return "DL";
      case "Đắk Nông":
        return "ĐNo";
      case "Điện Biên":
        return "DB";
      case "Đồng Nai":
        return "DN";
      case "Đồng Tháp":
        return "DT";
      case "Hà Nam":
        return "HNa";
      case "Hà Giang":
        return "HG";
      case "Hà Tĩnh":
        return "HT";
      case "Hải Dương":
        return "HD";
      case "Hải Phòng":
        return "HP";
      case "Hậu Giang":
        return "HGi";
      case "Hòa Bình":
        return "HB";
      case "Hưng Yên":
        return "HY";
      case "Khánh Hòa":
        return "KH";
      case "Kiên Giang":
        return "KG";
      case "Kon Tum":
        return "KT";
      case "Lai Châu":
        return "LC";
      case "Lạng Sơn":
        return "LS";
      case "Lào Cai":
        return "LCa";
      case "Hồ Chí Minh":
        return "SG";
      case "Gia Lai":
        return "GL";
      case "Lâm Đồng":
        return "LD";
      case "Long An":
        return "LA";
      case "Nam Định":
        return "ND";
      case "Nghệ An":
        return "NA";
      case "Ninh Bình":
        return "NB";
      case "Ninh Thuận":
        return "NT";
      case "Phú Thọ":
        return "PT";
      case "Phú Yên":
        return "PY";
      case "Quảng Bình":
        return "QB";
      case "Quảng Nam":
        return "QNa";
      case "Quảng Ngãi":
        return "QNg";
      case "Quảng Ninh":
        return "QN";
      case "Quảng Trị":
        return "QT";
      case "Sóc Trăng":
        return "ST";
      case "Sơn La":
        return "SL";
      case "Tây Ninh":
        return "TN";
      case "Thái Bình":
        return "TB";
      case "Thái Nguyên":
        return "TNg";
      case "Thanh Hóa":
        return "TH";
      case "Thừa Thiên Huế":
        return "TTH";
      case "Tiền Giang":
        return "TG";
      case "Trà Vinh":
        return "TV";
      case "Tuyên Quang":
        return "TQ";
      case "Vĩnh Long":
        return "VL";
      case "Vĩnh Phúc":
        return "VP";
      case "Yên Bái":
        return "YB";
      case "Hà Nội":
        return "HN";
      case "Bình Thuận":
        return "BTh";
      default:
        return null;
    }
  } else {
    switch (cityProvince) {
      case "AG":
        return "An Giang";
      case "BV":
        return "Bà Rịa - Vũng Tàu";
      case "BL":
        return "Bạc Liêu";
      case "BG":
        return "Bắc Giang";
      case "BK":
        return "Bắc Kạn";
      case "BN":
        return "Bắc Ninh";
      case "BT":
        return "Bến Tre";
      case "BD":
        return "Bình Dương";
      case "BĐ":
        return "Bình Định";
      case "BP":
        return "Bình Phước";
      case "CM":
        return "Cà Mau";
      case "CB":
        return "Cao Bằng";
      case "CT":
        return "Cần Thơ";
      case "DNa":
        return "Đà Nẵng";
      case "DL":
        return "Đắk Lắk";
      case "ĐNo":
        return "Đắk Nông";
      case "DB  ":
        return "Điện Biên";
      case "DN":
        return "Đồng Nai";
      case "DT":
        return "Đồng Tháp";
      case "HNa":
        return "Hà Nam";
      case "HG":
        return "Hà Giang";
      case "HT":
        return "Hà Tĩnh";
      case "HD":
        return "Hải Dương";
      case "HP":
        return "Hải Phòng";
      case "HGi":
        return "Hậu Giang";
      case "HB":
        return "Hòa Bình";
      case "HY":
        return "Hưng Yên";
      case "KH":
        return "Khánh Hòa";
      case "KG":
        return "Kiên Giang";
      case "KT":
        return "Kong Tum";
      case "LC":
        return "Lai Châu";
      case "LS":
        return "Lạng Sơn";
      case "LCa":
        return "Lào Cai";
      case "SG":
        return "Hồ Chí Minh";
      case "GL":
        return "Gia Lai";
      case "HN":
        return "Hà Nội";
      case "BTh":
        return "Bình Thuận";
      case "LD":
        return "Lâm Đồng";
      case "LA":
        return "Long An";
      case "ND":
        return "Nam Định";
      case "NA":
        return "Nghệ An";
      case "NB":
        return "Ninh Bình";
      case "NT":
        return "Ninh Thuận";
      case "PT":
        return "Phú Thọ";
      case "PY":
        return "Phú Yên";
      case "QB":
        return "Quảng Bình";
      case "QNa":
        return "Quảng Nam";
      case "QNg":
        return "Quảng Ngãi";
      case "QN":
        return "Quảng Ninh";
      case "QT":
        return "Quảng Trị";
      case "ST":
        return "Sóc Trăng";
      case "SL":
        return "Sơn La";
      case "TN":
        return "Tây Ninh";
      case "TB":
        return "Thái Bình";
      case "TH":
        return "Thanh Hóa";
      case "TTH":
        return "Thừa Thiên Huế";
      case "TG":
        return "Tiền Giang";
      case "TV":
        return "Trà Vinh";
      case "TQ":
        return "Tuyên Quang";
      case "VL":
        return "Vĩnh Long";
      case "VP":
        return "Vĩnh Phúc";
      case "YB":
        return "Yên Bái";

      default:
        return null;
    }
  }
}
