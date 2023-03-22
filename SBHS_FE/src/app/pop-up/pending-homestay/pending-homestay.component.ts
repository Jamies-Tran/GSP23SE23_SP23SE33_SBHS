import { Component, Inject } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialog } from '@angular/material/dialog';
import { MessageComponent } from '../message/message.component';
import { SuccessComponent } from '../success/success.component';

import { AdminService } from '../../services/admin.service';

@Component({
  selector: 'app-pending-homestay',
  templateUrl: './pending-homestay.component.html',
  styleUrls: ['./pending-homestay.component.scss'],
})
export class PendingHomestayComponent {
  constructor(
    @Inject(MAT_DIALOG_DATA)
    public data: { id: StaticRangeInit; name: string },
    public dialog: MatDialog,
    private http: AdminService
  ) {}
  message: any;
  public accept() {
    console.log('Accept');
    this.http.activeHomestay(this.data.name).subscribe(
      (data) => {
        if (data != null) {
          this.message = 'Account have accept';
          this.openDialogSuccess();
          location.reload();
        }
        console.log(data);
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
  public reject() {
    console.log('Reject');
    this.http.rejectHomestay(this.data.name).subscribe(
      (data) => {
        if (data != null) {
          this.message = 'Account have reject';
          this.openDialogSuccess();
          location.reload();
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
