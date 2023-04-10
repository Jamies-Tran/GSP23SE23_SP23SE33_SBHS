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
  styles: [`
  .container-fluid {
    margin: 0%;
    margin-top: 1%;
    width: 100%;

    .body {
      margin-top: 1%;

      .body-container {
        margin: 1% 1%;

        .mat-elevation-z8 {
          box-shadow: none !important;
        }

        table {
          width: auto;
        }

        .mat-form-field {
          font-size: 14px;
          width: 100%;
        }

        td,
        th {
          width: 10%;
        }
      }

      .border-bottom-text {
        border: 0 solid;
        border-color: inherit;
      }
    }

    .table {
      tbody {
        tr {
          height: 57px;
          line-height: 40px;
        }
      }
    }
  }

  .card {
    box-shadow: 0 0 5px #c4cacc;
    padding: 0 1%;
  }

  input:-webkit-autofill,
  input:-webkit-autofill:hover,
  input:-webkit-autofill:focus,
  input:-webkit-autofill:active {
    transition: background-color 5000s ease-in-out 0s;
  }
  `],
})
export class RequestHomestayComponent implements OnInit {
  valuesPending: data[] = [];
  valuesBanned: data[] = [];
  valuesActive: data[] = [];
  valuesReject: data[] = [];
  message!: string;
  constructor(
    public dialog: MatDialog,
    private httpHomestay: HomestayService,
    private httpAdmin: AdminService
  ) {}
  ngOnInit(): void {
    this.getStatusHomestay();
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
      console.log(data);
    });
    // Reject
    this.httpHomestay
      .getHomestayByStatus('REJECTED_LICENSE_NOT_MATCHED')
      .subscribe((data) => {
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
    sessionStorage.setItem('name', name);
  }
  public accept() {
    console.log('Accept');
    this.httpAdmin.activeHomestay(this.name).subscribe(
      (data) => {
        if (data != null) {
          this.message = ' Homestay hav accept';
          this.openDialogSuccess();
          this.getStatusHomestay();
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
  banned() {}



  // Pending
  pagePending: number = 1;
  countPending: number = 0;
  tableSizePending: number = 5;

  // Pending
  onTableDataChangePending(event: any) {
    this.pagePending = event;
    this.valuesPending;
  }

  // Banned
  onTableDataChangeBanned(event: any) {
    // this.page = event;
    // this.valuesBanned;
  }

     // Active
     pageActive: number = 1;
     countActive: number = 0;
     tableSizeActive: number = 5;
  // Active
  onTableDataChangeActive(event: any) {
    this.pageActive = event;
    this.valuesActive;
  }

   // Reject
   pageReject: number = 1;
   countReject: number = 0;
   tableSizeReject: number = 5;
  // Reject
  onTableDataChangeReject(event: any) {
    this.pageReject = event;
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
    const dialogRef = this.dialog.open(PendingHomestayComponent, {
      data: {
        name: this.name,
      },
      disableClose: true,
    });
    dialogRef.afterClosed().subscribe(()=>{
      setTimeout(() =>{
        console.log('after close');
        this.getStatusHomestay();
      } , 4000)
    })
  }
}
export interface data {
  name: string;
  id: number;
  createdDate: string;
  type: string;
  status: string;
}
