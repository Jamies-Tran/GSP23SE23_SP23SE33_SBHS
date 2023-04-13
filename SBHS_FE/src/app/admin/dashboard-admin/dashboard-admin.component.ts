import { Component, OnInit } from '@angular/core';
import * as echarts from 'echarts';
import { EChartsOption } from 'echarts';

@Component({
  selector: 'app-dashboard-admin',
  templateUrl: './dashboard-admin.component.html',
  styleUrls: ['./dashboard-admin.component.scss']
})
export class DashboardAdminComponent implements OnInit {
  profits!: EChartsOption ;

  ngOnInit(): void {
    this.profits = {
      title: {
        text: 'Tổng doanh thu: 4.000.000',
      },
      tooltip: {
        trigger: 'axis',
        axisPointer: {
          type: 'cross',
          label: {
            backgroundColor: '#6a7985',
          },
        },
      },
      legend: {
        data: ['Doanh thu'],
      },
      toolbox: {
        feature: {
          restore: { show: true },
          saveAsImage: {},
        },
      },
      grid: {
        left: '3%',
        right: '4%',
        bottom: '3%',
        containLabel: true,
      },
      xAxis: [
        {
          type: 'category',
          name: 'Tháng',
          boundaryGap: false,
          data: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'],
        },
      ],
      yAxis: [
        {
          type: 'value',
          name: 'Tiền',
          position: 'left',
          alignTicks: true,
          axisLine: {
            show: true,
          },
          axisLabel: {
            formatter: '{value} đ',
          },
        },
      ],
      series: [
        {
          name: 'Doanh thu',
          type: 'line',
          stack: 'Total',
          tooltip: {
            formatter: '{value} đ',
          },
          emphasis: {
            focus: 'series',
          },

          // data :this.values
          data: [800000, 1000000, 3000000, 2000000, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        },
      ],
    };
  }
}
