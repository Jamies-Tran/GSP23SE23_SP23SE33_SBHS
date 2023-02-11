import 'package:flutter_dotenv/flutter_dotenv.dart';

final connectionTimeOut = int.parse(dotenv.env["CONNECTION_TIMEOUT"]!);

// AuthentcateService Api Url
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
