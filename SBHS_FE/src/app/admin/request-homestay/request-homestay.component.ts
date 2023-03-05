import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { MessageComponent } from '../../pop-up/message/message.component';
import { SuccessComponent } from '../../pop-up/success/success.component';

import { PendingHomestayComponent } from '../../pop-up/pending-homestay/pending-homestay.component';

@Component({
  selector: 'app-request-homestay',
  templateUrl: './request-homestay.component.html',
  styleUrls: ['./request-homestay.component.scss']
})
export class RequestHomestayComponent implements OnInit{
  valuesPending: data[] = [];
  valuesBanned: data[] = [];
  valuesActive: data[] = [];
  valuesReject: data[] = [];
  message!: string;
  constructor(public dialog: MatDialog){}
  ngOnInit(): void {

  }
  public Id = 0;
  public createBy = '';
  public rejectMessage = '';
  public name = '';

  public onItemSelector(id: number, name: string) {
    this.Id = id;
    this.name = name;
    localStorage.setItem('homestayId', id + '');
    localStorage.setItem('homestayName', name);
  }
  accept(){

  }

  reject(){

  }
  banned(){

  }

  title = 'pagination';
  page: number = 1;
  count: number = 0;
  tableSize: number = 5;

  // Pending
  onTableDataChangePending(event: any) {
    this.page = event;
    this.valuesPending;
  }

  // Banned
  onTableDataChangeBanned(event: any) {
    this.page = event;
    this.valuesBanned;
  }

  // Active
  onTableDataChangeActive(event: any) {
    this.page = event;
    this.valuesActive;
  }

  // Reject
  onTableDataChangeReject(event: any) {
    this.page = event;
    this.valuesReject;
  }


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

  openDialogAction() {
    this.dialog.open(PendingHomestayComponent, {
      data: {
        id: this.Id,
        username: this.name,
      },
      disableClose: true,
    });
  }
}
export interface data {
  name: string;
  id: number;
  createdDate: string;
  type: string;
  status: string;
}
