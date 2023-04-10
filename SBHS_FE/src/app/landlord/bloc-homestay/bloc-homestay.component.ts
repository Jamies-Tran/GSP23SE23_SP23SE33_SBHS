import { Component } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { HomestayService } from 'src/app/services/homestay.service';
import { ImageService } from 'src/app/services/image.service';

@Component({
  selector: 'app-bloc-homestay',
  templateUrl: './bloc-homestay.component.html',
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
  `]
})
export class BlocHomestayComponent {
  constructor(
    private image: ImageService,
    public dialog: MatDialog,
    private http: HomestayService
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
    this.http.getBlocByLandlord('PENDING').subscribe(async (data) => {
      console.log('data:', data);
      for (let i of data['blocs'].reverse()) {
        var imgUrl;
        await this.image
          .getImage('homestay/' + i.homestays[0].homestayImages[0].imageUrl)
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
    this.http.getBlocByLandlord('ACTIVATING').subscribe(async (data) => {
      console.log('data:', data['blocs']);
      for (let i of data['blocs'].reverse()) {
        var imgUrl;
        await this.image
          .getImage('homestay/' + i.homestays[0].homestayImages[0].imageUrl)
          .then((url) => {
            imgUrl = url;
            this.valueActivating.push({
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
  getHomestayReject() {
    this.valueReject =[];
    this.http.getBlocByLandlord('REJECTED_LICENSE_NOT_MATCHED').subscribe(async (data) => {
      console.log('data:', data['blocs']);
      for (let i of data['blocs'].reverse()) {
        var imgUrl;
        await this.image
          .getImage('homestay/' + i.homestays[0].homestayImages[0].imageUrl)
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
