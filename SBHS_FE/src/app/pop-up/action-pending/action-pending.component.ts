import { Component, Inject } from '@angular/core';
import { MatDialog, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { ServerHttpService } from 'src/app/services/verify-landlord.service';
import { MessageComponent } from '../message/message.component';
import { SuccessComponent } from '../success/success.component';
@Component({
  selector: 'app-action-pending',
  templateUrl: './action-pending.component.html',
  styleUrls: ['./action-pending.component.scss'],
})
export class ActionPendingComponent {
  constructor(
    @Inject(MAT_DIALOG_DATA)
    public data: { id: StaticRangeInit; username: string },
    public dialog: MatDialog,
    private http: ServerHttpService
  ) {}

  message: any;
  status: any;

  public accept() {
    console.log('Accept');
    this.http.acceptLandlord(this.data.username).subscribe(
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
          this.message = 'please check your information again!';
          this.openDialogMessage();
        } else {
          this.message = error;
          this.openDialogMessage();
        }
      }
    );
  }

  public reject() {
    console.log('Reject');
    console.log(this.status);
    this.http.rejectLandlord(this.data.username, this.status).subscribe(
      (data) => {
        if (data != null) {
          this.message = 'Account have reject';
          this.openDialogSuccess();
          location.reload();
        }
      },
      (error) => {
        if (error['status'] == 500) {
          this.message = 'please check your information again!';
          this.openDialogMessage();
        } else {
          this.message = error.message;
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
