import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { MessageComponent } from '../../pop-up/message/message.component';
import { SuccessComponent } from '../../pop-up/success/success.component';

import { PendingHomestayComponent } from '../../pop-up/pending-homestay/pending-homestay.component';
import { HomestayService } from '../../services/homestay.service';
import { AdminService } from '../../services/admin.service';

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
  constructor(public dialog: MatDialog,private httpHomestay: HomestayService, private httpAdmin: AdminService ){}
  ngOnInit(): void {
    this.getStatusHomestay();
    if(localStorage.getItem('isAccept') == 'true'){
      this.message = 'Account have accept';
      this.openDialogSuccess();
      localStorage.setItem('isAccept' , '');
    }
  }

  public getStatusHomestay() {
  // Pending
  this.httpHomestay.getHomestayByStatus('PENDING').subscribe((data) => {
    this.valuesPending = data['homestays'];
    console.log(this.valuesPending);
  });
  // Banned
  this.httpHomestay.getHomestayByStatus('BANNED').subscribe((data) => {
    this.valuesBanned = data['homestays'];
    console.log(this.valuesBanned);
  });
  // Active
  this.httpHomestay.getHomestayByStatus('ACTIVATING').subscribe((data) => {
    this.valuesActive = data['homestays'];
    console.log(this.valuesActive);
  });
  // Reject
  this.httpHomestay.getHomestayByStatus('REJECTED_LICENSE_NOT_MATCHED').subscribe((data) => {
    this.valuesReject = data['homestays'];
    console.log(this.valuesReject);
  });


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
  public accept() {
    console.log('Accept');
    this.httpAdmin.activeHomestay(this.name).subscribe(
      (data) => {
        if (data != null) {
                    localStorage.setItem('isAccept' , 'true');
          location.reload();
        }
        console.log(data);
      },
      (error) => {
          this.message = error;
          this.openDialogMessage();

      }
    );
  }

  public reject() {
    console.log('Reject');
    this.httpAdmin.rejectHomestay(this.name).subscribe(
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
        name: this.name,
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
