import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { MessageComponent } from 'src/app/pop-up/message/message.component';
import { SuccessComponent } from 'src/app/pop-up/success/success.component';
import { HomestayService } from 'src/app/services/homestay.service';
import { ImageService } from 'src/app/services/image.service';

@Component({
  selector: 'app-booking',
  templateUrl: './booking.component.html',
  styleUrls: ['./booking.component.scss'],
})
export class BookingComponent implements OnInit {
  constructor(
    private http: HomestayService,
    public dialog: MatDialog,
    private image: ImageService
  ) {}
  ngOnInit(): void {
    this.getBookingBloc();
    this.getBookingHomestay();
  }

  valuesHomestay: any[] = [];
  valuesBloc: any[] = [];
  message!: string;
  id: any;
  username: any;
  title = 'pagination';
  page: number = 1;
  count: number = 0;
  tableSize: number = 5;
  i: any;

  openDialogMessage() {
    this.dialog.open(MessageComponent, {
      data: this.message,
    });
  }
  openDialogSuccess() {
    this.dialog.open(SuccessComponent, {
      data: this.message,
    });
  }
  getBookingHomestay() {
    this.valuesHomestay = [];
    try {
      this.http.getHomestayByLandlord('ACTIVATING').subscribe(async (data) => {
        console.log('data:', data['homestays']);
        for (this.i of data['homestays'].reverse()) {
          var imgUrl;
          await this.image
            .getImage('homestay/' + this.i.homestayImages[0].imageUrl)
            .then((url) => {
              imgUrl = url;
              this.valuesHomestay.push({
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
    } catch (error) {
      this.message = error as string;
      this.openDialogMessage();
      console.log(error);
    }
  }

  getBookingBloc() {
    this.valuesBloc = [];
    this.http.getBlocByLandlord('ACTIVATING').subscribe(async (data) => {
      console.log('data:', data['blocs']);
      for (this.i of data['blocs'].reverse()) {
        var imgUrl;
        await this.image
          .getImage(
            'homestay/' + this.i.homestays[0].homestayImages[0].imageUrl
          )
          .then((url) => {
            imgUrl = url;
            this.valuesBloc.push({
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

  public onItemSelector(id: number, createdBy: string) {
    this.id = id;
    this.username = createdBy;
    localStorage.setItem('id', id + '');
    localStorage.setItem('createdBy', createdBy);
  }
  accept() {}
  openDialogAction() {}
  onTableDataChangeHomestay(event: any) {
    this.page = event;
    this.valuesHomestay;
  }
  onTableDataChangeBloc(event: any) {
    this.page = event;
    this.valuesBloc;
  }
}
