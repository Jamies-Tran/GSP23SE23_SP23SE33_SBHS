import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { ServerHttpService } from 'src/app/services/verify-landlord.service';

@Component({
  selector: 'app-request-account-landlord',
  templateUrl: './request-account-landlord.component.html',
  styleUrls: ['./request-account-landlord.component.scss'],
})
export class RequestAccountLandlordComponent implements OnInit {
  valuesPending: data[] = [];
  valuesBanned: data[] = [];
  valuesActive: data[] = [];
  valuesReject: data[] = [];
  message!: string;
  registerError: string = '';
  constructor(private http: ServerHttpService, public dialog: MatDialog) {}
  ngOnInit(): void {
    this.getStatusLandlord();

  }
  public getStatusLandlord() {
    // Pending
    this.http.getLanlord("NOT_ACTIVATED").subscribe((data) => {
      this.valuesPending = data['userList'];
        console.log(this.valuesPending);
      }
    );
    // Banned
    this.http.getLanlord("BANNED").subscribe((data) => {
      this.valuesPending = data['userList'];
        console.log(this.valuesBanned);
      }
    );
    // Active
    this.http.getLanlord("ACTIVATED").subscribe((data) => {
      this.valuesPending = data['userList'];
        console.log(this.valuesActive);
      }
    );
    // Reject
    this.http.getLanlord("REJECT").subscribe((data) => {
      this.valuesPending = data['userList'];
        console.log(this.valuesReject);
      }
    );

  }

  public Id = 0;
  public createBy = '';
  public isAccept = true;
  public isReject = false;
  public rejectMessage = '';
  public onItemSelector(id: number, createdBy: string) {
    this.Id = id;
    localStorage.setItem('id', id + '');
    localStorage.setItem('createdBy', createdBy);
  }
  public accept() {
    this.http
      .verifyLandlord(this.Id + '', this.isAccept, this.rejectMessage)
      .subscribe(
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
            this.registerError = 'please check your information again!';
            this.message = this.registerError;
            this.openDialog();
          } else {
            this.registerError = error;
            this.message = error;
            this.openDialog();
          }
        }
      );
  }
  public reject() {
    this.http
      .verifyLandlord(this.Id + '', this.isReject, this.rejectMessage)
      .subscribe(
        (data) => {
          if (data != null) {
            this.message = 'Account have reject';
            this.openDialogSuccess();
            location.reload();
          }
        },
        (error) => {
          if (error['status'] == 500) {
            this.registerError = 'please check your information again!';
            this.message = this.registerError;
            this.openDialog();
          } else {
            this.registerError = error;
            this.message = error;
            this.openDialog();
          }
        }
      );
  }

  title = 'pagination';
  page: number = 1;
  count: number = 0;
  tableSize: number = 5;
  tableSizes: any = [5, 10, 15, 20];

  // Pending
  onTableDataChangePending(event: any) {
    this.page = event;
    this.valuesPending;
  }
  onTableSizeChangePending(event: any): void {
    this.tableSize = event.target.value;
    this.page = 1;
    this.valuesPending;
  }

  // Banned
  onTableDataChangeBanned(event: any) {
    this.page = event;
    this.valuesBanned;
  }
  onTableSizeChangeBanned(event: any): void {
    this.tableSize = event.target.value;
    this.page = 1;
    this.valuesBanned;
  }

  // Active
  onTableDataChangeActive(event: any) {
    this.page = event;
    this.valuesActive;
  }
  onTableSizeChangeActive(event: any): void {
    this.tableSize = event.target.value;
    this.page = 1;
    this.valuesActive;
  }

  // Reject
  onTableDataChangeReject(event: any) {
    this.page = event;
    this.valuesReject;
  }
  onTableSizeChangeReject(event: any): void {
    this.tableSize = event.target.value;
    this.page = 1;
    this.valuesReject;
  }

  // dialog error
  openDialog() {
    // this.dialog.open(MessageComponent, {
    //   data: this.message,
    // });
  }
  openDialogSuccess() {
    // this.dialog.open(SuccessComponent, {
    //   data: this.message,
    // });
  }
}

export interface data {
  username: string;
  id: number;
  createdDate: string;
  type: string;
  status: string;
}
