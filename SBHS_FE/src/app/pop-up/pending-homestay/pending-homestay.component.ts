import { Component, Inject } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialog } from '@angular/material/dialog';
import { MessageComponent } from '../message/message.component';
import { SuccessComponent } from '../success/success.component';

@Component({
  selector: 'app-pending-homestay',
  templateUrl: './pending-homestay.component.html',
  styleUrls: ['./pending-homestay.component.scss'],
})
export class PendingHomestayComponent {
  constructor(
    @Inject(MAT_DIALOG_DATA)
    public data: { id: StaticRangeInit; username: string },
    public dialog: MatDialog
  ) {}
  message: any;
  public accept(){

  }
  public reject(){

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
