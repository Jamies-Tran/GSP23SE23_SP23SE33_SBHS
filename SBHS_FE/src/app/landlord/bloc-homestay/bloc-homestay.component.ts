import { Component } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { HomestayService } from 'src/app/services/homestay.service';
import { ImageService } from 'src/app/services/image.service';

@Component({
  selector: 'app-bloc-homestay',
  templateUrl: './bloc-homestay.component.html',
  styleUrls: ['./bloc-homestay.component.scss']
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
  i: any;
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
    this.http.findBlocList('PENDING').subscribe(async (data) => {
      console.log('data:', data['blocs']);
      for (this.i of data['blocs'].reverse()) {
        var imgUrl;
        await this.image
          .getImage('homestay/' + this.i.homestays[0].homestayImages[0].imageUrl)
          .then((url) => {
            imgUrl = url;
            this.valuePending.push({
              imgURL: imgUrl,
              name: this.i.name,
              id: this.i.id,
              status: this.i.status,
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
    this.http.findBlocList('ACTIVATING').subscribe(async (data) => {
      console.log('data:', data['blocs']);
      for (this.i of data['blocs'].reverse()) {
        var imgUrl;
        await this.image
          .getImage('homestay/' + this.i.homestays[0].homestayImages[0].imageUrl)
          .then((url) => {
            imgUrl = url;
            this.valuePending.push({
              imgURL: imgUrl,
              name: this.i.name,
              id: this.i.id,
              status: this.i.status,
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
    this.http.findBlocList('REJECTED_LICENSE_NOT_MATCHED').subscribe(async (data) => {
      console.log('data:', data['blocs']);
      for (this.i of data['blocs'].reverse()) {
        var imgUrl;
        await this.image
          .getImage('homestay/' + this.i.homestays[0].homestayImages[0].imageUrl)
          .then((url) => {
            imgUrl = url;
            this.valuePending.push({
              imgURL: imgUrl,
              name: this.i.name,
              id: this.i.id,
              status: this.i.status,
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
