import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import * as echarts from 'echarts';
import { EChartsOption } from 'echarts';
import { DashboardService } from 'src/app/services/dashboard.service';

@Component({
  selector: 'app-dashboard-admin',
  templateUrl: './dashboard-admin.component.html',
  styleUrls: ['./dashboard-admin.component.scss'],
})
export class DashboardAdminComponent implements OnInit {
  dashboardData: Response = {
    totalProfit: 0,
    totalLandlord: 0,
    totalPassenger: 0,
    landlordTable: [
      {
        imageUrl: '',
        name: '',
        commission: 0,
        activatingHomestays: 0,
        activatingBlocHomestays: 0,
        createdDate: '',
      },
    ],
    passengerTable: [
      {
        imageUrl: '',
        name: '',
        balance: 0,
        totalBooking: 0,
      },
    ],
  };

  constructor(private http: DashboardService) {}

  ngOnInit(): void {
    this.getDashboardData();
  }
  getDashboardData() {
    this.http.getDashboardAdmin().subscribe((data) => {
      this.dashboardData = data;
      console.log(data);
    });
  }
}
export interface Response {
  totalProfit: number;
  totalLandlord: number;
  totalPassenger: number;
  landlordTable: {
    imageUrl: string;
    name: string;
    commission: number;
    activatingHomestays: number;
    activatingBlocHomestays: number;
    createdDate: string;
  }[];
  passengerTable: {
    imageUrl: string;
    name: string;
    balance: number;
    totalBooking: number;
  }[];
}
