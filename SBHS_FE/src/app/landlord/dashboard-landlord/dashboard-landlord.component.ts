import { Component , OnInit} from '@angular/core';
import * as echarts from 'echarts';
import { EChartsOption } from 'echarts';
@Component({
  selector: 'app-dashboard-landlord',
  templateUrl: './dashboard-landlord.component.html',
  styles: [`
  .container {
    min-height: 89vh;

    .row-header {
      margin: 30px 0;

      .card-body {

        padding: 16px 15px 16px;

        .fa-solid,
        .fa-coins {
          font-size: 3em;
        }
      }
    }

    .card {
      box-shadow: 0 6px 10px -4px rgb(0 0 0 / 15%);

      .numbers {
        text-align: right;
        font-size: 2em;

        p {
          height: 45px;
          font-size: 16px;
          line-height: 1.4em;
          word-break: break-word;
        }
        .inline{
          line-height: 45px;
        }
      }

      .card-footer {
        padding: 0 15px 15px;
        background-color: unset;
        border-top: unset;

        hr {
          margin-top: 0;
          margin-bottom: 15px;

        }

        .status {
          color: #88837a;
          font-weight: 300;
          font-size: 1rem;

          p {
            text-align: center;
          }
        }
      }
    }

    .chart {
      .card {
        margin-bottom: 30px;
      }
    }

    .card-chart-detail {
      .chart-header {
        font-size: 16px;
      }

      .chart-money {
        p {
          font-size: 2em;
        }

      }

      .pull-right {
        float: right;
        span{

        border-radius: 1rem;
        padding: 1px 6px;
        }
        .label-green{
          background-color: yellowgreen;
        }
        .label-blue{
          background-color: #18FFFF;
        }
        .label-red{
          background-color: #EE6666;
          padding: 1px 9px;
        }

      }


       .yellowgreen{
        border-left: 2px yellowgreen solid;
      }
      .blue{
        border-left: 2px #18FFFF solid;
      }
       .red{
        border-left: 2px #F50057 solid;
      }
    }
  }
  input:-webkit-autofill,
    input:-webkit-autofill:hover,
    input:-webkit-autofill:focus,
    input:-webkit-autofill:active {
      transition: background-color 5000s ease-in-out 0s;
    }

    .bot-organe{
      border-bottom: 3px solid #FF6D00;
    }
    .bot-red{
      border-bottom: 3px solid #F50057;
    }
    .bot-yellogreen{
      border-bottom: 3px solid yellowgreen;
    }
    .bot-blue{
      border-bottom: 3px solid #18FFFF;
    }
  `]
})
export class DashboardLandlordComponent implements OnInit {
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
