import { Component, Inject } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialog } from '@angular/material/dialog';
import { BookingService } from 'src/app/services/booking.service';
import { MessageComponent } from '../message/message.component';
import { SuccessComponent } from '../success/success.component';

@Component({
  selector: 'app-booking-pending',
  templateUrl: './booking-pending.component.html',
  styles: [`::ng-deep .mat-dialog-container{
    padding: 0%;
      width: 500px;
      border-radius: 10px;
  }

  .header{
    background-image: linear-gradient(to right, #FFCE03cc, #FD9A01cc, #FD6104cc, #FF2C05cc);
      height: 130px;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      align-content: center;
      flex-wrap: nowrap;
  .mat-18{

    color: white;
      font-size: 60px;
      height: auto;
      width: auto;
  }
  }
  .warnning{
    font-size: 18px;
    font-weight: 600;
    color: white;
  }
  .container{
    padding: 10px 20px;
    .button{
      display: flex;
      justify-content: space-evenly;
      align-items: center;
      align-content: center;
      .cancel{
        background: #c6c2c2;
      color: white;
      border-radius: 17px;
      margin: 10px 0;
      font-size: 17px;
      }
      .delete{
        background: #f44336;
      color: white;
      border-radius: 17px;
      margin: 10px 0;
      font-size: 17px;
      }
    }
  }
  `]
})
export class BookingPendingComponent {
  constructor(
    @Inject(MAT_DIALOG_DATA)
    public data: {  bookingId:number; homestayId:number; },
    public dialog: MatDialog,
    private http: BookingService
  ) {}
  reason !: string;
  message: any;
  openDialogMessage() {
    localStorage.setItem('action-pending', 'true');
    this.dialog.open(MessageComponent, {
      data: this.message,
    });
  }
  openDialogSuccess() {
    this.dialog.open(SuccessComponent, {
      data: this.message,
    });
  }

  reject(){
    try {
      this.http.rejectBookingForHomestay(this.data.bookingId , this.data.homestayId, this.reason).subscribe({
        next:(data:any) =>{
          this.message = "Reject Booking Homestay Success";
          this.openDialogSuccess();
        },
        error: (error)=>{
          this.message= error;
          this.openDialogMessage();
        }
      }
      )
    } catch (error) {
      this.message = error as string;
      this.openDialogMessage();
      console.log(error);
    }
  }
}
