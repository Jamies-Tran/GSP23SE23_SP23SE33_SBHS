import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { MessageComponent } from 'src/app/pop-up/message/message.component';
import { SuccessComponent } from 'src/app/pop-up/success/success.component';
import { BookingService } from 'src/app/services/booking.service';
import { ImageService } from 'src/app/services/image.service';

@Component({
  selector: 'app-booking',
  templateUrl: './booking.component.html',
  styleUrls: ['./booking.component.scss'],
})
export class BookingComponent implements OnInit {
  constructor(
    private http: BookingService,
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
  id:any;
  username:any;
  title = 'pagination';
  page: number = 1;
  count: number = 0;
  tableSize: number = 5;

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
      this.http.getBookingForLandlord('HOMESTAY').subscribe({
        next: (data:any) =>{
          if(data){
            const datas = data;
            console.log('datas:' , datas);
          }
        }
      })
    } catch (error) {
      this.message = error as string;
      this.openDialogMessage();
      console.log(error);
    }
  }

  getBookingBloc() {}

  public onItemSelector(id: number, createdBy: string) {
    this.id = id;
    this.username = createdBy;
    localStorage.setItem('id', id + '');
    localStorage.setItem('createdBy', createdBy);
  }
  accept(){}
  openDialogAction(){}
onTableDataChangeHomestay(event: any) {
    this.page = event;
    this.valuesHomestay;
  }
onTableDataChangeBloc(event: any) {
    this.page = event;
    this.valuesBloc;
  }
}
