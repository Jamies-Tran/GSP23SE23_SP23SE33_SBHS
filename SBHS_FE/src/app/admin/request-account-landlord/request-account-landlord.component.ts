import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { ServerHttpService } from 'src/app/services/verify-landlord.service';

@Component({
  selector: 'app-request-account-landlord',
  templateUrl: './request-account-landlord.component.html',
  styleUrls: ['./request-account-landlord.component.scss'],
})
export class RequestAccountLandlordComponent implements OnInit {
  valuesFirst: data[] = [];
  valuesSecond: data[] = [];
  message!: string;
  public statusFirst = 'Pending';
  public statusSecond = 'All';
  registerError: string = '';
  constructor(private http: ServerHttpService, public dialog: MatDialog) {}
  ngOnInit(): void {
    this.getStatusLandlordFirst();
    this.getStatusLandlordSecond();
  }
  public getStatusLandlordFirst() {
    this.http.getLanlord(this.statusFirst).subscribe(
      (data) => {
        this.valuesFirst = data;
        console.log('data', this.valuesFirst);
      },
      (error) => {
        console.log(error);
      }
    );
  }
  public getStatusLandlordSecond() {
    this.http.getLanlord(this.statusSecond).subscribe(
      (data) => {
        this.valuesSecond = data;
        console.log('data', this.valuesSecond);
      },
      (error) => {
        console.log(error);
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

  onTableDataChangeFirst(event: any) {
    this.page = event;
    this.valuesFirst;
  }
  onTableSizeChangeFirst(event: any): void {
    this.tableSize = event.target.value;
    this.page = 1;
    this.valuesFirst;
  }

  onTableDataChangeSecond(event: any) {
    this.page = event;
    this.valuesSecond;
  }
  onTableSizeChangeSecond(event: any): void {
    this.tableSize = event.target.value;
    this.page = 1;
    this.valuesSecond;
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
  createdBy: string;
  id: number;
  createdDate: string;
  type: string;
  status: string;
}
