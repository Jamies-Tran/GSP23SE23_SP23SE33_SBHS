import { Component, Inject } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialog } from '@angular/material/dialog';
import { MessageComponent } from '../message/message.component';
import { SuccessComponent } from '../success/success.component';

import { AdminService } from '../../services/admin.service';
import { ActivatedRoute, Router } from '@angular/router';

@Component({
  selector: 'app-pending-homestay',
  templateUrl: './pending-homestay.component.html',
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
  .text{
    height: 100px;
  }
  `],
})
export class PendingHomestayComponent {
  constructor(
    @Inject(MAT_DIALOG_DATA)
    public data: { name: string },
    public dialog: MatDialog,
    private http: AdminService,
    private router: Router,
    private route: ActivatedRoute
  ) {}
  message: any;

  public reject() {
    console.log('Reject');
    if (localStorage.getItem('blocHomestay') == 'true') {
      this.http.rejectBlocHomestay(this.data.name).subscribe(
        (data) => {
          if (data != null) {
            this.message = 'Bloc Homestay have reject';
            this.openDialogSuccess();
          }
        },
        (error) => {
          if (error['status'] == 500) {
            // this.registerError = 'please check your information again!';
            this.message = error;
            this.openDialogMessage();
          } else {
            // this.registerError = error;
            this.message = error;
            this.openDialogMessage();
          }
        }
      );
    } else {
      this.http.rejectHomestay(this.data.name).subscribe(
        (data) => {
          if (data != null) {
            this.message = 'Homestay have reject';
            this.openDialogSuccess();

          }
        },
        (error) => {
          if (error['status'] == 500) {
            // this.registerError = 'please check your information again!';
            this.message = error;
            this.openDialogMessage();
          } else {
            // this.registerError = error;
            this.message = error;
            this.openDialogMessage();
          }
        }
      );
    }
  }

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
}
