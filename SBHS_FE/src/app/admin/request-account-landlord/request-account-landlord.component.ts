import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { ServerHttpService } from 'src/app/services/verify-landlord.service';
import { ActionPendingComponent } from '../../pop-up/action-pending/action-pending.component';
import { MessageComponent } from '../../pop-up/message/message.component';
import { SuccessComponent } from '../../pop-up/success/success.component';

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
    console.log('length:', this.valuesPending.length);
  }
  public getStatusLandlord() {
    // Pending
    this.http.getLanlord('PENDING').subscribe((data) => {
      this.valuesPending = data['userList'];
      console.log(this.valuesPending);
    });
    // Banned
    this.http.getLanlord('BANNED').subscribe((data) => {
      this.valuesBanned = data['userList'];
      console.log(this.valuesBanned);
    });
    // Active
    this.http.getLanlord('ACTIVATED').subscribe((data) => {
      this.valuesActive = data['userList'];
      console.log(this.valuesActive);
    });
    // Reject
    this.http.getLanlord('REJECT').subscribe((data) => {
      this.valuesReject = data['userList'];
      console.log(this.valuesReject);
    });
  }

  public Id = 0;
  public createBy = '';
  public rejectMessage = '';
  public username = '';

  public onItemSelector(id: number, username: string) {
    this.Id = id;
    this.username = username;
    localStorage.setItem('id', id + '');
    localStorage.setItem('username', username);
  }

  public accept() {
    console.log('Accept');
    this.http.acceptLandlord(this.username).subscribe(
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
          this.openDialogMessage();
        } else {
          this.registerError = error;
          this.message = error;
          this.openDialogMessage();
        }
      }
    );
  }
  public reject() {
    console.log('Reject');
    this.http.rejectLandlord(this.username, 'NOT_MATCHED').subscribe(
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
          this.openDialogMessage();
        } else {
          this.registerError = error;
          this.message = error;
          this.openDialogMessage();
        }
      }
    );
  }

  isChecked!: boolean;
  isCheckedAction() {
    if (this.isChecked) {
      this.accept();
    } else {
      this.reject();
    }
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
    this.dialog.open(ActionPendingComponent, {
      data: {
        id: this.Id,
        username: this.username,
      },
      disableClose: true,
    });
  }
}

export interface data {
  username: string;
  id: number;
  createdDate: string;
  type: string;
  status: string;
}
