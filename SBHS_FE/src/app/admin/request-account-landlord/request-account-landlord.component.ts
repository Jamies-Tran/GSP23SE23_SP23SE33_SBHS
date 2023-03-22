import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { ActionPendingComponent } from '../../pop-up/action-pending/action-pending.component';
import { MessageComponent } from '../../pop-up/message/message.component';
import { SuccessComponent } from '../../pop-up/success/success.component';
import { ImageService } from '../../services/image.service';
import { AdminService } from '../../services/admin.service';

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
  constructor(private http: AdminService, public dialog: MatDialog,private image: ImageService,) {}
  ngOnInit(): void {
    this.getStatusLandlord();
    console.log('length:', this.valuesPending.length);
  }
  public getStatusLandlord() {
    // Pending
    this.http.getLandlordListFilterByStatus('PENDING').subscribe((data) => {
      this.valuesPending = data['userList'];
      console.log(this.valuesPending);
    });
    // Banned
    this.http.getLandlordListFilterByStatus('BANNED').subscribe((data) => {
      this.valuesBanned = data['userList'];
      console.log(this.valuesBanned);
    });
    // Active
    this.http.getLandlordListFilterByStatus('ACTIVATED').subscribe((data) => {
      this.valuesActive = data['userList'];
      console.log(this.valuesActive);
    });
    // Reject
    this.http.getLandlordListFilterByStatus('REJECT').subscribe((data) => {
      this.valuesReject = data['userList'];
      console.log(this.valuesReject);
    });
  }




  public Id = 0;
  public createBy = '';
  public rejectMessage = '';
  public username = '';

  public onItemSelector(id: number, createdBy: string) {
    this.Id = id;
    this.username = createdBy;
    localStorage.setItem('id', id + '');
    localStorage.setItem('createdBy', createdBy);
  }

  public accept() {
    console.log('Accept');
    this.http.activateLandlordAccount(this.username).subscribe(
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
    this.http.rejectLandlordAccount(this.username, 'NOT_MATCHED').subscribe(
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
    this.dialog.open(ActionPendingComponent, {
      data: {
        username: this.username,
      },
      disableClose: true
    });

  }
}

export interface data {
  username: string;
  id: number;
  createdDate: string;
  type: string;
  status: string;
  avatarUrl:string;
  email:string;
}
