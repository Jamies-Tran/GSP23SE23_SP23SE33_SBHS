import { Component, OnInit } from '@angular/core';
import * as echarts from 'echarts';
import { EChartsOption } from 'echarts';
import { DashboardService } from 'src/app/services/dashboard.service';
@Component({
  selector: 'app-dashboard-landlord',
  templateUrl: './dashboard-landlord.component.html',
  styleUrls: ['./dashboard-landlord.component.scss'],
})
export class DashboardLandlordComponent implements OnInit {
  dashboardData: Response = {
    totalProfit: 0,
    totalPromotion: 0,
    totalCommission: 0,
    homestayTable: [
      {
        imgUrl: '123 pass-sign-or-stamp-vector-22523712 - Copy.jpg',
        name: '123',
        profit: 0,
        totalBooking: 0,
      },
    ],
    blocTable: [
      {
        imgUrl: '1233 pass-sign-or-stamp-vector-22523712 - Copy.jpg',
        name: 'quan 9',
        profit: 0,
        totalBooking: 0,
      },
    ],
  };

  constructor(private http: DashboardService) {}

  ngOnInit(): void {
    this.getDashboardData();
  }
  getDashboardData() {
    this.http.getDashboardLandlord().subscribe((data) => {
      this.dashboardData = data;
      console.log(data);
    });
  }
}
export interface Response {
  totalProfit: number;
  totalPromotion: number;
  totalCommission: number;
  homestayTable: {
    imgUrl: string;
    name: string;
    profit: number;
    totalBooking: number;
  }[];
  blocTable: {
    imgUrl: string;
    name: string;
    profit: number;
    totalBooking: number;
  }[];
}
