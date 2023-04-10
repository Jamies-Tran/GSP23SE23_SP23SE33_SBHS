import { Dialog } from '@angular/cdk/dialog';
import { Component, Inject, OnInit } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { ActivatedRoute, Router } from '@angular/router';

@Component({
  selector: 'app-success',
  templateUrl: './success.component.html',
  styles: [`::ng-deep .mat-dialog-container {
    padding: 0%;
    width: 400px;
    border-radius: 10px;
  }

  .header {
    background-color: #00E676;
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
export class SuccessComponent implements OnInit {
  constructor(
    @Inject(MAT_DIALOG_DATA) public data: string,
    public dialogRef: MatDialogRef<Dialog>,
    private router: Router,
    private route: ActivatedRoute
  ) {}
  closeDialog(): void {
    if (localStorage.getItem('accept-landlord-detail') === 'true') {
      this.dialogRef.close();
      localStorage.setItem('accept-landlord-detail', '');

    } else if (localStorage.getItem('action-pending') === 'true') {
      this.dialogRef.close();
      localStorage.setItem('action-pending', '');

    }
    else if (localStorage.getItem('blocHomestay') === 'true') {
      this.dialogRef.close();
      localStorage.setItem('blocHomestay', '');

    }
    else if (localStorage.getItem('Homestay') === 'true') {
      this.dialogRef.close();
      localStorage.setItem('Homestay', '');

    }
    else this.dialogRef.close();
  }
  ngOnInit(): void {
    if (localStorage.getItem('accept-landlord-detail') === 'true') {
      this.dialogRef.disableClose = true;
    }
  }
}
