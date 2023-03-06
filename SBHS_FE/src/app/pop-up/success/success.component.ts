import { Dialog } from '@angular/cdk/dialog';
import { Component, Inject, OnInit } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';

@Component({
  selector: 'app-success',
  templateUrl: './success.component.html',
  styleUrls: ['./success.component.scss']
})
export class SuccessComponent implements OnInit{
  constructor(@Inject(MAT_DIALOG_DATA) public data: string, public dialogRef: MatDialogRef<Dialog>) {}
  closeDialog(): void {

    if (localStorage.getItem('accept-landlord-detail') === 'true') {
      this.dialogRef.close();
      localStorage.setItem('accept-landlord-detail', '');
      location.reload();
    }
    else this.dialogRef.close();
  }
  ngOnInit(): void {
    if (localStorage.getItem('accept-landlord-detail') === 'true') {
      this.dialogRef.disableClose = true;
    }
  }
}
