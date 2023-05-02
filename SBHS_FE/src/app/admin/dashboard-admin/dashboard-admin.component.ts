import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import * as echarts from 'echarts';
import { EChartsOption } from 'echarts';

@Component({
  selector: 'app-dashboard-admin',
  templateUrl: './dashboard-admin.component.html',
  styleUrls: ['./dashboard-admin.component.scss']
})
export class DashboardAdminComponent implements OnInit {
  profits!: EChartsOption ;
  public role = localStorage.getItem('role');
  constructor(
    private router: Router,
  private route: ActivatedRoute,
  ){}
  ngOnInit(): void {
    this.role = localStorage.getItem('role');
    if(this.role == "LANDLORD" && this.router.url.includes('/Admin')){
      this.router.navigate(['/Landlord/Dashboard'], {
        relativeTo: this.route,});
    } else if(this.role == "ADMIN"){

    }
  }
}
