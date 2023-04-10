import { Component, Inject } from '@angular/core';
import { MatDialog, MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';

import { MessageComponent } from '../message/message.component';
import { SuccessComponent } from '../success/success.component';
import { AdminService } from '../../services/admin.service';
import { AccountLandlordDetailComponent } from 'src/app/admin/request-account-landlord/account-landlord-detail/account-landlord-detail.component';
import { Observable } from 'rxjs';
@Component({
  selector: 'app-action-pending',
  templateUrl: './action-pending.component.html',
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
    :host ::ng-deep .mdc-text-field--filled{
      background-color: unset !important;
    }
    :host ::ng-deep .mat-form-field-appearance-fill .mat-form-field-flex {
      background-color: unset !important;
  }
  :host ::ng-deep .mdc-text-field--filled:not(.mdc-text-field--disabled){
    background-color: unset !important;
  }
  }
  `],
})
export class ActionPendingComponent {
  constructor(
    public dialogRef: MatDialogRef<AccountLandlordDetailComponent>,
    @Inject(MAT_DIALOG_DATA) public data: {username:string , isReject:boolean},
    public dialog: MatDialog,
    private http: AdminService
  ) {}

  message: any;
  status: any;
  orther!: string;

  public reject() {
    this.data.isReject = false;
    console.log('Reject');
    console.log(this.status);
    if (this.status == 'ORTHER') {
      this.status = 'NOT_MATCHED';
    }
    this.http.rejectLandlordAccount(this.data.username, this.status).subscribe(
      (data) => {
        if (data != null)
        {
          this.data.isReject = true;
          this.message = 'Account have reject';
          this.openDialogSuccess();
          this.dialogRef.close(this.data.isReject);
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
    localStorage.setItem('action-pending', 'true');
    this.dialog.open(SuccessComponent, {
      data: this.message,
    });
  }

}
