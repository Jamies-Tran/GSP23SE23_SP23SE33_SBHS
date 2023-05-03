package com.sbhs.swm.implement;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sbhs.swm.dto.AdminDashboard;
import com.sbhs.swm.dto.LandlordBlocRecord;
import com.sbhs.swm.dto.LandlordDashBoard;
import com.sbhs.swm.dto.LandlordHomestayRecord;
import com.sbhs.swm.dto.LandlordRecord;
import com.sbhs.swm.dto.PassengerRecord;
import com.sbhs.swm.models.BlocHomestay;
import com.sbhs.swm.models.Booking;
import com.sbhs.swm.models.BookingHomestay;
import com.sbhs.swm.models.Homestay;
import com.sbhs.swm.models.LandlordCommission;
import com.sbhs.swm.models.SwmUser;
import com.sbhs.swm.models.status.BookingStatus;
import com.sbhs.swm.models.status.HomestayStatus;
import com.sbhs.swm.models.status.LandlordStatus;

import com.sbhs.swm.repositories.UserRepo;
import com.sbhs.swm.services.IDashBoardService;
import com.sbhs.swm.services.IUserService;

@Service
public class DashBoardService implements IDashBoardService {

    @Autowired
    private UserRepo userRepo;

    @Autowired
    private IUserService userService;

    @Override
    public LandlordDashBoard landlordDashBoard() {
        SwmUser user = userService.authenticatedUser();
        LandlordDashBoard landlordDashBoard = new LandlordDashBoard();
        Long totalHomestayProfit = 0L;
        Long totalBlocProfit = 0L;
        Long totalCommission = 0L;
        Long totalLandlordProfit = 0L;
        Long totalPromotion = 0L;
        List<LandlordHomestayRecord> homestayTable = new ArrayList<>();
        List<LandlordBlocRecord> blocTable = new ArrayList<>();
        if (user.getLandlordProperty().getHomestays() != null) {

            for (Homestay h : user.getLandlordProperty().getHomestays()) {
                if (h.getBloc() == null) {
                    if (h.getBookingHomestays() != null) {
                        for (BookingHomestay bh : h.getBookingHomestays()) {
                            if (bh.getStatus().equalsIgnoreCase(BookingStatus.CHECKEDOUT.name())) {
                                totalHomestayProfit = totalHomestayProfit + bh.getTotalBookingPrice();
                            }
                        }
                    }
                }
            }
        }
        if (user.getLandlordProperty().getBlocHomestays() != null) {
            for (BlocHomestay b : user.getLandlordProperty().getBlocHomestays()) {
                if (b.getBookings() != null) {
                    for (Booking bk : b.getBookings()) {
                        if (bk.getStatus().equalsIgnoreCase(BookingStatus.CHECKEDOUT.name())) {
                            totalBlocProfit = totalBlocProfit + bk.getTotalBookingPrice();
                        }
                    }
                }
            }
        }
        if (user.getLandlordProperty().getBalanceWallet().getLandlordWallet().getLandlordCommissions() != null) {
            for (LandlordCommission c : user.getLandlordProperty().getBalanceWallet().getLandlordWallet()
                    .getLandlordCommissions()) {
                totalCommission = totalCommission + c.getCommission();
            }
        }
        if (user.getLandlordProperty().getHomestays() != null) {
            for (Homestay h : user.getLandlordProperty().getHomestays()) {
                if (h.getBloc() == null) {
                    LandlordHomestayRecord homestayRecord = new LandlordHomestayRecord();
                    homestayRecord.setImgUrl(h.getHomestayImages().get(0).getImageUrl());
                    homestayRecord.setName(h.getName());
                    Long totalProfit = 0L;
                    Long totalBooking = 0L;
                    if (h.getBookingHomestays() != null) {

                        for (BookingHomestay bh : h.getBookingHomestays()) {
                            if (!bh.getStatus().equalsIgnoreCase(BookingStatus.SAVED.name())) {
                                totalBooking = totalBooking + 1;
                            }
                            if (bh.getStatus().equalsIgnoreCase(BookingStatus.CHECKEDOUT.name())) {
                                totalProfit = totalProfit + bh.getTotalBookingPrice();
                            }
                        }
                    }
                    homestayRecord.setProfit(totalProfit);
                    homestayRecord.setTotalBooking(totalBooking);
                    homestayTable.add(homestayRecord);
                }

            }
        }
        if (user.getLandlordProperty().getBlocHomestays() != null) {
            for (BlocHomestay b : user.getLandlordProperty().getBlocHomestays()) {
                LandlordBlocRecord blocRecord = new LandlordBlocRecord();
                blocRecord.setImgUrl(b.getHomestays().get(0).getHomestayImages().get(0).getImageUrl());
                blocRecord.setName(b.getName());
                Long totalProfit = 0L;
                Long totalBooking = 0L;
                if (b.getBookings() != null) {
                    for (Booking bk : b.getBookings()) {
                        if (!bk.getStatus().equalsIgnoreCase(BookingStatus.SAVED.name())) {
                            totalBooking = totalBooking + 1;
                        }
                        if (bk.getStatus().equalsIgnoreCase(BookingStatus.CHECKEDOUT.name())) {
                            totalProfit = totalProfit + bk.getTotalBookingPrice();
                        }
                    }
                }
                blocRecord.setProfit(totalProfit);
                blocRecord.setTotalBooking(totalBooking);
                blocTable.add(blocRecord);
            }

        }
        if (user.getLandlordProperty().getCampaigns() != null) {
            totalPromotion = totalPromotion + user.getLandlordProperty().getCampaigns().size();
        }
        totalLandlordProfit = totalHomestayProfit + totalBlocProfit;
        landlordDashBoard.setTotalProfit(totalLandlordProfit);
        landlordDashBoard.setTotalCommission(totalCommission);
        landlordDashBoard.setTotalPromotion(totalLandlordProfit);
        landlordDashBoard.setTotalPromotion(totalPromotion);
        landlordDashBoard.setHomestayTable(homestayTable);
        landlordDashBoard.setBlocTable(blocTable);
        return landlordDashBoard;
    }

    @Override
    public AdminDashboard adminDashboard() {
        AdminDashboard adminDashboard = new AdminDashboard();
        Long totalProfit = 0L;
        Long totalLandlord = 0L;
        Long totalPassenger = 0L;
        Long totalActivatingHomestay = 0L;
        Long totalActivatingBloc = 0L;
        List<LandlordRecord> landlordTable = new ArrayList<>();
        List<PassengerRecord> passengerTable = new ArrayList<>();

        List<SwmUser> userList = userRepo.findAll();
        for (SwmUser user : userList) {
            if (user.getLandlordProperty() != null) {
                Long totalLandlordProfit = 0L;
                LandlordRecord landlordRecord = new LandlordRecord();
                if (user.getLandlordProperty().getStatus().equalsIgnoreCase(LandlordStatus.ACTIVATING.name())) {
                    totalLandlord = totalLandlord + 1;
                }
                if (user.getLandlordProperty().getBalanceWallet().getLandlordWallet()
                        .getLandlordCommissions() != null) {
                    for (LandlordCommission c : user.getLandlordProperty().getBalanceWallet().getLandlordWallet()
                            .getLandlordCommissions()) {
                        totalProfit = totalProfit + c.getCommission();
                        totalLandlordProfit = totalLandlordProfit + c.getCommission();
                    }
                    landlordRecord.setCommission(totalLandlordProfit);
                }
                if (user.getLandlordProperty().getHomestays() != null) {
                    for (Homestay h : user.getLandlordProperty().getHomestays()) {
                        if (h.getStatus().equalsIgnoreCase(HomestayStatus.ACTIVATING.name()) && h.getBloc() == null) {
                            totalActivatingHomestay = totalActivatingHomestay + 1;
                        }
                    }
                }
                if (user.getLandlordProperty().getBlocHomestays() != null) {
                    for (BlocHomestay b : user.getLandlordProperty().getBlocHomestays()) {
                        if (b.getStatus().equalsIgnoreCase(HomestayStatus.ACTIVATING.name())) {
                            totalActivatingBloc = totalActivatingBloc + 1;
                        }
                    }
                }

                landlordRecord.setCreatedDate(user.getCreatedDate());
                landlordRecord.setImageUrl(user.getAvatarUrl());
                landlordRecord.setName(user.getUsername());
                landlordRecord.setActivatingHomestays(totalActivatingHomestay);
                landlordRecord.setActivatingBlocHomestays(totalActivatingBloc);
                landlordTable.add(landlordRecord);
            } else if (user.getPassengerProperty() != null) {
                totalPassenger = totalPassenger + 1;
                Long totalPassengerBooking = 0L;
                if (user.getPassengerProperty().getBookings() != null) {
                    for (Booking b : user.getPassengerProperty().getBookings()) {
                        if (!b.getStatus().equalsIgnoreCase(BookingStatus.SAVED.name())) {
                            totalPassengerBooking = totalPassengerBooking + 1;
                        }
                    }
                }
                PassengerRecord passengerRecord = new PassengerRecord();
                passengerRecord.setName(user.getUsername());
                passengerRecord.setImageUrl(user.getAvatarUrl());
                passengerRecord.setBalance(user.getPassengerProperty().getBalanceWallet().getTotalBalance());
                passengerRecord.setTotalBooking(totalPassengerBooking);
                passengerTable.add(passengerRecord);
            }
        }
        adminDashboard.setTotalProfit(totalProfit);
        adminDashboard.setTotalLandlord(totalLandlord);
        adminDashboard.setTotalPassenger(totalPassenger);
        adminDashboard.setPassengerTable(passengerTable);
        adminDashboard.setLandlordTable(landlordTable);
        return adminDashboard;
    }

}
