import { Component, OnInit } from '@angular/core';
import { ImageService } from '../../services/image.service';
import { MatDialog } from '@angular/material/dialog';
import { HomestayService } from 'src/app/services/homestay.service';

@Component({
  selector: 'app-homestay',
  templateUrl: './homestay.component.html',
  styles: [`.wrapper {
    .container {
      .container-fluid {
        .content {
          background-color: white;
          min-height: 82vh;
          padding: 2%;

          .header-content {
            display: flex;
            flex-direction: row;
            align-items: center;
            flex-wrap: nowrap;
            margin-bottom: 10px;
            justify-content: flex-end;
            .text{
              font-size: 16px;
            }
            .btn-register{
              margin-left: 10px;
            }
          }

          .main-content {
            .col-sm-4{
              margin-bottom: 20px;
            }
            .card {
              padding: 2%;
              .image{
                max-width: 100%;
                width: 100%;
                max-height: 170px;
                height: 170px;
                display: contents;
                text-align: center;
                cursor: pointer;
                img{
                  width: 99%;
                  height: 99%;
                  max-height: 170px;
                  min-height: 170px;
                height: 170px;
                cursor: pointer;
                }
              }
              .name{
                text-align: center;
                font-size: 17px;
                font-weight: 500;
                margin: 2.5%;
                cursor: pointer;
              }
              .button {
                display: flex;
                flex-direction: row;
                justify-content: space-evenly;
              }
            }
          }
        }

      }
    }
  }
  input:-webkit-autofill,
    input:-webkit-autofill:hover,
    input:-webkit-autofill:focus,
    input:-webkit-autofill:active {
      transition: background-color 5000s ease-in-out 0s;
    }
  `],
})
export class HomestayComponent implements OnInit {
  constructor(
    private image: ImageService,
    public dialog: MatDialog,
    private http: HomestayService,
  ) {}
  valuePending: any[] = [];
  valueActivating: any[] = [];
  valueReject: any[] = [];

  isDelete = 'null';
  public username = localStorage.getItem('usernameLogined') as string;
  ngOnInit(): void {
    this.username = localStorage.getItem('usernameLogined') as string;
    console.log(this.username);
    this.getHomestayActivating();
    this.getHomestayPending();
    this.getHomestayReject();
  }

  getHomestayPending() {
    this.valuePending = [];

    this.http.getHomestayByLandlord('PENDING').subscribe(async (data) => {
      console.log('data:', data['homestays']);
      for (let i of data['homestays'].reverse()) {
        var imgUrl;
        await this.image
          .getImage('homestay/' + i.homestayImages[0].imageUrl)
          .then((url) => {
            imgUrl = url;
            this.valuePending.push({
              imgURL: imgUrl,
              name: i.name,
              id: i.id,
              status: i.status,
            });
          })
          .catch((error) => {
            console.log(error);
          });

      }
    });
  }
  getHomestayActivating() {
    this.valueActivating = [];

    this.http.getHomestayByLandlord('ACTIVATING').subscribe(async (data) => {
      console.log('data:', data['homestays']);
      for (let i of data['homestays'].reverse()) {
        var imgUrl;
        await this.image
          .getImage('homestay/' + i.homestayImages[0].imageUrl)
          .then((url) => {
            imgUrl = url;
            this.valueActivating.push({
              imgURL: imgUrl,
              name: i.name,
              id: i.id,
              status: i.status,
              totalBookingPending: i.totalBookingPending,
            });
          })
          .catch((error) => {
            console.log(error);
          });
      }
    });
  }
  getHomestayReject() {
    this.valueReject =[];

    this.http.getHomestayByLandlord('REJECTED_LICENSE_NOT_MATCHED').subscribe(async (data) => {
      console.log('data:', data['homestays']);
      for (let i of data['homestays'].reverse()) {
        var imgUrl;
        await this.image
          .getImage('homestay/' + i.homestayImages[0].imageUrl)
          .then((url) => {
            imgUrl = url;
            this.valueReject.push({
              imgURL: imgUrl,
              name: i.name,
              id: i.id,
              status: i.status,
            });
          })
          .catch((error) => {
            console.log(error);
          });
      }
    });
  }

  getHomestayName(name: string) {
    sessionStorage.setItem('name', name);
  }
  id: string = '';
  getHomestayId(id: string) {
    this.id = id;
  }

  openDialog() {
    // this.dialog.open(DeleteHomestayDialogComponent,{
    //   data : this.id
    // });
  }
}
