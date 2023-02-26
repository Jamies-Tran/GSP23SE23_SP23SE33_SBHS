package com.sbhs.swm.util;

import org.springframework.context.annotation.Configuration;

@Configuration
public class CityProvinceNameUtil {
    public String shortenCityName(String city) {
        switch (city) {
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
    }
}
