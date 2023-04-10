import { Component, Inject, OnInit } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';

@Component({
  selector: 'app-message',
  templateUrl: './message.component.html',
  styles: [`::ng-deep .mat-dialog-container {
    padding: 0%;
    width: 400px;
    border-radius: 10px;
  }

  .header {
    background-color: #f44336;
    height: 130px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    align-content: center;
    flex-wrap: nowrap;
  min-width: 40vw;
    .mat-18 {

      color: white;
      font-size: 60px;
      height: auto;
      width: auto;
    }
  }

  .warnning {
    font-size: 18px;
    font-weight: 600;
    color: white;
  }

  .container {
    padding: 10px 30px;

    .text {
      p {
        text-align: center;
        font-size: 16px;
        margin-top: 12px;
      margin-bottom: 0;
      word-break: break-word;
      }
    }

    .button {
      display: flex;
      justify-content: space-evenly;
      align-items: center;
      align-content: center;

      .cancel {
        background: white;
        padding: 0 25px;
        margin: 10px 0;
        font-size: 17px;
      }

    }
  }
  `],
})
export class MessageComponent implements OnInit {
  constructor(
    @Inject(MAT_DIALOG_DATA) public data: string,
    public dialogRef: MatDialogRef<MessageComponent>
  ) {}

  ngOnInit(): void {
    if (localStorage.getItem('action-pending') === 'true') {
      this.dialogRef.disableClose = true;
    }
    if (localStorage.getItem('account-landlord-detail') === 'true') {
      this.dialogRef.disableClose = true;
    }
  }

  getReload() {
    if (localStorage.getItem('action-pending') === 'true') {
      this.dialogRef.close();
      localStorage.setItem('action-pending', '');

    }
    else if (localStorage.getItem('account-landlord-detail') === 'true') {
      this.dialogRef.close();
      localStorage.setItem('account-landlord-detail', '');

    }
    else this.dialogRef.close();
  }
}
